# Service Mesh demo with Linkerd Emojivoto demo app

## Requirements

- [minikube](https://minikube.sigs.k8s.io/)
  - with configured [docker driver](https://minikube.sigs.k8s.io/docs/drivers/docker/)
- [linkerd CLI](https://linkerd.io/2.12/getting-started/)

## Configration Options

**Export** one of the following environment variables to configure the scripts. Make sure to always use the same set of variables.

| Variable name     | Default value | Description                              |
| ----------------- | ------------- | ---------------------------------------- |
| `MK_PROFILE_NAME` | `linkerd`     | The name of the minikube profile/cluster |

## Setup the minikube cluster with Linkerd

1. Start Docker.
1. Ensure that minikube is configured to use the Docker driver.
1. Execute [00_setup_cluster_and_linkerd.sh](./00_setup_cluster_and_linkerd.sh) to spin up a minikube cluster/profile with Linkerd and the Emojivoto demo app installed.

## Expose the emojivoto app and forward the viz dashboard

1. Start a new terminal.
1. Execute [10_run_dashboard_and_app.sh](10_run_dashboard_and_app.sh).
1. Access the Linkerd dashboard and the demo app via the printed URLs.
1. Kill the terminal to stop the forwards.

## Clean-up

1. Ensure the right variables are exported.
1. Execute [20_delete_minikube_cluster.sh](./20_delete_minikube_cluster.sh).
1. Your cluster should be gone.

---

## References

- [minikube docs](https://minikube.sigs.k8s.io/docs/)
- [Linkerd docs](https://linkerd.io/docs/)
