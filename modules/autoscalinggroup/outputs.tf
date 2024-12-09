output "autoscaling_group_arn" {
  value = aws_autoscaling_group.autoscaling.arn
}

output "template_arn" {
  value = aws_launch_template.template.arn
}
