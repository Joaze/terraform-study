terraform {
  
}

variable "world" {
  type = list(string)
}

variable "world_map" {
  type = map(string)
}

variable "world_splat" {
  type = list(map)
}
