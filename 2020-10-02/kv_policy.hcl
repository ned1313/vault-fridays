path "kv2/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "kv2/metadata/*" {
  capabilities = ["list"]
}