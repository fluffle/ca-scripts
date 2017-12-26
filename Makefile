NAME=tiny-ca
VERSION=0.9.0

DIRS=bin lib tpl
INSTALL_DIRS=`find $(DIRS) -type d 2>/dev/null`
INSTALL_FILES=`find $(DIRS) -type f 2>/dev/null`
DOC_FILES=*.conf *.md doc/*.pod
SCRIPTS=tiny-ca

PKG_DIR=tiny-ca
PKG_NAME=$(NAME)_$(VERSION)
PKG=$(PKG_DIR)/$(PKG_NAME).tar.gz
SIG=$(PKG_DIR)/$(PKG_NAME).asc

PREFIX?=/usr/local/$(NAME)

pkg:
	mkdir -p $(PKG_DIR)

$(PKG): pkg
	git archive --output=$(PKG) --prefix=$(PKG_NAME)/ HEAD

build: $(PKG)

$(SIG): $(PKG)
	gpg --sign --detach-sign --armor $(PKG)

sign: $(SIG)

clean:
	rm -f $(PKG) $(SIG)

all: $(PKG) $(SIG)

test:

tag:
	git tag v$(VERSION)
	git push --tags

release: $(PKG) $(SIG) tag

install:	
	for dir in $(INSTALL_DIRS); do mkdir -p $(PREFIX)/$$dir; done
	for file in $(INSTALL_FILES); do cp $$file $(PREFIX)/$$file; done

symlinks:
	for link in $(SCRIPTS); do ln -s $(PREFIX)/bin/$$link /usr/local/bin/$$link; done

uninstall:
	for file in $(INSTALL_FILES); do rm -f $(PREFIX)/$$file; done	

rmsymlinks:
	for link in $(SCRIPTS); do rm -f /usr/local/bin/$$link; done


.PHONY: build sign clean test tag release install uninstall all

