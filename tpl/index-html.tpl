<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<HTML>
<HEAD><TITLE>%CA_DESC%</TITLE>
<STYLE>
BODY { font-family: arial,sans-serif; }
H1 { font-size: xx-large; margin-left: 50px; }
H3 { font-size: large; margin-top: 50px; margin-left: 50px; }
IMG { border: 0; }
P { width: 700px; margin-left: 100px; }
</STYLE>
</HEAD>

<BODY>
<H1>%CA_DESC%</H1>
<H3>CA Certificate</H3>
<P>The CA certificate can be found
<A href="%CA_CRT_URI%">here</A></P>
<P>MD5 Fingerprint: %CA_CRT_MD5_FP%</P>
<P>SHA1 Fingerprint: %CA_CRT_SHA_FP%</P>
<H3>Certificate Revocation List</H3>
<P>The certificate revocation list can be found
<A href="%CA_CRL_URI%.der">here</A> (DER encoded)
or <A href="%CA_CRL_URI%">here</A> (PEM encoded)</P>
<P>MD5 Fingerprint: %CA_CRL_MD5_FP%</P>
<P>SHA1 Fingerprint: %CA_CRL_SHA_FP%</P>
</BODY>
</HTML>
