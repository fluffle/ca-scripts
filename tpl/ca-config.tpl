# CA configuration file template

# ---------------------------------------------------------------------------- #
# This defines the CA configuration to use
[ ca ]
default_ca = ca_scripts

# ---------------------------------------------------------------------------- #
# This defines our CA configuration
[ ca_scripts ]
# interpolation variables defining the directories to use
dir             = %CA_HOME%                     # root data directory of CA
db_dir          = $dir/db                       # database files are kept here
csr_dir         = $dir/csr                      # generated CSRs are kept here
crt_dir         = $dir/crt                      # signed CRTs are kept here
key_dir         = $dir/key                      # generated KEYs are kept here
crl_dir         = $dir/crl                      # generated CRL is kept here
new_certs_dir   = $dir/idx                      # default place for new CRTs

# required settings
database        = $db_dir/index.txt             # database index file
serial          = $db_dir/serial                # serial number index file
certificate     = $crt_dir/%CA_NAME%.ca.crt     # CA certificate
private_key     = $key_dir/%CA_NAME%.ca.key     # CA private key
crl             = $crl_dir/%CA_NAME%.ca.crl     # current CRL
RANDFILE        = $db_dir/.rand                 # private random number file

# these two CA directives can be commented out so that v1 CRLs are created
crlnumber       = $db_dir/crlnumber             # crlnumber index file
crl_extensions  = ca_crl_extensions             # extensions in v2 CRL

# x509v3 certificate extensions and certificate signing policy
x509_extensions = ca_x509_default_extensions
copy_extensions = copy                          # copy extensions from CSR to CRT
policy          = ca_extension_policy           # policy on required CSR attributes

# leave these defaults
name_opt        = oneline               # Subject Name options - x509(1)
cert_opt        = ca_default            # Certificate field options - x509(1)
default_days    = %CA_CRT_DAYS%         # how long to certify for
default_crl_days= %CA_CRL_DAYS%         # how long before next CRL
default_md      = sha1                  # which md to use.
preserve        = no                    # keep passed DN ordering
unique_subject  = no                    # recommended
email_in_dn     = no                    # remove email from CSR DN when signing

# ---------------------------------------------------------------------------- #
# This defines the CA's policy on required CSR attributes.
# It requires:
#   the country [C] to be supplied in the CSR and match the CA
#   the state or province [ST] to be supplied in the CSR
#   the locality [L] to be supplied in the CSR
#   the organisation name [O] to be supplied in the CSR and match the CA
#   the organisational unit [OU] to be supplied in the CSR
#   the server common name [CN] to be supplied in the CSR
# ... and an [emailAddress] may optionally be supplied in the CSR
# XXX: is this too restrictive or not restrictive enough?
#      should options for ca-create-cert to change "match" values even exist?
[ ca_extension_policy ]
countryName             = match
stateOrProvinceName     = supplied
localityName            = supplied
organizationName        = match
organizationalUnitName  = supplied
commonName              = supplied
emailAddress            = optional

# ---------------------------------------------------------------------------- #
# This defines the default x509 extensions present in a cert signed by the CA.
# These should be replaced by a specific set of extensions per certificate.
[ ca_x509_default_extensions ]

# certificates signed by this CA by default are not CA certificates themselves
basicConstraints        = CA:FALSE

# old netscape certificate attributes
nsCertType              = server
nsComment               = "%CA_DESC% Certificate"
nsRevocationUrl         = %CA_CRL_URI%

# key usage restrictions
keyUsage                = nonRepudiation, digitalSignature, keyEncipherment, keyAgreement
extendedKeyUsage        = serverAuth

issuerAltName           = issuer:copy
subjectAltName          = URI:%CA_CRT_URI%
subjectKeyIdentifier    = hash
authorityKeyIdentifier  = keyid,issuer:always
authorityInfoAccess     = caIssuers;URI:%CA_CRT_URI%
crlDistributionPoints   = URI:%CA_CRL_URI%

# ---------------------------------------------------------------------------- #
# This defines the x509 extensions present in the generated CA certificate.
[ ca_x509_extensions ]

# this certificate is authoritative and allowed to sign other certificates
# pathlen=1 implies there may be up to one intermediate CA in the chain
# that leads to this root CA certificate.
basicConstraints        = critical,CA:TRUE,pathlen:%CA_PATHLEN%

# old netscape certificate attributes
nsCertType              = objsign, sslCA, emailCA, objCA
nsComment               = "%CA_DESC%"
nsRevocationUrl         = %CA_CRL_URI%
nsCaRevocationUrl       = %CA_CRL_URI%

# key usage restrictions
keyUsage                = critical, cRLSign, keyCertSign
extendedKeyUsage        = serverAuth, clientAuth, codeSigning, emailProtection, timeStamping

issuerAltName           = @ca_altname
subjectAltName          = @ca_altname
subjectKeyIdentifier    = hash
authorityKeyIdentifier  = keyid,issuer:always
authorityInfoAccess     = caIssuers;URI:%CA_CRT_URI%
crlDistributionPoints   = URI:%CA_CRL_URI%

# ---------------------------------------------------------------------------- #
# This is a separate section defining the attributes in the CA's subjectAltName.
[ ca_altname ]
URI=%CA_CRT_URI%
DNS.1=%CA_DOMAIN%
DNS.2=*.%CA_DOMAIN%
email=%CA_EMAIL%

# ---------------------------------------------------------------------------- #
# This defines the extensions present in the CRLs generated by this CA.
[ ca_crl_extensions ]
issuerAltName           = issuer:copy
authorityKeyIdentifier  = keyid:always, issuer:always
# the below is only supported in the very latest releases of openssl
# issuingDistributionPoint= URI:%CA_CRL_URI%

# ---------------------------------------------------------------------------- #
# This defines the extensions present in the CSRs created by this CA.
[ ca_req_extensions ]
basicConstraints        = critical, CA:FALSE
keyUsage                = critical, nonRepudiation, keyEncipherment, keyAgreement
extendedKeyUsage        = serverAuth

# ---------------------------------------------------------------------------- #
# This defines default settings for certificate requests and CA cert creation.
[ req ]
default_bits            = %CA_CRT_BITS%
default_md              = sha1
distinguished_name      = ca_req_dn
x509_extensions         = ca_x509_extensions
req_extensions          = ca_req_extensions
string_mask             = nombstr
prompt                  = no

# ---------------------------------------------------------------------------- #
# This defines the DN of the CA certificate.
[ ca_req_dn ]
C                       = %CA_DN_C%
ST                      = %CA_DN_ST%
L                       = %CA_DN_L%
O                       = %CA_DN_O%
OU                      = %CA_DN_OU%
CN                      = %CA_DN_CN%
