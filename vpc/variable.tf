# environment variables

variable "region" {
    description = "vpc region"
    type = string
  
}


variable "project_name" {
    description = "This is the project name"
    type = string
  
}

variable "environment" {
    description = "the is the project environment"
    type = string
  
}

variable "vpc_cidr" {
    description = "vpc cidr"
    type = string
  
}

variable "public_subnet_az1" {
    description = "public subnet az1 cidr"
    type = string
  
}


variable "public_subnet_az2" {
    description = "public subnet az2 cidr"
    type = string
  
}
variable "private_app_subnet_az1" {
    description = "private subnet az1 cidr"
    type = string
  
}

variable "private_app_subnet_az2" {
    description = "private subnet az2 cidr"
    type = string
  
}

variable "private_data_subnet_az1" {
    description = "private data subnet az1"
    type = string
  
}

variable "private_data_subnet_az2" {
    description = "private_data_subnet_az2"
    type = string
  
}