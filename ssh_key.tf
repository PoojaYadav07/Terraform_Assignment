resource "aws_key_pair" "example_keypair" {
  key_name   = "example_ssh_key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "tls_private_key" "ssh_key" {
  algorithm   = "RSA"
  rsa_bits    = 4096
}

output "ssh_private_key" {
  value = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}

output "ssh_public_key" {
  value = tls_private_key.ssh_key.public_key_openssh
  sensitive = true
}

output "private_key_pem_file" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
  description = "Private key in PEM format"
}

# Output the public key as well
output "public_key_openssh_file" {
  value     = tls_private_key.ssh_key.public_key_openssh
  sensitive = true
  description = "Public key in OpenSSH format"
}

resource "local_file" "tf-key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "${path.module}/example_ssh_key.pem"
}
