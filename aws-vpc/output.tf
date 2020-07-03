output "vpc_id" {
    value = "%{ if var.create_vpc == true }  aws_vpc.default[0].id %{ endif }"
}

output "private_subnet_id" {
    value = "%{ if var.create_vpc == true && length(var.private_subnet) > 0 } aws_subnet.private_subnet.*.id %{ endif }"
}

output "public_subnet_id" {
    value = "%{ if var.create_vpc == true && length(var.public_subnet) > 0 } aws_subnet.public_subnet.*.id %{ endif }"
}