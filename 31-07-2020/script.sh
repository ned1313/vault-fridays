# VAULT ROOT TOKEN = s.TOmBpXBFW8tj3X95rt7UDQ1G

# Create a new token using the default and token-mgmt policies
vault token create -policy default -policy token-mgmt

# Make a note of the new token - s.dBQPcOflKnXdZZb5B0WNifhc
# Login with the new token
vault login

# Create a child token with the default policy
vault token create -policy=default
# Make a note of the new token accessor - 9d5rxinNmyPTqcmIeWmVQ2d9

# Create an orphaned token with the default policy
vault token create -policy=default -orphan
# Make a note of the new token accessor - HaC1auchEX59yQRXnbunVXdS

# Lookup both tokens
vault token lookup -accessor 

# Login as root
vault login

# Revoke the parent token
vault token revoke 

# Lookup the child token
vault token lookup -accessor 

# Lookup the orphaned token
vault token lookup -accessor 

# List all accessors
vault list auth/token/accessors