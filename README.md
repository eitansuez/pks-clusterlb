
Using terraform to automate the manual steps outlined [here](https://docs.pivotal.io/pks/1-7/gcp-cluster-load-balancer.html).


Basic idea:

- the pks control plane is installed
- you wish to create a pks cluster
- the pks cli will create the cluster, but it won't create the lb, firewall rule, dns entry, etc..

this terraform script will do that for you.

