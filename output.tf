output "vpc_id" {
  value = aws_vpc.myvpc.id

}

output "vpc-arn" {
  value = aws_vpc.myvpc.arn

}

output "subnet01-id" {
  value = aws_subnet.subnet01.id

}

output "subnet02-id" {
  value = aws_subnet.subnet02.id

}

output "gateway_id" {
  value = aws_internet_gateway.IGW.id

}

output "route_table_Private_id" {
  value = aws_route_table.Private-RT.id

}

output "route_table-Public_id" {
  value = aws_route_table.Public-RT.id

}

output "aws_route_table_association_private" {
  value = aws_route_table_association.Private-RTA.subnet_id
}

output "aws_route_table_association_public" {
  value = aws_route_table_association.Public-RTA.subnet_id
}