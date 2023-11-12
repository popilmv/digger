variable "machine_name" {
  type = string
  default = "my-instance"
}

variable "machine_type" {
  type = string
  default = "e2-micro"
}

variable "image" {
  type = string
  default = "debian-cloud/debian-11"
}
