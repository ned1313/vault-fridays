# Start up a vault server
vault server -dev

# Let's enable some auth methods
vault auth

vault auth list

vault auth help userpass

vault auth enable userpass

# Now how do I add a user?

vault path-help auth/userpass

vault write auth/userpass/users/ned "password=tacos"

# And now I can log in, but I can't do much!

vault login -method=userpass username=ned

# Go back in as root and create a policy

vault policy

vault policy list

vault policy read default

# Let's create a policy that let's the assigned use manipulate the key value store
vault policy write allow_kv kv_access.hcl

vault policy read allow_kv

# Now assign the policy to Ned
vault path-help auth/userpass/users/ned

vault write auth/userpass/users/ned "token_policies=allow_kv"

# Login as Ned again and I should have access to KV
vault login -method=userpass username=ned

vault kv put secret/toppings "meat=fish"