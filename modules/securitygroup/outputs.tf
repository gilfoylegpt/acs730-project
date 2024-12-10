output "public_websg_id" {
  value = aws_security_group.public_websg.id
}

output "private_websg_id" {
  value = aws_security_group.private_websg.id
}

output "private_onlysshsg_id" {
  value = aws_security_group.private_onlyssh-sg.id
}

