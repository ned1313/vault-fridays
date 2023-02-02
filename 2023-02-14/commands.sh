# Spin up Vault dev server
vault server -dev

# Create the policies
vault policy write burrito_modify burrito_modify.hcl
vault policy write burrito_admin burrito_admin.hcl
vault policy write taco_modify taco_modify.hcl

# Enable a KVv2 engine at the path burrito and taco
vault secrets enable -path=burrito -version=2 kv
vault secrets enable -path=taco -version=2 kv

# Put a secret to the new KV paths
vault kv put burrito/sauce pepper="aji limon"
vault kv put taco/sauce pepper="scotch bonnet"

# Create a token using the burrito modify policy
vault token create -policy=burrito_modify

# Enable the userpass auth method for burrito_town
vault auth enable -path=burrito_town userpass

# Create the user pat and associate the burrito_modify policy with them
vault write auth/burrito_town/users/pat password=grillzskillz policies=burrito_modify

# Log in with the user Pat and store the token and accessor in the variable pat_token and pat_accessor
vault login -method=userpass -path=burrito_town username=pat
pat_token=$(vault token lookup -format="json" | jq -r .data.id)
pat_accessor=$(vault token lookup -format="json" | jq -r .data.accessor)

# Log back in with root token and expirement!
vault login 

# Grab the entity and add a policy
entity_id=$(vault list -format="json" identity/entity/name | jq -r .[0])
vault write identity/entity/name/$(entity_id) policies=burrito_admin

# Change policies on the user object
vault write auth/burrito_town/users/pat policies=burrito_modify,taco_modify

# Check the token
vault token lookup -accessor $pat_accessor

# Change policies on the entity
vault write identity/entity/name/$(entity_id) policies=burrito_admin,taco_modify

# Remove policies from user object
vault write auth/burrito_town/users/pat policies=""

# Remove policy from entity
vault write identity/entity/name/$(entity_id) policies=taco_modify

# Check Pat's access
VAULT_TOKEN=$pat_token vault kv list burrito

# Delete the policy
vault policy delete burrito_modify

# Check Pat's access again
VAULT_TOKEN=$pat_token vault kv list burrito
