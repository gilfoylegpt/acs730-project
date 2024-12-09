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

resource "null_resource" "create_ami" {
  provisioner "local-exec" {
    command = <<EOF
    aws ec2 create-image --instance-id ${aws_instance.public[0].id} \
    --name "${var.prefix}-${var.env}-webserver-ami" \
    --no-reboot \
    --query 'ImageId' \
    --region us-east-1 \
    --output text > /tmp/${var.env}-ami-id.txt
    EOF
  }

  depends_on = [aws_instance.public]
}

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
