resource "aws_vpc" "termin_vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    "Name" = "termin_vpc"
  }
}

resource "aws_subnet" "termin_public_subnet_1a" {
  vpc_id                  = aws_vpc.termin_vpc.id
  cidr_block              = var.subnet_cidr_blocks[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = {
    "Name" : "public_subnet_1a"
  }
}

resource "aws_subnet" "termin_public_subnet_1b" {
  vpc_id                  = aws_vpc.termin_vpc.id
  cidr_block              = var.subnet_cidr_blocks[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true

  tags = {
    "Name" : "public_subnet_1b"
  }
}

resource "aws_subnet" "termin_private_subnet_1a" {
  vpc_id                  = aws_vpc.termin_vpc.id
  cidr_block              = var.subnet_cidr_blocks[2]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = false

  tags = {
    "Name" : "private_subnet_1a"
  }
}

resource "aws_network_acl" "public_nacl" {
  vpc_id = aws_vpc.termin_vpc.id
  ingress {
    rule_no    = 100
    action     = "allow"
    protocol   = "tcp"
    from_port  = 80
    to_port    = 80
    cidr_block = "0.0.0.0/0"
  }

  egress {
    rule_no    = 100
    action     = "allow"
    protocol   = "tcp"
    from_port  = 0
    to_port    = 0
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_network_acl_association" "public_nacl_assoc_1a" {
  network_acl_id = aws_network_acl.public_nacl.id
  subnet_id      = aws_subnet.termin_public_subnet_1a.id
}

resource "aws_network_acl_association" "public_nacl_assoc_1b" {
  network_acl_id = aws_network_acl.public_nacl.id
  subnet_id      = aws_subnet.termin_public_subnet_1b.id
}

resource "aws_security_group" "termin_sg" {
  vpc_id = aws_vpc.termin_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"        = "termin_sg"
    "Description" = "termin_sg"
  }
}

resource "aws_internet_gateway" "termin_ig" {
  vpc_id = aws_vpc.termin_vpc.id

  tags = {
    "Name" = "termin_ig"
  }
}

resource "aws_route_table" "termin_rt" {
  vpc_id = aws_vpc.termin_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.termin_ig.id
  }

  tags = {
    "Name" = "termin_rt"
  }
}

resource "aws_route_table_association" "termin_rta" {
  subnet_id      = aws_subnet.termin_public_subnet_1a.id
  route_table_id = aws_route_table.termin_rt.id
}
