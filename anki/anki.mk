#!/usr/bin/make -f
ANKIVERSION := 2.1.65
ANKIVERSIONDEB := 2.1-65
ANKIFILENAME := anki-$(ANKIVERSION)-linux-qt6
ANKIRELEASEDOWNLOAD := https://github.com/ankitects/anki/releases/download/$(ANKIVERSION)/$(ANKIFILENAME).tar.zst

build/anki/anki.tar.zst: $(COMMONDEPENDENCIES)
	rm -f $@
	wget $(ANKIRELEASEDOWNLOAD) --directory-prefix=build/anki
	mv build/anki/$(ANKIFILENAME).tar.zst $@

build/anki/anki/README.md: build/anki/anki.tar.zst $(COMMONDEPENDENCIES)
	rm -f $@
	cd build/anki && tar -I zstd -xf anki.tar.zst

build/anki/anki_$(ANKIVERSIONDEB)_arm64/DEBIAN/control: $(COMMONDEPENDENCIES) anki/control
	rm -fR build/anki/anki_$(ANKIVERSIONDEB)_arm64
	mkdir -p build/anki/anki_$(ANKIVERSIONDEB)_arm64
	mkdir -p build/anki/anki_$(ANKIVERSIONDEB)_arm64/DEBIAN
	mkdir -p build/anki/anki_$(ANKIVERSIONDEB)_arm64/usr
	mkdir -p build/anki/anki_$(ANKIVERSIONDEB)_arm64/usr/local
	mkdir -p build/anki/anki_$(ANKIVERSIONDEB)_arm64/usr/local/bin
	mkdir -p build/anki/anki_$(ANKIVERSIONDEB)_arm64/usr/local/share
	mkdir -p build/anki/anki_$(ANKIVERSIONDEB)_arm64/usr/local/share/anki
	mkdir -p build/anki/anki_$(ANKIVERSIONDEB)_arm64/usr/local/share/applications
	mkdir -p build/anki/anki_$(ANKIVERSIONDEB)_arm64/usr/local/share/pixmaps
	mkdir -p build/anki/anki_$(ANKIVERSIONDEB)_arm64/usr/local/share/man
	mkdir -p build/anki/anki_$(ANKIVERSIONDEB)_arm64/usr/local/share/man/man1
	cp build/anki/anki-$(ANKIVERSION)/anki.xpm build/anki/anki_$(ANKIVERSIONDEB)_arm64/usr/local/share/pixmaps
	cp build/anki/anki-$(ANKIVERSION)/anki.png build/anki/anki_$(ANKIVERSIONDEB)_arm64/usr/local/share/pixmaps
	cp build/anki/anki-$(ANKIVERSION)/anki.desktop build/anki/anki_$(ANKIVERSIONDEB)_arm64/usr/local/share/applications
	cp build/anki/anki-$(ANKIVERSION)/anki.1 build/anki/anki_$(ANKIVERSIONDEB)_arm64/usr/local/share/man/man1
	cp -R build/anki/anki-$(ANKIVERSION)/lib build/anki/anki_$(ANKIVERSIONDEB)_arm64/usr/local/share/anki
	cp build/anki/anki-$(ANKIVERSION)/anki build/anki/anki_$(ANKIVERSIONDEB)_arm64/usr/local/bin
	cp anki/control build/anki/anki_$(ANKIVERSIONDEB)_arm64/DEBIAN/control
	sed -i 's/##VERSION##/$(ANKIVERSIONDEB)/g' build/anki/anki_$(ANKIVERSIONDEB)_arm64/DEBIAN/control

build/anki/anki_$(ANKIVERSIONDEB)_arm64.deb: build/anki/anki_$(ANKIVERSIONDEB)_arm64/DEBIAN/control
	rm -f $@
	cd build/anki/ && dpkg-deb --build --root-owner-group anki_$(ANKIVERSIONDEB)_arm64