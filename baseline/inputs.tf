variable "domain_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

# Define the CIDRs for the subnets
variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}
