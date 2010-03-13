ca-scripts
==========

A set of **bash**(1) scripts for working with SSL Certificate Authorities.

These scripts are designed to provide a configurable wrapping layer around
[**openssl**(1)](http://www.openssl.org/), similar to CA.pl. They're potentially
a little heavyweight if you just need a single self-signed certificate to secure
an HTTPs webserver, but they may come in handy if you want to:

  * Generate multiple service certificates signed by a single authority
  * Provide signed client certificates to end users for authentication purposes
  * Provide client certificates for S/MIME encrypted e-mail or code signing
  * Easily set extensions such as x509v3 subjectAltName in your certificates

Portability
-----------

Currently, these scripts are limited to systems with a recent install of
**openssl**(1), GNU **date**(1) -- sorry BSD folks; patches welcome -- and
version 3 or greater of **bash**(1).

Installation
------------

There aren't any tarballs as yet. Nor will the `make` command below work until
I've written a Makefile. It's coming, sometime. Sorry ;-)

    $ git clone git://github.com/fluffle/ca-scripts
    $ cd ca-scripts
    $ make; sudo make install

This will by default install to `/usr/local`, either `export PREFIX=/path` or
`make PREFIX=/path; sudo make PREFIX=/path install` to change this to an
alternative location.

Creating a Certificate Authority
--------------------------------

  Before running **ca-init**(1), a configuration file for the CA scripts must be
created. This configuration file sets up some templating variables that will
be present in certificates created for this CA, such as the domain, CA name,
and the root directory which will be populated with the generated certificates.
An example configuration file is provided with the scripts, and the comments
should be self-explanatory.

  By default the CA scripts will read `/etc/ca-scripts.conf`. This is fine for
creating a single CA serving a single domain with no intermediary certificates,
but for a more complex setup a directory of configuration files will probably
be needed. Some settings are required, namely the **CA\_HOME**, **CA\_DOMAIN**,
and **CA\_DN\_\*** variables, while others can be inferred from these or have
sensible defaults set. See **ca-scripts.conf**(5) for more detail on these.

  Once the configuration has been created the initial CA setup can be performed
with **ca-init(1)**, but please note that the path set in **CA\_HOME** must exist
and be writeable before it will run correctly. It is recommended (but not in an
way required) to create an unprivileged "ssl" user to run all the scripts as, so
the permissions are correctly set. A number of subdirectories will be set
up underneath this root, and an openssl configuration file, certificate and
private key will be generated. This key can be 3DES encrypted for security.

  Optionally, it is possible to split the initial setup process so that the
directory structure and openssl configuration generation can be done in a
seperate step to the generation of the CA certificates, so that the config can
be manually edited. To fully understand it's contents you're unfortunately
going to need to read the following:

  * [**ca**(1ssl)](http://www.openssl.org/docs/apps/ca.html)
  * [**req**(1ssl)](http://www.openssl.org/docs/apps/req.html)
  * [**x509**(1ssl)](http://www.openssl.org/docs/apps/x509.html)
  * [**config**(5ssl)](http://www.openssl.org/docs/apps/config.html)
  * [**x509v3\_config**(5ssl)](http://www.openssl.org/docs/apps/x509v3_config.html)

Particularly important are the x509v3 extensions present in the certificate,
which are defined in the "ca\_x509\_extensions" section of the config file.

Creating a certificate
----------------------

  The **ca-create-cert**(1) script can generate three "types" of certificate:
*server* certificates for securing a service with SSL/TLS; *client* certificates
for authenticating a client to these services; and *user* certificates for
authentication, S/MIME e-mail signing or encryption, and code signing. There
are minor but important differences in the key usage extensions present in
these different certificate types, details can be found in the documentation
for **ca-create-cert**(1). In each case, a Common Name must be provided to give
a unique name for the certificate.

  **ca-create-cert**(1) takes a number of options to customise the generated
certificate. The **--type** option defaults to creating *server* certs. It is
likely that the **--alt-name** option (which sets X.509v3 subjectAltName DNS
records for other hostnames for the server) will be useful; it may also be used
when creating *client* certs.  Both the server hostname and any alternative
names will be fully-qualified to **CA\_DOMAIN** if they do not contain any dots
unless the **--no-qualify** option is used. If unqualified names are passed in
they are preserved as alternative DNS names in the certificate. The private key
may be encrypted with 3DES using the **--encrypt** option, and the certificate,
key, and CA certificate can be bundled together into a PKCS#12 format
certificate archive by passing **--pkcs12**. By default certificates are valid
for 365 days from signing, but this may be changed with the **--days** option.

  The certificate's DN can be completely changed from the defaults provided by
**ca-scripts.conf**(5), but be wary as by default the generated openssl config
file requires that the country (C) and organisation (O) fields match those of
the CA certificate. A comment may also be set that will show up in user browsers
when they click on their padlock icons to examine the certificate's properties.
As  with the CA setup, the steps to generate the certificate can be split up so
that configurations that are created from templates can be edited beforehand.

Renewing a certificate
----------------------

  Certificates are renewed using **ca-renew-cert**(1). This script currently
does some painful certificate manipulation that is not strictly necessary in
most cases, and may in fact decrease SSL security slightly. This is done because
the normal renewal process re-generates the certificate signing request and
thus creates a new public/private keypair. If the certificates are used for
S/MIME encryption or code signing, this renders all the encrypted e-mail
unreadable and requires you to re-sign the code with your new private key.

  To avoid this, **ca-renew-cert**(1) re-signs the old certificate request with
a new expiry date using the extensions generated when the old certificate was
signed. In the future it is possible (even likely) that this renewal method
will only be used on *user* type certificates, and the *server* and *client*
types will be renewed normally. If the current renewal method doesn't provide
sufficient security, the current certificate should be revoked and a new one
generated that is valid for the correct period of time using the **--days**
option to **ca-create-cert**(1).

  As with the certificate creation script a Common Name can be passed to
identify the certificate to renew; alternatively the path to a previously
created certificate can be given. Internally these will be both be resolved to
the correct information required for certificate renewal.

Revoking a certificate
----------------------

  To revoke a certificate and re-generate the CA certficate revocation list in
both PEM and DER encodings, invoke **ca-revoke-cert**(1), again providing a
Common Name or the path to the certificate to be revoked. Along with
**ca-init**(1) this script can optionally generate a basic HTML template to
serve the CA certificate and CRL with verifiable MD5 and SHA1 checksums.
