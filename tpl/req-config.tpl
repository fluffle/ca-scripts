[ req ]
default_bits            = %CA_CRT_BITS%
default_md              = sha1
distinguished_name      = req_dn
req_extensions          = req_%CA_CRT_TYPE%_extensions
string_mask             = nombstr
prompt                  = no

[ req_dn ]
C                       = %CA_CRT_C%
ST                      = %CA_CRT_ST%
L                       = %CA_CRT_L%
O                       = %CA_CRT_O%
OU                      = %CA_CRT_OU%
CN                      = %CA_CRT_CN%
emailAddress            = %CA_CRT_E%

[ req_server_extensions ]
basicConstraints        = critical, CA:FALSE
keyUsage                = critical, keyEncipherment, keyAgreement
extendedKeyUsage        = serverAuth

[ req_client_extensions ]
basicConstraints        = critical, CA:FALSE
keyUsage                = critical, keyEncipherment, keyAgreement, digitalSignature
extendedKeyUsage        = clientAuth, timeStamping

[ req_user_extensions ]
basicConstraints        = critical, CA:FALSE
keyUsage                = critical, keyEncipherment, keyAgreement, digitalSignature, nonRepudiation, dataEncipherment
extendedKeyUsage        = clientAuth, codeSigning, emailProtection

