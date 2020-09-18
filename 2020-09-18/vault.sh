## Get that Vault server up!
vault server -dev

# Now what about the secrets command?
vault secrets -h

## Now let's look at the secrets engines we have enabled
vault secrets list

# Why don't we add a secrets engine?
vault secrets enable -path=kv2 -version=2 kv

# Can we move the engine after enabling it?
vault secrets move kv2/ secret2/

vault secrets list

# What's this tune nonsense?
vault secrets tune -description="Version 2 KV for Enchiladas Only" -default-lease-ttl=30m secret2/

vault secrets list -detailed

## Cool, and what can we configure on the KV engine?
vault path-help secret2/

vault path-help secret2/config

# Ah, so we can edit the config for max_versions
vault write secret2/config "max_versions=5"

vault read secret2/config

# Ok a word about environment variables...
# VAULT_TOKEN - set the tokens used for comms, overrides login
# VAULT_ADDR - set the address of the Vault server
# There's a bunch certificate related ones
# VAULT_FORMAT - specify the output format from the CLI
# VAULT_SKIP_VERIFY - skip verifying the vault cert (dev/test only)
