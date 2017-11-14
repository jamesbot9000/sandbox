module "carbon-relay" {  
  source = "github.com/jamesbot9000/sandbox/modules/carbon"
   resource "kubernetes_service" "carbon-relay" {
    metadata {
      name = "carbon-relay"
    }
    spec {
      selector {
        app = "carbon-relay"
      }
      port {
        port = 2003
        protocol = "TCP"
        target_port = 2003
      }
      type = "ClusterIP" #this is the default
    }
  }
  
  
  resource "kubernetes_replication_controller" "carbon-relay" {
    metadata {
      name = "carbon-relay"
      labels {
        app = "carbon-relay"
      }
    }
    
    spec {  
      selector {
        app = "carbon-relay"
      }
     template {
        container {
          image = "drydock.svc.tapad.com/com.tapad/carbon-c-relay:0.6"
          name  = "carbon-relay"
          command = ["/bin/sleep"]
          args = ["700"]
          volume_mount  {
            name = "config-volume"
            mount_path = "/etc/carbon-c-relay"
          }
          volume_mount  {
            name = "secret-volume"
            mount_path = "/var/run/kubernetes.io/serviceaccount"
          }       
          port {  
            container_port = 2003
          }       
        }       
        volume {
          name ="config-volume"
          config_map {
            name = "carbon-relay-config"
  #          items { 
  #            mode = 0 
  #            key = "carbon-c-relay.conf"
  #            path = "carbon-c-relay.conf"
  #          }       
          }       
        } 
        volume {
          name = "secret-volume"
          secret {
             secret_name ="default-token-zqj55" 
          }
        }       
      } 
    }
  }
  
  resource "kubernetes_horizontal_pod_autoscaler" "carbon-relay" {
    metadata {
      name = "carbon-relay"
    }
    spec {
      max_replicas = 4
      min_replicas = 2
      scale_target_ref {
        kind = "ReplicationController"
        name = "carbon-relay"
      }
    }
  }
  
  resource "kubernetes_config_map" "carbon-relay-config" {
    # (resource arguments)
  }


  
}
