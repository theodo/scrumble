provider "aws" {
  profile = "Scrumble-AdministratorAccess"
  region  = "eu-west-1"
}

resource "aws_ecr_repository" "legacy_api_repository" {
  name                 = "scrumble-legacy-api"
  image_tag_mutability = "MUTABLE"
}
