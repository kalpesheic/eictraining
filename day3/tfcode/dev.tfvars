# ==========================================
# terraform.tfvars
# ==========================================

aws_region = "ap-south-1"

# Existing AWS EC2 Key Pair
key_name = "kalpeshtf2016"

# Your Public IP for SSH Access
allowed_ssh_ip = "106.222.214.102/32"

# ==========================================
# Mandatory Resource Tags
# ==========================================

owner        = "kalpesh.kumar@einfochips.com"
department   = "PES"
project_name = "EIC internal"
