provider "google" {
  project = var.project
  region = var.region
}

provider "google-beta" {
  project = var.project
  region = var.region
}

resource "google_project_service" "cf" {
  project = var.project
  service = "cloudfunctions.googleapis.com"

  disable_dependent_services = true
  disable_on_destroy         = false
}

resource "google_project_service" "cb" {
  project = var.project
  service = "cloudbuild.googleapis.com"

  disable_dependent_services = true
  disable_on_destroy         = false
}

module "proxy_function" {
  source               = "./modules/proxy_function"
  project              = var.project
  function_name        = "proxy-function"
  handler_name         = "handler"
  location             = "EU"
  service_account      = var.service_account
}

module "api" {
  source        = "./modules/api"
  api_name      = "Proxy API"
  api_id        = "proxy-api"
  service_account = var.service_account
}