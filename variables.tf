variable "environment" {
  default = "dev"
  type = string  
}


variable "instance_count" {
  type = number   
}


variable "associate_public_ip_address" {
  type = bool
  default = true
  
}


variable "allowed_vm_types" {
    type = list(string)
    default = [ "t2.micro", "t2.small", "t3.small"]
  
}

variable "allowed_region" {
    type = list(string)
    default = ["us-east-1", "us-west-2", "eu-west-1"]
  
}

variable "tags" {
    type = map(string)
    default = {
      environment = "dev"
      owner = "kalpesh.kumar@einfochips.com"
      DM  = "kalpesh.kumar@einfochips.com" 
    }  
}

# tuple- will be used when requied to call different variables inside tuple, like number,string, number etc)
variable "ingress_value" {
    type = tuple([ number, string, number ])
    default = [ 443, "tcp", 443 ]
  
}

# this is dictnoary or object variable, we can defind multiple other variables inside object
variable "config1" {
    type = object({
      region = string,
      monitoring = bool,
      instance_count = number 
    })
    default = {
        region = "us-east-1",
        monitoring = true,
        instance_count = 1
    }  
}