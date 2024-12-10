resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = merge(
    var.default_tags, {
      Name = "${var.prefix}-${var.env}-vpc"
    }
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    var.default_tags, {
      Name = "${var.prefix}-${var.env}-igw"
    }
  )
}

resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.azones.names[count.index]
  tags = merge(
    var.default_tags, {
      Name = "${var.prefix}-${var.env}-public-subnet-${count.index}"
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(
    var.default_tags, {
      Name = "${var.prefix}-${var.env}-public-rt"
    }
  )
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.azones.names[count.index]
  tags = merge(
    var.default_tags, {
      Name = "${var.prefix}-${var.env}-private-subnet-${count.index}"
    }
  )
}

resource "aws_eip" "natip" {
  vpc = true
  tags = merge(
    var.default_tags, {
      Name = "${var.prefix}-${var.env}-natip"
    }
  )
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.natip.id
  subnet_id     = aws_subnet.public[0].id
  tags = merge(
    var.default_tags, {
      Name = "${var.prefix}-${var.env}-natgw"
    }
  )

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }
  tags = merge(
    var.default_tags, {
      Name = "${var.prefix}-${var.env}-private-rt"
    }
  )
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
