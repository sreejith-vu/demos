resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = merge(var.tags, { "Name" = "${var.name}-vpc" })
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidr_blocks) != 0 ? length(var.public_subnet_cidr_blocks) : 0
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = merge(var.tags, { "Name" = "${var.name}-public-subnet-${count.index + 1}" })
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidr_blocks) != 0 ? length(var.private_subnet_cidr_blocks) : 0
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = merge(var.tags, { "Name" = "${var.name}-private-subnet-${count.index + 1}" })
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, { "Name" = "${var.name}-igw" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = merge(var.tags, { "Name" = "${var.name}-public-rt" })
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidr_blocks) != 0 ? length(var.public_subnet_cidr_blocks) : 0
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


resource "aws_eip" "nat_gateway" {
  domain = "vpc"
  tags   = merge(var.tags, { "Name" = "${var.name}-eip-nat" })
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.public[var.nat_gateway_zone].id
  tags          = merge(var.tags, { "Name" = "${var.name}-nat-gw" })
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
  tags = merge(var.tags, { "Name" = "${var.name}-private-rt" })

}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidr_blocks) != 0 ? length(var.private_subnet_cidr_blocks) : 0
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}