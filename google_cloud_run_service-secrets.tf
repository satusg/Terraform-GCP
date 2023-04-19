resource "google_cloud_run_service" "default" {
  provider = google-beta
  project =  "<main>"
  name     = "new-cloud-run"
  location = "us-central1"

  template {
    metadata {
      annotations = {
        "run.googleapis.com/secrets" = "secret:projects/<PROJECT NUMBER>/secrets/<SECRET_ID>"
      }
    }

    spec {
      containers {
        image = "gcr.io/cloudrun/hello"
        env {
          name = "SECRET_ENV_VAR"
      value_from {
            secret_key_ref {
              name = "secret"
              key = "latest"
            }
          }
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  autogenerate_revision_name = true

  lifecycle {
    ignore_changes = [
        metadata.0.annotations,
    ]
  }
}