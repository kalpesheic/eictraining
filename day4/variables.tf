variable "aes_tags" {
  description = "aws resource tags"
  type        = map(string)

  default = {
    Project = "EIC-Internal"
    Email_ID = "Kalpesh.kumar@einfochips.com"
    Department = "PES"
    BU = "IA"
    END_Date = "31-08-2026"
  }
}

variable "my_ip" {
  description = "My public IP"
  type        = string
}