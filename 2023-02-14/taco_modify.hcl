path "taco/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "taco/metadata/*" {
  capabilities = ["list"]
}