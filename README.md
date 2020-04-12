
Basic idea

- The pks control plane is installed.
- You wish to create a pks cluster.
- The pks cli will create the cluster, but it won't create the lb, firewall rule, dns entry, etc..

You could do that manually via the steps outlined [here](https://docs.pivotal.io/pks/1-7/gcp-cluster-load-balancer.html).

Or:

1. Configure your `terraform.tfvars` file
1. Apply the terraform in this repository
1. Create the cluster with the pks cli
1. Run the script `./add-master-to-lb.sh <cluster-name>`

Notes:

- jq must be installed
