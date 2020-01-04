provider "kubernetes" {}

resource "kubernetes_cluster_role" "example" {
  metadata {
    name = "deployment-manager"
  }

  rule {
    api_groups = ["", "extensions", "apps"]
    resources  = ["deployments", "replicasets", "pods", "services", "ingresses"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }
}

resource "kubernetes_cluster_role_binding" "example" {
  metadata {
    name = "terraform-example"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "deployment-manager"
  }
  subject {
    kind      = "User"
    name      = "jmarhee"
    api_group = "rbac.authorization.k8s.io"
  }
}
