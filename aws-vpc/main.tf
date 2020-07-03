resource "aws_vpc" "default" {
  count = var.create_vpc ? 1 : 0
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
      Name = var.environment
      Owner = var.name
  }
}

resource "aws_subnet" "public_subnet" {
  count = var.create_vpc ? length(var.public_subnet) : 0
  vpc_id = aws_vpc.default[0].id
  cidr_block = cidrsubnet(var.cidr_block, 8, count.index)
  tags = {
      Name = format("%s-public-subnet-%d", var.environment, count.index)
      Owner = var.name
  }
}

resource "aws_subnet" "private_subnet" {
  count = var.create_vpc ? length(var.public_subnet) : 0
  vpc_id = aws_vpc.default[0].id
  cidr_block = cidrsubnet(var.cidr_block, 8, count.index+length(var.public_subnet))
  tags = {
      Name = format("%s-private-subnet-%d", var.environment, count.index)
      Owner = var.name
  }
}

resource "aws_internet_gateway" "default" {
  count = var.create_vpc ? 1 : 0
  vpc_id = aws_vpc.default[0].id
  tags = {
      Name = format("%s-igw", var.environment)
      Owner = var.name
  }
}

resource "aws_eip" "nat_gateway" {
  count = var.create_vpc && length(var.private_subnet)>0 ? 1 : 0
  vpc = true
  tags = {
      Name = format("%s-eip", var.environment)
      Owner = var.name
  }
}

resource "aws_nat_gateway" "default" {
  count = var.create_vpc && length(var.private_subnet)>0 ? 1 : 0
  allocation_id = aws_eip.nat_gateway[0].id
  subnet_id = aws_subnet.public_subnet[count.index].id
  tags = {
      Name = format("%s-nat-gw", var.environment)
      Owner = var.name
  }
}

resource "aws_route_table" "public_subnet" {
  count = var.create_vpc && length(var.public_subnet)>0 ? 1 : 0
  vpc_id = aws_vpc.default[0].id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.default[0].id
  }
  tags = {
      Name = format("%s-public-rt", var.environment)
      Owner = var.name
  }
}

resource "aws_route_table_association" "public_subnet" {
  count = var.create_vpc && length(var.public_subnet)>0 ? length(var.public_subnet) : 0
  route_table_id = aws_route_table.public_subnet[0].id
  subnet_id = aws_subnet.public_subnet[count.index].id
}

resource "aws_route_table" "private_subnet" {
  count = var.create_vpc && length(var.private_subnet)>0 ? 1 : 0
  vpc_id = aws_vpc.default[0].id
  route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.default[0].id
  }
  tags = {
      Name = format("%s-private-rt", var.environment)
      Owner = var.name
  }
}

resource "aws_route_table_association" "private_subnet" {
  count = var.create_vpc && length(var.private_subnet)>0 ? length(var.private_subnet) : 0
  route_table_id = aws_route_table.private_subnet[0].id
  subnet_id = aws_subnet.private_subnet[count.index].id
}
