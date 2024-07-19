terraform {

}

resource "random_string" "suffix" {
  length = 5
  special = false
  upper = false
}

output "suffix" {
  value =  random_string.suffix.result
}