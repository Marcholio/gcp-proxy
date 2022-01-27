resource "google_storage_bucket" "bucket" {
  name = "${var.project}-proxy-function"
  location = var.location
}

resource "google_storage_bucket_object" "archive" {
  name   = "proxy/index-${formatdate("YYYYMMDDhhmmss", timestamp())}.zip"
  bucket = google_storage_bucket.bucket.name
  source = "${path.module}/../../../dist/index.zip"
}

resource "google_cloudfunctions_function" "proxy" {
  name        = var.function_name
  runtime     = "nodejs16"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  trigger_http          = true
  entry_point           = var.handler_name
  timeout               = 30
  max_instances         = 2
}

resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.proxy.project
  region         = google_cloudfunctions_function.proxy.region
  cloud_function = google_cloudfunctions_function.proxy.name

  role   = "roles/cloudfunctions.invoker"
  member = "serviceAccount:${var.service_account}"
}