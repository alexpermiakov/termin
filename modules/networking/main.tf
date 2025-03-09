resource "aws_vpc" "termin_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    "Name" = "termin_vpc"
  }
}

resource "aws_subnet" "termin_subnet" {
  vpc_id                  = aws_vpc.termin_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true

  tags = {
    "Name" : "10.0.2.0 - eu-central-1a"
  }
}

resource "aws_security_group" "termin_sg" {
  vpc_id = aws_vpc.termin_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

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
  subnet_id      = aws_subnet.termin_subnet.id
  route_table_id = aws_route_table.termin_rt.id
}

# resource "aws_instance" "test_ec2" {
#   ami                    = "ami-0265dc4673f9d6a35"
#   instance_type          = "t2.small"
#   subnet_id              = aws_subnet.termin_subnet.id
#   vpc_security_group_ids = [aws_security_group.termin_sg.id]
#   key_name               = "test-key-pair"

#   tags = {
#     "Name" = "test_ec2"
#   }
# }

