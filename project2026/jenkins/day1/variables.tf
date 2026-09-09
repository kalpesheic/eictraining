variable "aes_tags" {
  description = "aws resource tags"
  type        = map(string)

  default = {
    Project = "EIC-Internal"
    Owner = "Kalpesh.kumar@einfochips.com"
    Department = "PES"
    BU = "IA"
    END_Date = "15-06-2026"
  }
}

variable "my_ip" {
  description = "My public IP"
  type        = string
}cd /d c:\eic2026\project2026\jenkins\day1
terraform init