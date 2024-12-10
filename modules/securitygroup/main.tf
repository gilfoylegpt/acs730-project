resource "aws_security_group" "public_websg" {
  name        = "${var.env}-public-web_sg"
  description = "allow ssh and web from internet"
  vpc_id      = var.network_datablock.outputs.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.default_tags, {
      "Name" = "${var.prefix}-${var.env}-public-websg"
    }
  )
}

resource "aws_security_group" "private_websg" {
  name        = "${var.env}-private_websg"
  description = "allow ssh and web from vpc"
  vpc_id      = var.network_datablock.outputs.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.network_datablock.outputs.vpc_cidr]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.network_datablock.outputs.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.default_tags, {
      "Name" = "${var.prefix}-${var.env}-private-websg"
    }
  )
}

resource "aws_security_group" "private_onlyssh-sg" {
  name        = "${var.env}-private_onlyssh-sg"
  description = "allow ssh from vpc"
  vpc_id      = var.network_datablock.outputs.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.network_datablock.outputs.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.default_tags, {
      "Name" = "${var.prefix}-${var.env}-private-onlyssh-sg"
    }
  )
}
