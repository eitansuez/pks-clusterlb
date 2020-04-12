
using terraform to automate the manual steps outlined here:

  https://docs.pivotal.io/pks/1-7/gcp-cluster-load-balancer.html


basic idea:

you installed pks (the control plane)
you wish to create yourself a pks cluster

the pks cli will create the cluster
but it won't create the lb, firewall rule, dns entry, etc..

this terraform script will do that for you.

