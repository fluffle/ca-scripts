basicConstraints        = critical, CA:FALSE
nsCertType              = client, objsign, email
nsRevocationUrl         = %CA_CRL_URI%
%CA_CRT_COMMENT%
keyUsage                = critical, keyEncipherment, keyAgreement, digitalSignature, nonRepudiation, dataEncipherment
extendedKeyUsage        = clientAuth, codeSigning, emailProtection

issuerAltName           = issuer:copy
subjectAltName          = @user_altname
subjectKeyIdentifier    = hash
authorityKeyIdentifier  = keyid,issuer:always
authorityInfoAccess     = caIssuers;URI:%CA_CRT_URI%
crlDistributionPoints   = URI:%CA_CRL_URI%

[ user_altname ]
URI=%CA_CRT_URI%
email=move

