variable "ami_id" {
  default = "ami-02dfbd4ff395f2a1b" # Amazon Linux 2023
}

variable "key_name" {
  default = "iot-key"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "docker_user" {
  description = "Usuario de Docker Hub"
}
