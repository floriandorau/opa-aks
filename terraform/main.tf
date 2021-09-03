provider "azurerm" {
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id

  features {}
}

data "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.aks_cluster_name
  resource_group_name = var.aks_cluster_rg
}

resource "azurerm_policy_definition" "policy" {
  name        = "require-label-on-pods"
  policy_type = "Custom"
  mode        = "Microsoft.Kubernetes.Data"
  display_name = "Required labeld pods"

  policy_rule = <<POLICY_RULE
    {
        "if":{
            "field":"type",
            "in":[
                "AKS Engine",
                "Microsoft.Kubernetes/connectedClusters",
                "Microsoft.ContainerService/managedClusters"
            ]
        },
        "then":{
            "effect":"Deny",
            "details":{
                "constraintTemplate":"https://raw.githubusercontent.com/floriandorau/opa-aks/main/kubernetes/required-labels/template.yaml,
                "constraint":"https://raw.githubusercontent.com/floriandorau/opa-aks/main/kubernetes/required-labels/contraint.yaml
            }
        }
    }
    POLICY_RULE

}

resource "azurerm_resource_policy_assignment" "policy_assignment" {
  name                 = "aks-policy-assignment"
  resource_id          = data.azurerm_kubernetes_cluster.aks_cluster.id
  policy_definition_id = azurerm_policy_definition.policy.id
}