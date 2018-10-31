# Tools to deploy WordPress on k8s cluster on AWS

This scripts automates the deployment of a WordPress site using a MySQL database, stored in an EBS volume, and an EFS volume for uploads.

## Dependencies:
 - kubectl
 - aws cli

### Cluster setup

This tools assume `k8s-aws-cluster/create-cluster.sh` was used to create the
cluster, in other case configure `k8s-aws-cluster/config.sh`, `aws-cli` and
`kubectl` to match your cluster configuration.

## WordPress Deployment


Run `configure.sh` to create the volumes on AWS and automatically create the Kubernetes yml files. The created configuration uses two replicas for WordPress.

Run `deploy.sh` to deploy the database and WordPress to the Kubernetes cluster.
After deploy use `kubectl get svc` to get the LoadBalancer URL to access the site

Example output:

    NAME         TYPE           CLUSTER-IP       EXTERNAL-IP        PORT(S)          AGE
    db           NodePort       100.64.248.75    <none>     3306:31828/TCP      46s
    kubernetes   ClusterIP      100.64.0.1       <none>     443/TCP              2h
    wordpress    LoadBalancer   100.68.189.217  a8468f2dcdd3611e8b69002b0118cffe-1515977014.us-west-1.elb.amazonaws.com 80:32222/TCP     44s

In this case `http://a8468f2dcdd3611e8b69002b0118cffe-1515977014.us-west-1.elb.amazonaws.com` is the WordPress URL (It could take minutes before the server is ready to serve requests).

You can use AWS Route53 to create an alias to the Load Balancer in your DNS Hosted Zone.

Run `delete.sh` to remove all the resources deployed and destroy volumes.

