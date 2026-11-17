variable "name_prefix" {
    type = string 
    description = "Prefix for resourcr name tags"

}

variable "vpc_cidr" {
    type = string
    description = "IP Range for the whole private network"
}

variable "public_subnet_cidr" {
    type = string
    description = "IP range of public subnet which we spin up the VM/EC2"

}

variable "availability_zone" {
    type = string
    description = "another availability_zone for exosying subnet"
}


#IN modules i havent setup the default values cause those mod callers must pass values  
