## Get that Vault server up!
vault server -dev

export VAULT_ADDR=http://127.0.0.1:8200

vault login

## Let's enable a KVv2 engine
vault secrets enable -path=kvv2 kv-v2

# And put a secret

vault kv put kvv2/tacos "special-spice=marjoram"

# Now let's request the secret with response wrapping

vault kv get -wrap-ttl=120 kvv2/tacos

vault unwrap WRAPPING_TOKEN