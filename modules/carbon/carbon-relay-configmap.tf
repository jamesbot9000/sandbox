# kubectl create configmap carbon-relay-config --from-file=carbon-c-relay.conf

resource "kubernetes_config_map" "carbon-relay-config" {
  metadata {
    name = "carbon-relay-config"
  }

  data {
      carbon-c-relay.conf = "${file("carbon-c-relay.conf")}"
  }
}
