# Start up a vault server
vault server -dev

# Let's explore the CLI a bit
vault

vault status

vault list -h

vault secrets list

vault kv put secret/tacos "favorite=bean"

vault kv get secret/tacos

vault path-help secret

vault path-help secret/config

vault write secret/config max_versions=10

vault read secret/config

vault login -method=userpass username=ned