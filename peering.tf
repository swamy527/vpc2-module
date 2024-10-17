resource "aws_vpc_peering_connection" "vpc_peering" {
  count       = var.is_peering_required ? 1 : 0
  peer_vpc_id = var.acceptor_vpc_id == "" ? data.aws_vpc.default.id : var.acceptor_vpc_id
  vpc_id      = aws_vpc.main.id
  auto_accept = var.acceptor_vpc_id == "" ? true : false
  tags = {
    Name = "${var.project_name}-${var.environment}"
  }
}

resource "aws_route" "accept_route" {
  count                     = var.is_peering_required && var.acceptor_vpc_id == "" ? 1 : 0
  route_table_id            = data.aws_route_table.default.id
  destination_cidr_block    = var.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering[0].id
}

resource "aws_route" "public_route" {
  count                     = var.is_peering_required && var.acceptor_vpc_id == "" ? 1 : 0
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering[0].id
}

resource "aws_route" "private_route" {
  count                     = var.is_peering_required && var.acceptor_vpc_id == "" ? 1 : 0
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering[0].id
}

resource "aws_route" "database_route" {
  count                     = var.is_peering_required && var.acceptor_vpc_id == "" ? 1 : 0
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering[0].id
}
