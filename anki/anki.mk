#!/usr/bin/make -f
ANKIVERSION := 2.1.65
ANKIFILENAME := anki-$(ANKIVERSION)-linux-qt6
ANKIRELEASEDOWNLOAD := https://github.com/ankitects/anki/releases/download/$(ANKIVERSION)/$(ANKIFILENAME).tar.zst

build/anki/$(ANKIFILENAME).tar.zst: $(COMMONDEPENDENCIES)
	rm -f $@
	wget $(ANKIRELEASEDOWNLOAD) --directory-prefix=build/anki

build/anki/anki-$(ANKIVERSION)/README.md: build/anki/$(ANKIFILENAME).tar.zst $(COMMONDEPENDENCIES)
	rm -f $@
	cd build/anki && tar -I zstd -xf $(ANKIFILENAME).tar.zst
	patch -u build/anki/$(ANKIFILENAME)/anki.desktop -i anki/anki.desktop.patch

build/anki/anki_$(ANKIVERSION)_amd64/DEBIAN/control: $(COMMONDEPENDENCIES) anki/control build/anki/anki-$(ANKIVERSION)/README.md
	rm -fR build/anki/anki_$(ANKIVERSION)_amd64
	mkdir -p build/anki/anki_$(ANKIVERSION)_amd64
	mkdir -p build/anki/anki_$(ANKIVERSION)_amd64/DEBIAN
	mkdir -p build/anki/anki_$(ANKIVERSION)_amd64/usr
	mkdir -p build/anki/anki_$(ANKIVERSION)_amd64/usr/local
	mkdir -p build/anki/anki_$(ANKIVERSION)_amd64/usr/local/bin
	mkdir -p build/anki/anki_$(ANKIVERSION)_amd64/usr/local/share
	mkdir -p build/anki/anki_$(ANKIVERSION)_amd64/usr/local/share/anki
	mkdir -p build/anki/anki_$(ANKIVERSION)_amd64/usr/local/share/applications
	mkdir -p build/anki/anki_$(ANKIVERSION)_amd64/usr/local/share/pixmaps
	mkdir -p build/anki/anki_$(ANKIVERSION)_amd64/usr/local/share/man
	mkdir -p build/anki/anki_$(ANKIVERSION)_amd64/usr/local/share/man/man1
	cp build/anki/$(ANKIFILENAME)/anki.xpm build/anki/anki_$(ANKIVERSION)_amd64/usr/local/share/pixmaps
	cp build/anki/$(ANKIFILENAME)/anki.png build/anki/anki_$(ANKIVERSION)_amd64/usr/local/share/pixmaps
	cp build/anki/$(ANKIFILENAME)/anki.desktop build/anki/anki_$(ANKIVERSION)_amd64/usr/local/share/applications
	cp build/anki/$(ANKIFILENAME)/anki.1 build/anki/anki_$(ANKIVERSION)_amd64/usr/local/share/man/man1
	cp -R build/anki/$(ANKIFILENAME)/lib build/anki/anki_$(ANKIVERSION)_amd64/usr/local/share/anki
	cp build/anki/$(ANKIFILENAME)/anki build/anki/anki_$(ANKIVERSION)_amd64/usr/local/share/anki
	ln -s ../share/anki/anki build/anki/anki_$(ANKIVERSION)_amd64/usr/local/bin/anki
	cp anki/control build/anki/anki_$(ANKIVERSION)_amd64/DEBIAN/control
	sed -i 's/##VERSION##/$(ANKIVERSION)/g' build/anki/anki_$(ANKIVERSION)_amd64/DEBIAN/control

build/anki/anki_$(ANKIVERSION)_amd64.deb: build/anki/anki_$(ANKIVERSION)_amd64/DEBIAN/control
	rm -f $@
	cd build/anki/ && dpkg-deb --build --root-owner-group anki_$(ANKIVERSION)_amd64

anki: build/anki/anki_$(ANKIVERSION)_amd64.deb $(COMMONDEPENDENCIES) $(APTREPOSHARE)/guard
	cp $< $(APTREPOSHARE)/pool/main/anki_$(ANKIVERSION)_amd64.deb