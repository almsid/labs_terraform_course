variable "student_name" {
  description = "Your GitHub username or student ID"
  type        = string # Must be text, not a number or boolean
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string # Examples: "t3.micro", "t3.small"
  default     = "t3.micro"
}

variable "my_ip" {
  description = "Your public IP address for SSH access (CIDR notation, e.g., 203.0.113.42/32)"
  type        = string # CIDR notation is text, even though it contains numbers
}

variable "enable_ebs_encryption" {
  description = "Enable encryption on the root EBS volume"
  type        = bool # Only true or false
  default     = true
}

variable "root_volume_size" {
  description = "Size of the root EBS volume in GB"
  type        = number # Must be a numeric value, no quotes
  default     = 30
}
