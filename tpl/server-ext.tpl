basicConstraints        = critical, CA:FALSE
nsCertType              = server
nsRevocationUrl         = %CA_CRL_URI%
%CA_CRT_COMMENT%
keyUsage                = critical, keyEncipherment, keyAgreement
extendedKeyUsage        = serverAuth

issuerAltName           = issuer:copy
subjectAltName          = @server_altname
subjectKeyIdentifier    = hash
authorityKeyIdentifier  = keyid,issuer:always
authorityInfoAccess     = caIssuers;URI:%CA_CRT_URI%
crlDistributionPoints   = URI:%CA_CRL_URI%

[ server_altname ]
URI=%CA_CRT_URI%
email=move
%CA_CRT_ALT_NAMES%

