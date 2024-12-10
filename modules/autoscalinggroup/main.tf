resource "aws_launch_template" "template" {
  depends_on             = [null_resource.wait_for_ami]
  name                   = "${var.env}-webserver-template"
  image_id               = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.public_websg_id]
  user_data              = base64encode(file("${path.module}/install_httpd.sh"))

  tag_specifications {
    resource_type = "instance"
    tags = merge(var.default_tags, {
      "Name" = "${var.prefix}-${var.env}-webserver-template"
    })
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "null_resource" "wait_for_ami" {
  provisioner "local-exec" {
    command = <<EOF
    echo "Checking AMI state..."
    AMI_STATE="pending"
    while [ "$AMI_STATE" != "available" ]; do
      sleep 10
      AMI_STATE=$(aws ec2 describe-images \
        --image-ids ${var.ami_id} \
        --query "Images[0].State" \
        --region us-east-1 \
        --output text)
      echo "AMI state: $AMI_STATE"
    done
    echo "AMI is now available!"
    EOF
  }
}

resource "aws_autoscaling_group" "autoscaling" {
  depends_on                = [null_resource.wait_for_ami]
  name                      = "${var.env}-asg"
  vpc_zone_identifier       = var.network_datablock.outputs.public_subnet_ids
  desired_capacity          = 2
  max_size                  = 4
  min_size                  = 1
  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.template.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }

  target_group_arns = [var.target_group_arn]

  tag {
    key                 = "Name"
    value               = "${var.prefix}-${var.env}-asg"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_up_policy" {
  name                    = "${var.env}-scale-up-policy"
  scaling_adjustment      = 1
  adjustment_type         = "ChangeInCapacity"
  cooldown                = 30
  autoscaling_group_name  = aws_autoscaling_group.autoscaling.name
  metric_aggregation_type = "Average"
}

resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "${var.env}-scale-up-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 30
  statistic           = "Average"
  threshold           = 20
  alarm_description   = "Alarm when CPU > 20% for 30 seconds"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.autoscaling.name
  }
  alarm_actions = [aws_autoscaling_policy.scale_up_policy.arn]
}

resource "aws_autoscaling_policy" "scale_down_policy" {
  name                    = "${var.env}-scale-down-policy"
  scaling_adjustment      = -1
  adjustment_type         = "ChangeInCapacity"
  cooldown                = 30
  autoscaling_group_name  = aws_autoscaling_group.autoscaling.name
  metric_aggregation_type = "Average"
}

resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "${var.env}-scale-down-alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 30
  statistic           = "Average"
  threshold           = 10
  alarm_description   = "Alarm when CPU < 10% for 30 seconds"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.autoscaling.name
  }
  alarm_actions = [aws_autoscaling_policy.scale_down_policy.arn]
}
