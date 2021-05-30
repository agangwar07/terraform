variable "access_key" {
     default = "AKIAULA5E67ZQP2EKNH5"
}
variable "secret_key" {
     default = "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"
}
variable "region" {
     default = "us-east-1"
}
variable "availabilityZone" {
     default = "us-east-1a"
}
variable "availabilityZone1" {
     default = "us-east-1b"
}
variable "instanceTenancy" {
    default = "default"
}
variable "dnsSupport" {
    default = true
}
variable "dnsHostNames" {
    default = true
}
variable "vpcCIDRblock" {
    default = "10.0.0.0/16"
}
variable "subnetpublicCIDRblock" {
    default = "10.0.1.0/24"
}

variable "subnetpublicCIDRblock" {
    default = "10.0.2.0/24"
}

variable "subnetprivateCIDRblock" {
    default = "10.0.3.0/24"
}

variable "subnetprivateCIDRblock1" {
    default = "10.0.4.0/24"
}

variable "destinationCIDRblock" {
    default = "0.0.0.0/0"
}
variable "ingressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}
variable "egressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}
variable "mapPublicIP" {
    default = true
}

variable "AMIS" {
    type = map
    default = {
        us-east-1 = "ami-0f40c8f97004632f9"
        us-east-2 = "ami-05692172625678b4e"
    }
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "levelup_key"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "levelup_key.pub"
}

variable "INSTANCE_USERNAME" {
  default = "my_user"
}