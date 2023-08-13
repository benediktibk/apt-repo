#!/usr/bin/make -f
ANKIVERSION := 2.1.65
ANKIFILENAME := anki-$(ANKIVERSION)-linux-qt6.tar.zst
ANKIRELEASEDOWNLOAD := https://github.com/ankitects/anki/releases/download/$(ANKIVERSION)/$(ANKIFILENAME)

build/anki/anki.tar.zst: $(COMMONDEPENDENCIES)
	rm -f $@
	wget $(ANKIRELEASEDOWNLOAD) --directory-prefix=build/anki
	mv build/anki/$(ANKIFILENAME) $@

build/anki/anki/README.md: build/anki/anki.tar.zst $(COMMONDEPENDENCIES)
	cd build/anki && tar -I zstd -xf anki.tar.zst