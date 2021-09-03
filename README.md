# Open Policy Agent on AKS

The purpose of this repository is to use [Open Policy Agent](https://www.openpolicyagent.org) definitons in combination with Azure Kubernetes Cluster.

## Policy

To test how OPA is working in AKS we try to apply a policy which requires pod to have a label attached to pod definition. If label does not exist, pods should be rejected when applied to cluster.

## Deploy policy

Terraform is used to deploy policy definitions to Azure managed cluster.

### Prepare env

In order to run terraform you first need to create a file `env.tfvars` within `terraform` folder. Here you need to define values for varibales (see `varibales.tf`) that are used for the deployment

### Plan & apply policy

You can use `make` to run `terraform` commands

```bash
# Terraform init
make init

# Terraform plan
make plan

# Terraform apply
make apply
```

## Test policy

To test if the policy is working you can use the `busybox` pod under `app`.

When trying to apply the pod to your test cluster

```bash
kubectl -n opa-test apply -f app/busybox.yaml
```

it should result in an error similar to the following when policy is working correctly.

```bash
Error from server ([azurepolicy-require-opa-label-5cbc81520134ce86ea47] you must provide labels: {"opa-test"}):
error when creating "busybox.yaml": admission webhook "validation.gatekeeper.sh" denied the request:
[azurepolicy-require-opa-label-5cbc81520134ce86ea47] you must provide labels: {"opa-test"}
```

## Links

- <https://docs.microsoft.com/en-ie/azure/governance/policy/concepts/policy-for-kubernetes>
