resource "google_storage_bucket" "bucket" {
  name = "cloudfunction-deploy-${random_string.suffix.result}"
}

data "archive_file" "http_trigger" {
  type        = "zip"
  output_path = "${path.module}/files/http_trigger.zip"
  source {
    content  = file("${path.module}/files/http_trigger.js")
    filename = "index.js"
  }
}

resource "google_storage_bucket_object" "archive" {
  name       = "http_trigger.zip"
  bucket     = google_storage_bucket.bucket.name
  source     = "${path.module}/files/http_trigger.zip"
  depends_on = [data.archive_file.http_trigger]
}

//https://cloud.google.com/functions/docs/locations
resource "google_cloudfunctions_function" "test" {
  name        = "webhook"
  runtime     = "nodejs10"
  entry_point = "webhook"
  project     = local.project_name
  region      = var.region

  available_memory_mb   = 128
  timeout               = 60
  trigger_http          = true
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
}

resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.test.project
  region         = google_cloudfunctions_function.test.region
  cloud_function = google_cloudfunctions_function.test.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}
