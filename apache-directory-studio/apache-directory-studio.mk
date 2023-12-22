#!/usr/bin/make -f
APACHEDIRECTORYSTUDIOVERSION := 2.0.0.v20210717-M17
APACHEDIRECTORYSTUDIOFILENAME := ApacheDirectoryStudio-$(APACHEDIRECTORYSTUDIOVERSION)-linux.gtk.x86_64.tar.gz
APACHEDIRECTORYSTUDIORELEASEDOWNLOAD := https://dlcdn.apache.org/directory/studio/$(APACHEDIRECTORYSTUDIOVERSION)/$(APACHEDIRECTORYSTUDIOFILENAME)

build/apache-directory-studio/$(APACHEDIRECTORYSTUDIOFILENAME): $(COMMONDEPENDENCIES)
	rm -f $@
	wget $(APACHEDIRECTORYSTUDIORELEASEDOWNLOAD) --directory-prefix=build/apache-directory-studio
	echo "hurray"

build/apache-directory-studio/apache-directory-studio-$(APACHEDIRECTORYSTUDIOVERSION)/LICENSE: build/apache-directory-studio/$(APACHEDIRECTORYSTUDIOFILENAME) $(COMMONDEPENDENCIES)
	rm -f $@
	cd build/apache-directory-studio && tar xvzf $(APACHEDIRECTORYSTUDIOFILENAME)

build/apache-directory-studio/apache-directory-studio_$(APACHEDIRECTORYSTUDIOVERSION)_amd64/DEBIAN/control: $(COMMONDEPENDENCIES) apache-directory-studio/control build/apache-directory-studio/apache-directory-studio-$(APACHEDIRECTORYSTUDIOVERSION)/LICENSE
	rm -fR build/apache-directory-studio/apache-directory-studio_$(APACHEDIRECTORYSTUDIOVERSION)_amd64
	mkdir -p build/apache-directory-studio/apache-directory-studio_$(APACHEDIRECTORYSTUDIOVERSION)_amd64
	mkdir -p build/apache-directory-studio/apache-directory-studio_$(APACHEDIRECTORYSTUDIOVERSION)_amd64/DEBIAN
	mkdir -p build/apache-directory-studio/apache-directory-studio_$(APACHEDIRECTORYSTUDIOVERSION)_amd64/opt
	mkdir -p build/apache-directory-studio/apache-directory-studio_$(APACHEDIRECTORYSTUDIOVERSION)_amd64/opt/apache-directory-studio
	mkdir -p build/apache-directory-studio/apache-directory-studio_$(APACHEDIRECTORYSTUDIOVERSION)_amd64/usr
	mkdir -p build/apache-directory-studio/apache-directory-studio_$(APACHEDIRECTORYSTUDIOVERSION)_amd64/usr/local
	mkdir -p build/apache-directory-studio/apache-directory-studio_$(APACHEDIRECTORYSTUDIOVERSION)_amd64/usr/local/share
	mkdir -p build/apache-directory-studio/apache-directory-studio_$(APACHEDIRECTORYSTUDIOVERSION)_amd64/usr/local/share/applications
	mkdir -p build/apache-directory-studio/apache-directory-studio_$(APACHEDIRECTORYSTUDIOVERSION)_amd64/usr/local/share/pixmaps
	cp build/apache-directory-studio/ApacheDirectoryStudio/icon.xpm build/apache-directory-studio/apache-directory-studio_$(APACHEDIRECTORYSTUDIOVERSION)_amd64/usr/local/share/pixmaps/apache-directory-studio.xpm
	cp apache-directory-studio/apache-directory-studio.desktop build/apache-directory-studio/apache-directory-studio_$(APACHEDIRECTORYSTUDIOVERSION)_amd64/usr/local/share/applications
	cp -R build/apache-directory-studio/ApacheDirectoryStudio/* build/apache-directory-studio/apache-directory-studio_$(APACHEDIRECTORYSTUDIOVERSION)_amd64/opt/apache-directory-studio/
	cp apache-directory-studio/control build/apache-directory-studio/apache-directory-studio_$(APACHEDIRECTORYSTUDIOVERSION)_amd64/DEBIAN/control
	sed -i 's/##VERSION##/$(APACHEDIRECTORYSTUDIOVERSION)/g' build/apache-directory-studio/apache-directory-studio_$(APACHEDIRECTORYSTUDIOVERSION)_amd64/DEBIAN/control

build/apache-directory-studio/apache-directory-studio_$(APACHEDIRECTORYSTUDIOVERSION)_amd64.deb: build/apache-directory-studio/apache-directory-studio_$(APACHEDIRECTORYSTUDIOVERSION)_amd64/DEBIAN/control
	rm -f $@
	cd build/apache-directory-studio/ && dpkg-deb --build --root-owner-group apache-directory-studio_$(APACHEDIRECTORYSTUDIOVERSION)_amd64

apache-directory-studio: build/apache-directory-studio/apache-directory-studio_$(APACHEDIRECTORYSTUDIOVERSION)_amd64.deb $(COMMONDEPENDENCIES) $(APTREPOSHARE)/guard
	cp $< $(APTREPOSHARE)/pool/main/apache-directory-studio_$(APACHEDIRECTORYSTUDIOVERSION)_amd64.deb