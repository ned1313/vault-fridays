vault {
    address = "https://127.0.0.1:8200"
    tls_skip_verify = true
}

auto_auth {
    method "approle" {
        mount_path = "auth/approle"
        config = {
            role_id_file_path = "role_id"
            secret_id_file_path = "secret_id"
        }
    }

    sink "file" {
        config = {
            path = "sink-file"
        }
    }
}

cache {
    use_auto_auth_token = true
}

listener "tcp" {
    address = "127.0.0.1:8100"
    tls_disable  = true
}