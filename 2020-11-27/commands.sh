## Get that Vault server up!
vault server -dev

export VAULT_ADDR=http://127.0.0.1:8200

vault login

# Let's enable the transit engine now!

vault secrets enable transit

# The first objective is configuring the engine, so let's the paths available to us

vault path-help transit

# Now we can write an encryption key to the transit engine

vault write -force transit/keys/tacos

vault list transit/keys

vault read transit/keys/tacos

# With our encryption key in place, we can encrypt some important data

vault write transit/encrypt/tacos plaintext=$(base64 <<< "tacosarebetterthanburritos")

# The returned information is the encrypted string with base64 encoding
# We can decrypt it using the decrypt path

vault write transit/decrypt/tacos ciphertext="ENCRYPTED_TEXT_HERE"

# The text returned with still be base64 encoded, so let's remove that

base64 -d <<< "ENCODED_STRING_HERE"

# Now we can rotate the key, in fact let's do that a few times

vault write transit/keys/tacos/rotate

# Now let's look at the key again

vault read transit/keys/tacos

# Let's set the min encryption version to 3

vault write transit/keys/tacos/config min_encryption_version=3 

# And let's try to encrypt with version 2

vault write transit/encrypt/tacos key_version=2 plaintext=$(base64 <<< "tacosarebetterthanburritos")

vault write transit/encrypt/tacos key_version=3 plaintext=$(base64 <<< "tacosarebetterthanburritos")

# Let's try and decrypt what we encrypted earlier

# And now change the min decryption
vault write transit/keys/tacos/config min_decryption_version=3

# What about the min available version?
vault write transit/keys/tacos/config min_available_version=4

vault read transit/keys/tacos

vault write transit/encrypt/tacos key_version=3 plaintext=$(base64 <<< "tacosarebetterthanburritos")

# Weird, let's try and run the trim operations

vault write transit/keys/tacos/trim min_available_version=4

# Yup that did it, and now we can't decrypt the older data no matter what!