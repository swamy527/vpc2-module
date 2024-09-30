locals {
  az_names = slice(data.aws_availability_zones.azones.names, 0, 2)
}
