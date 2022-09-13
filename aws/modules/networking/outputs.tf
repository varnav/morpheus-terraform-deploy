output "vpc_id" {
  value = aws_vpc.morpheus.id
}
output "subnet_info" {
  value = aws_subnet.morpheus
}