output "vpcid" {
  value = aws_vpc.main.id
}

output "azs" {
  value = local.az_names
}

output "public_subnet" {
  value = aws_subnet.public[*].id
}

output "private_subnet" {
  value = aws_subnet.private[*].id
}
