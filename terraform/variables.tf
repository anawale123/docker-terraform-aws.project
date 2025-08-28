variable "main_vpc_cidr_blocks" {
    type = string
    default = "10.0.0.0/16"
}

variable "public_a_cidr_block" {
    type = string
    default = "10.0.1.0/24"
}

variable "private_a_cidr_block" {
    type = string 
    default = "10.0.2.0/24" 
}

