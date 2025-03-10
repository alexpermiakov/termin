output "vpc_id" {
  value = aws_vpc.termin_vpc.id
}

output "public_subnet_1a_id" {
  value = aws_subnet.termin_public_subnet_1a.id
}

output "public_subnet_1b_id" {
  value = aws_subnet.termin_public_subnet_1b.id
}
