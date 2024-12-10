output "public_instance_ids" {
  value = aws_instance.public[*].id
}

output "public_instance_ips" {
  value = aws_instance.public[*].public_ip
}

output "webserver5_id" {
  value = aws_instance.webserver5.id
}

output "webserver5_ip" {
  value = aws_instance.webserver5.private_ip
}

output "vm6_id" {
  value = aws_instance.vm6.id
}

output "vm6_ip" {
  value = aws_instance.vm6.private_ip
}
