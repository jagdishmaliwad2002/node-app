provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_deployment" "node_app" {
  metadata {
    name = "node-app-deployment"
    labels = {
      app = "node-app"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "node-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "node-app"
        }
      }

      spec {
        container {
          name  = "node-app"
          image = "node-app:v1"

          port {
            container_port = 3000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "node_app" {
  metadata {
    name = "node-app-service"
  }

  spec {
    selector = {
      app = kubernetes_deployment.node_app.metadata[0].labels.app
    }

    port {
      port        = 3000
      target_port = 3000
      node_port   = 30007
    }

    type = "NodePort"
  }
}
