provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# === Repositories ===
# resource "helm_repository" "bitnami" {
#   name = "bitnami"
#   url  = "https://charts.bitnami.com/bitnami"
# }

# resource "helm_repository" "traefik" {
#   name = "traefik"
#   url  = "https://traefik.github.io/charts"
# }

# === Releases ===

resource "helm_release" "traefik" {
  name             = "traefik"
  namespace        = "traefik"
  create_namespace = true

  repository = "https://traefik.github.io/charts"
  chart      = "traefik"
  values     = [file("values/values-traefik.yaml")]
}

resource "helm_release" "postgresql" {
  name      = "postgresql"
  namespace = "services"
  create_namespace = true

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  version    = "12.6.8"
  values     = [file("values/values-postgresql.yaml")]
}

resource "helm_release" "kafka" {
  name      = "kafka"
  namespace = "services"
  create_namespace = true

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "kafka"
  version    = "26.8.2"
  values     = [file("values/values-kafka.yaml")]
}

# resource "helm_release" "keycloak" {
#   name      = "keycloak"
#   namespace = "services"
#   create_namespace = true
  
#   repository = "https://charts.bitnami.com/bitnami"
#   chart      = "keycloak"
#   version    = "21.2.1"
#   values     = [file("values/values-keycloak.yaml")]
# }

# === Local Charts ===

locals {
  rails_apps = [
    "client",
    "client-kafka",
    "idp",
    "audit",
    "audit-kafka",
    "notification",
    "notification-kafka"
  ]
}

# Reusable releases for rails apps
resource "helm_release" "rails_apps" {
  for_each         = toset(local.rails_apps)
  name             = each.value
  namespace        = "oauth-apps"
  chart            = "rails-app"
  values           = [file("values/values-${each.value}.yaml")]
  create_namespace = true
  depends_on = [helm_release.postgresql, helm_release.kafka, helm_release.traefik]
}

resource "helm_release" "tls_secret" {
  name      = "tls-secret"
  namespace = "oauth-apps"
  chart     = "tls-secret"
}
