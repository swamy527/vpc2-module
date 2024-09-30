variable "dns_hostnames" {
  type    = bool
  default = true
}

variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16" #optional
}


variable "common_tags" {
  type    = map(string)
  default = {}
}


variable "vpc_tags" {
  type    = map(string)
  default = {}
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "public_subnet_cidr" {
  type = list(string)
}

variable "private_subnet_cidr" {
  type = list(string)
}

variable "mygw_tags" {
  type    = map(string)
  default = {}
}
