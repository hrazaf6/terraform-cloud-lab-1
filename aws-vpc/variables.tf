variable "cidr_block" {}
variable "environment" {}
variable "name" {}
variable "create_vpc" {
    default = true
}
variable "public_subnet" {
    default = ["pub1", "pub2"]
}
variable "private_subnet" {
    default = ["pri1", "pri2"]
}