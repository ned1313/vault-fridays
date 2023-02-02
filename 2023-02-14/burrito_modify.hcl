path "burrito/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "burrito/metadata/*" {
  capabilities = ["list"]
}