tiny-ca
==========

tiny-ca is forked from awesome [ca-scripts](https://github.com/fluffle/ca-scripts). It's pretty much the same scripts, but with a few tweaks/changes that doesn't make sense to merge into main repo.

The main differences from ca-scripts are

* MacOS support
* UTF-8 is default encoding.
* Per directory configuration (in addition to /etc/tiny-ca.conf and $HOME/.tiny-ca.cong)
* Openssl config templates are now copied to CA home to allow their customization on per CA basis.

Installation
==========
```
git clone http://github.com/sovcharenko/tiny-ca
cd tiny-ca
[sudo] make install
[sudo] make symlinks
```

MacOS note
==========
tiny-ca requires the following brew packages installed
```
brew install coreutils
brew install gnu-getopt
brew install gnu-sed
```
