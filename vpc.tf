resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "swai-vpc"
  }
}

# Public

## Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "swai-igw"
  }
}

## Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "swai-public-rt"
  }
}

## Public Subnet
resource "aws_subnet" "public_subnet_a" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "swai-public-a"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "swai-public-b"
  }
}

resource "aws_subnet" "public_subnet_c" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-northeast-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = "swai-public-c"
  }
}

## Attach Public Subnet in Route Table
resource "aws_route_table_association" "public_a_association" {
  subnet_id = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_b_association" {
  subnet_id = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_c_association" {
  subnet_id = aws_subnet.public_subnet_c.id
  route_table_id = aws_route_table.public_rt.id
}

# Private

## Elastic IP
resource "aws_eip" "nat_a_eip" {
}

resource "aws_eip" "nat_b_eip" {
}

resource "aws_eip" "nat_c_eip" {
}

## NAT Gateway
resource "aws_nat_gateway" "nat_a" {
  depends_on = [aws_internet_gateway.igw]

  allocation_id = aws_eip.nat_a_eip.id
  subnet_id     = aws_subnet.public_subnet_b.id

  tags = {
    Name = "swai-natgw-a"
  }
}

resource "aws_nat_gateway" "nat_b" {
  depends_on = [aws_internet_gateway.igw]

  allocation_id = aws_eip.nat_b_eip.id
  subnet_id = aws_subnet.public_subnet_b.id

  tags = {
    Name = "swai-natgw-b"
  }
}

resource "aws_nat_gateway" "nat_c" {
  depends_on = [aws_internet_gateway.igw]

  allocation_id = aws_eip.nat_c_eip.id
  subnet_id = aws_subnet.public_subnet_c.id

  tags = {
    Name = "swai-natgw-c"
  }
}

## Route Table
resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "swai-private-a-rt"
  }
}

resource "aws_route_table" "private_b" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "swai-private-b-rt"
  }
}

resource "aws_route_table" "private_c" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "swai-private-c-rt"
  }
}

resource "aws_route" "private_a" {
  route_table_id = aws_route_table.private_a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_a.id
}

resource "aws_route" "private_b" {
  route_table_id = aws_route_table.private_b.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_b.id
}

resource "aws_route" "private_c" {
  route_table_id = aws_route_table.private_c.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_c.id
}

resource "aws_subnet" "private_a" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "swai-private-a"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "ap-northeast-2b"

  tags = {
    Name = "swai-private-b"
  }
}

resource "aws_subnet" "private_c" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.5.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "swai-private-c"
  }
}

## Attach Private Subnet in Route Table
resource "aws_route_table_association" "private_a" {
  subnet_id = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_a.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_b.id
}

resource "aws_route_table_association" "private_c" {
  subnet_id = aws_subnet.private_c.id
  route_table_id = aws_route_table.private_c.id
}