## Get that Vault server up!
vault server -dev

export VAULT_ADDR=http://127.0.0.1:8200

vault login

## Let's enable the userpass auth method and add a user

vault auth enable userpass

vault write auth/userpass/users/ned "password=tacos"

## Let's enable a secrets engine and add a secret

vault secrets enable -path=kv2 -version=2 kv

vault kv put kv2/toppings "meat=chicken"

## Now let's create a policy allowing Ned to use the new secrets engine

vault policy write allow_kv2 kv_policy.hcl

# Now assign the policy to Ned

vault write auth/userpass/users/ned "token_policies=allow_kv2"

## Alright, now we can start using the API as Ned!

curl --request POST \
 --data '{"username": "ned", "password": "tacos"}' \
 $VAULT_ADDR/v1/auth/userpass/login/ned | jq

#Store the token id from the response
TOKEN=s.C9ixRepmnNAmkdKr4fUN1KJG

# Get a secret
curl --header "X-Vault-Token: $TOKEN" \
  $VAULT_ADDR/v1/kv2/data/toppings | jq

# Put a new secret
curl --header "X-Vault-Token: $TOKEN" \
  --request POST \
  --data '{"data": { "cheese": "jack" }}' \
  $VAULT_ADDR/v1/kv2/data/toppings

