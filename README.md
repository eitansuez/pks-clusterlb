
Basic idea

- The pks control plane is installed.
- You wish to create a pks cluster.
- The pks cli will create the cluster, but it won't create the lb, firewall rule, dns entry, etc..

You could do that manually via the steps outlined [here](https://docs.pivotal.io/tkgi/1-8/gcp-cluster-load-balancer.html).

Or:

1. Configure your `terraform.tfvars` file
1. Apply the terraform in this repository
1. Create the cluster using the tkgi cli
1. Run the script `./add-master-to-lb.sh <cluster-name>`

Notes:

- tkgi and jq must be installed

