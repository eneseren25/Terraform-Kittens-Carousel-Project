variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "key_name" {
  type = string
  default = "clarusway_lesson_key"
}

variable "num_of_instance" {
  type = number
  default = 1
}

variable "tag" {
  type = string
  default = "Terraform-Kitten"
}

variable "server-name" {
  type = string
  default = "TerIns"
}

variable "proje-sec" {
  type = list(number)
  description = "Kitten-instance-sec-gr-inbound-rules"
  default = [22, 80,]
}