locals {
  availability_zone_suffix = ["a", "b", "c"]
}

data "aws_region" "current" {}

resource "aws_vpc" "morpheus" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
}

resource "aws_subnet" "morpheus" {
  for_each          = toset(var.subnet_cidr_blocks)
  vpc_id            = aws_vpc.morpheus.id
  cidr_block        = each.value
  availability_zone = "${data.aws_region.current.name}${local.availability_zone_suffix[index(var.subnet_cidr_blocks, each.value)]}"
}

resource "aws_internet_gateway" "egress" {
  vpc_id = aws_vpc.morpheus.id
}

resource "aws_route" "morpheus" {
  route_table_id         = aws_vpc.morpheus.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.egress.id
  depends_on             = [aws_vpc.morpheus, aws_internet_gateway.egress]
}