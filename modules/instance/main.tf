resource "aws_instance" "public" {
  count                       = length(var.network_datablock.outputs.public_subnet_ids)
  ami                         = var.instance_image_id
  instance_type               = var.instance_type
  key_name                    = var.ssh_key_pair_name
  subnet_id                   = var.network_datablock.outputs.public_subnet_ids[count.index]
  security_groups             = [var.public_websg_id]
  associate_public_ip_address = true
  user_data                   = count.index < 2 ? file("${path.module}/install_httpd.sh") : null
  tags = merge(
    var.default_tags, {
      "Name" = "${var.prefix}-${var.env}-webserver-${count.index}"
    }
  )
}

# resource "null_resource" "create_ami" {
#   provisioner "local-exec" {
#     command = <<EOF
#     INSTANCE_STATE=$(aws ec2 describe-instances --instance-ids ${aws_instance.public[0].id} --query "Reservations[0].Instances[0].State.Name" --output text --region us-east-1)
#     until [ "$INSTANCE_STATE" == "running" ]; do
#       echo "Waiting for instance to be in running state..."
#       sleep 10
#       INSTANCE_STATE=$(aws ec2 describe-instances --instance-ids ${aws_instance.public[0].id} --query "Reservations[0].Instances[0].State.Name" --output text --region us-east-1)
#     done
#     echo "Instance is in running state!"

#     INSTANCE_PUBLIC_IP=$(aws ec2 describe-instances --instance-ids ${aws_instance.public[0].id} --query "Reservations[0].Instances[0].PublicIpAddress" --output text --region us-east-1)
#     until [ "$INSTANCE_PUBLIC_IP" != "None" ] && [ -n "$INSTANCE_PUBLIC_IP" ]; do
#       echo "Waiting for public IP to be assigned..."
#       sleep 10
#       INSTANCE_PUBLIC_IP=$(aws ec2 describe-instances --instance-ids ${aws_instance.public[0].id} --query "Reservations[0].Instances[0].PublicIpAddress" --output text --region us-east-1)
#     done
#     echo "Public IP is available: $INSTANCE_PUBLIC_IP"

#     until $(curl --output /dev/null --silent --head --fail http://${aws_instance.public[0].public_ip}:80); do
#       echo "Waiting for HTTP service to start..."
#       sleep 10
#     done
#     echo "HTTP service is up and running!"

#     EXISTING_AMI_ID=$(aws ec2 describe-images \
#       --filters "Name=name,Values=${var.prefix}-${var.env}-webserver-ami" \
#       --query "Images[0].ImageId" \
#       --output text --region us-east-1 || echo "null")

#     if [ "$EXISTING_AMI_ID" != "None" ] && [ "$EXISTING_AMI_ID" != "null" ]; then
#       echo "Deleting existing AMI: $EXISTING_AMI_ID"
#       aws ec2 deregister-image --image-id $EXISTING_AMI_ID --region us-east-1
#     else
#       echo "No existing AMI found. Skipping deletion."
#     fi

#     echo "Creating new AMI..."
#     aws ec2 create-image --instance-id ${aws_instance.public[0].id} \
#       --name "${var.prefix}-${var.env}-webserver-ami" \
#       --no-reboot \
#       --query 'ImageId' \
#       --region us-east-1 \
#       --output text > /tmp/${var.env}-ami-id.txt
#     EOF
#   }

#   depends_on = [aws_instance.public]
# }

resource "aws_instance" "webserver5" {
  ami             = var.instance_image_id
  instance_type   = var.instance_type
  key_name        = var.ssh_key_pair_name
  subnet_id       = var.network_datablock.outputs.private_subnet_ids[0]
  security_groups = [var.private_websg_id]
  user_data       = file("${path.module}/install_httpd.sh")
  tags = merge(
    var.default_tags, {
      "Name" = "${var.prefix}-${var.env}-webserver-5"
    }
  )
}

resource "aws_instance" "vm6" {
  ami             = var.instance_image_id
  instance_type   = var.instance_type
  key_name        = var.ssh_key_pair_name
  subnet_id       = var.network_datablock.outputs.private_subnet_ids[1]
  security_groups = [var.private_onlysshsg_id]
  tags = merge(
    var.default_tags, {
      "Name" = "${var.prefix}-${var.env}-vm-6"
    }
  )
}
