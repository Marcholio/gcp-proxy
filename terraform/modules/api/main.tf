resource "google_api_gateway_api" "api" {
  provider        = google-beta
  api_id          = var.api_id
  display_name    = var.api_name
}

resource "google_api_gateway_api_config" "api_config" {
  provider       = google-beta
  api            = google_api_gateway_api.api.api_id
  api_config_id  = "${var.api_id}-config-${formatdate("YYYYMMDDhhmmss", timestamp())}"

  openapi_documents {
    document {
      path = "openapi.yml"
      contents = filebase64("${path.module}/openapi.yml")
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  gateway_config {
    backend_config {
      google_service_account = var.service_account
    }
  }
}

resource "google_api_gateway_gateway" "api_gateway" {
  provider  = google-beta
  api_config = google_api_gateway_api_config.api_config.id
  gateway_id = "${var.api_id}-gateway"
}