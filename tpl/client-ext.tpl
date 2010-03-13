basicConstraints        = critical, CA:FALSE
nsCertType              = client
nsRevocationUrl         = %CA_CRL_URI%
%CA_CRT_COMMENT%
keyUsage                = critical, keyEncipherment, keyAgreement, digitalSignature
extendedKeyUsage        = clientAuth, timeStamping

issuerAltName           = issuer:copy
subjectAltName          = @client_altname
subjectKeyIdentifier    = hash
authorityKeyIdentifier  = keyid,issuer:always
authorityInfoAccess     = caIssuers;URI:%CA_CRT_URI%
crlDistributionPoints   = URI:%CA_CRL_URI%

[ client_altname ]
URI=%CA_CRT_URI%
email=move
%CA_CRT_ALT_NAMES%
