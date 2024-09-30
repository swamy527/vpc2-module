resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.dns_hostnames

  tags = merge(var.common_tags, var.vpc_tags, {
    Name = "${var.project_name}-${var.environment}"
  })

}



resource "aws_internet_gateway" "mygw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags, var.mygw_tags, {
    Name = "${var.project_name}-${var.environment}"
  })
}

resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr[count.index]
  availability_zone = local.az_names[count.index]

  tags = {
    Name = "public-${local.az_names[count.index]}"
  }
}


resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = local.az_names[count.index]

  tags = {
    Name = "private-${local.az_names[count.index]}"
  }
}

resource "aws_eip" "lib" {
  domain = "vpc"
}

resource "aws_nat_gateway" "mynat" {
  allocation_id = aws_eip.lib.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "Nat-gateway"
  }
  depends_on = [aws_internet_gateway.mygw]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mygw.id
}


resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.mynat.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidr)
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[count.index].id

}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidr)
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private[count.index].id

}
