.PHONY: all clean install uninstall

all:
	cd core/Common/3dParty/ && ./make.sh
	cd core && $(MAKE) all desktop #ext

	cd sdkjs && $(MAKE) desktop

	cd desktop-apps && $(MAKE) all
	
clean:
	cd core && $(MAKE) clean
	cd sdkjs &&  $(MAKE) clean
	cd desktop-apps && $(MAKE) clean

install:
	cd desktop-apps && $(MAKE) install

uninstall:
	cd desktop-apps && $(MAKE) uninstall