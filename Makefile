#!/usr/bin/make -f
APTREPOSHARE := /mnt/apt-repo-share
COMMONDEPENDENCIES := Makefile build/guard $(APTREPOSHARE)/guard anki/anki.mk
WORKINGDIRECTORY := $(shell pwd)
GPGKEY := benediktibk@gmail.com

include anki/anki.mk

all: $(APTREPOSHARE)/dists/stable/Release.gpg $(APTREPOSHARE)/dists/stable/InRelease $(APTREPOSHARE)/benediktibk.gpg

clean:
	rm -fR build

build/guard: Makefile
	mkdir -p build
	mkdir -p build/gitkraken
	mkdir -p build/anki
	touch $@

$(APTREPOSHARE)/guard: Makefile
	mkdir -p $(APTREPOSHARE)
	mkdir -p $(APTREPOSHARE)/pool
	mkdir -p $(APTREPOSHARE)/pool/main
	mkdir -p $(APTREPOSHARE)/dists
	mkdir -p $(APTREPOSHARE)/dists/stable
	mkdir -p $(APTREPOSHARE)/dists/stable/main
	mkdir -p $(APTREPOSHARE)/dists/stable/main/binary-amd64
	touch $@

$(APTREPOSHARE)/dists/stable/main/binary-amd64/Packages: $(COMMONDEPENDENCIES) gitkraken anki
	dpkg-scanpackages --arch amd64 $(APTREPOSHARE)/pool > $(APTREPOSHARE)/dists/stable/main/binary-amd64/Packages

$(APTREPOSHARE)/dists/stable/main/binary-amd64/Packages.gz: $(APTREPOSHARE)/dists/stable/main/binary-amd64/Packages
	cat $< | gzip -9 > $@

$(APTREPOSHARE)/dists/stable/Release: $(COMMONDEPENDENCIES) $(APTREPOSHARE)/dists/stable/main/binary-amd64/Packages.gz
	cd $(APTREPOSHARE)/dists/stable && $(WORKINGDIRECTORY)/generate-release.sh > Release

$(APTREPOSHARE)/dists/stable/Release.gpg: $(APTREPOSHARE)/dists/stable/Release $(COMMONDEPENDENCIES)
	cat $< | gpg --default-key $(GPGKEY) -abs > $@

$(APTREPOSHARE)/dists/stable/InRelease: $(APTREPOSHARE)/dists/stable/Release $(COMMONDEPENDENCIES)
	cat $< | gpg --default-key $(GPGKEY) -abs --clearsign > $@

$(APTREPOSHARE)/benediktibk.gpg: benediktibk.gpg $(COMMONDEPENDENCIES)
	cp $< $@

gitkraken: build/gitkraken/gitkraken-amd64.deb $(COMMONDEPENDENCIES) $(APTREPOSHARE)/guard
	cp $< $(APTREPOSHARE)/pool/main/gitkraken_$(shell dpkg-deb --field $< Version)_amd64.deb

build/gitkraken/gitkraken-amd64.deb: $(COMMONDEPENDENCIES)
	echo "already done"
	wget https://release.gitkraken.com/linux/gitkraken-amd64.deb --directory-prefix=build/gitkraken