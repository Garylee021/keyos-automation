# VPC ROUTE SERVER
resource "aws_vpc_route_server" "keyos_route_server" {
  amazon_side_asn = 65011
  tags = {
    Name = join("-", [var.prefix, "keyos-route-server"])
  }
}

# VPC ROUTE SERVER ASSOCIATION
resource "aws_vpc_route_server_vpc_association" "keyos_association" {
  route_server_id = aws_vpc_route_server.keyos_route_server.route_server_id
  vpc_id          = aws_vpc.transit_vpc.id
}

# VPC ROUTE SERVER ENDPOINTS
resource "aws_vpc_route_server_endpoint" "keyos_01_endpoint" {
  route_server_id = aws_vpc_route_server.keyos_route_server.route_server_id
  subnet_id       = aws_subnet.transit_vpc_private_subnet_01.id

  tags = {
    Name = join("-", [var.prefix, "keyos-route-server", "keyos-01"])
  }

  depends_on = [
    aws_vpc_route_server_vpc_association.keyos_association
  ]
}

resource "aws_vpc_route_server_endpoint" "keyos_02_endpoint" {
  route_server_id = aws_vpc_route_server.keyos_route_server.route_server_id
  subnet_id       = aws_subnet.transit_vpc_private_subnet_02.id

  tags = {
    Name = join("-", [var.prefix, "keyos-route-server", "keyos-02"])
  }

  depends_on = [
    aws_vpc_route_server_vpc_association.keyos_association
  ]

}

# VPC ROUTE SERVER PEERS
resource "aws_vpc_route_server_peer" "keyos_01_peer" {
  route_server_endpoint_id = aws_vpc_route_server_endpoint.keyos_01_endpoint.route_server_endpoint_id
  peer_address             = aws_network_interface.keyos_01_private_nic.private_ip
  bgp_options {
    peer_asn                = var.keyos_bgp_as_number
    peer_liveness_detection = "bfd"
  }

  tags = {
    Name = "keyos-01-peer"
  }

  depends_on = [
    aws_vpc_route_server_endpoint.keyos_01_endpoint
  ]
}


resource "aws_vpc_route_server_peer" "keyos_02_peer" {
  route_server_endpoint_id = aws_vpc_route_server_endpoint.keyos_02_endpoint.route_server_endpoint_id
  peer_address             = aws_network_interface.keyos_02_private_nic.private_ip
  bgp_options {
    peer_asn                = var.keyos_bgp_as_number
    peer_liveness_detection = "bfd"
  }

  tags = {
    Name = "keyos-02-peer"
  }

  depends_on = [
    aws_vpc_route_server_endpoint.keyos_02_endpoint
  ]
}

# VPC ROUTE SERVER PROPOGATIONS
resource "aws_vpc_route_server_propagation" "keyos_01_propagation" {
  route_server_id = aws_vpc_route_server.keyos_route_server.route_server_id
  route_table_id  = aws_route_table.transit_vpc_private_rtb_01.id

  depends_on = [
    aws_vpc_route_server_peer.keyos_01_peer,
    aws_route_table.transit_vpc_private_rtb_01
  ]
}

resource "aws_vpc_route_server_propagation" "keyos_02_propagation" {
  route_server_id = aws_vpc_route_server.keyos_route_server.route_server_id
  route_table_id  = aws_route_table.transit_vpc_private_rtb_02.id

  depends_on = [
    aws_vpc_route_server_peer.keyos_02_peer,
    aws_route_table.transit_vpc_private_rtb_02
  ]
}