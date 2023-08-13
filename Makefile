#!/usr/bin/make -f
#APTREPOSHARE := /mnt/apt-repo-share
APTREPOSHARE := /tmp/apt-repo-share
COMMONDEPENDENCIES := Makefile build/guard $(APTREPOSHARE)/guard
WORKINGDIRECTORY := $(shell pwd)

all: $(APTREPOSHARE)/dists/stable/Release

clean:
	rm -fR build

build/guard: Makefile
	mkdir -p build
	mkdir -p build/gitkraken
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

$(APTREPOSHARE)/dists/stable/main/binary-amd64/Packages: $(COMMONDEPENDENCIES) gitkraken
	dpkg-scanpackages --arch amd64 $(APTREPOSHARE)/pool > $(APTREPOSHARE)/dists/stable/main/binary-amd64/Packages

$(APTREPOSHARE)/dists/stable/main/binary-amd64/Packages.gz: $(APTREPOSHARE)/dists/stable/main/binary-amd64/Packages
	cat $< | gzip -9 > $@

$(APTREPOSHARE)/dists/stable/Release: $(COMMONDEPENDENCIES) $(APTREPOSHARE)/dists/stable/main/binary-amd64/Packages.gz
	cd $(APTREPOSHARE)/dists/stable && $(WORKINGDIRECTORY)/generate-release.sh > Release

gitkraken: build/gitkraken/gitkraken-amd64.deb $(COMMONDEPENDENCIES) $(APTREPOSHARE)/guard
	rsync $< $(APTREPOSHARE)/pool/main/gitkraken_$(shell dpkg-deb --field $< Version)_amd64.deb

build/gitkraken/gitkraken-amd64.deb: $(COMMONDEPENDENCIES)
	echo "already done"
#	wget https://release.gitkraken.com/linux/gitkraken-amd64.deb --directory-prefix=build/gitkraken