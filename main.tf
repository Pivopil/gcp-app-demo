
provider "google" {
  version = "~> 3.45.0"
  region  = var.region
  project = var.admin_project
}

provider "null" {
  version = "~> 2.1"
}

provider "random" {
  version = "~> 2.2"
}
