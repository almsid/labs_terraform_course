# Challenge 1: Fix the type error
variable "ssh_port" {
  type    = string
  default = "22" # Is this the right type for the default?
}

# Challenge 2: Fix the type error
variable "enable_monitoring" {
  type    = bool
  default = true # Something's wrong here...
}

# Challenge 3: Fix the type error
variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a"] # Should this be a list?
}

# Challenge 4: Fix the type error
variable "instance_tags" {
  type = map(string)
  default = {
    Name = "web-server"
    Port = "8080" # Is this the right type for a map(string)?
  }
}
