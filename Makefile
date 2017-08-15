OUTPUT := ./

PRODUCT_NAME := desktopeditors
PRODUCT_VERSION ?= 0.0.0

ifeq ($(OS),Windows_NT)
    PLATFORM := win
    EXEC_EXT := .exe
    SCRIPT_EXT := .bat
    SHARED_EXT := .dll
    ARCH_EXT := .zip
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Linux)
        PLATFORM := linux
	SCRIPT_EXT := .sh
        SHARED_EXT := .so*
	LIB_PREFFIX := lib
        ARCH_EXT := .tar.gz
    endif
endif

UNAME_M := $(shell uname -m)
ifeq ($(UNAME_M),x86_64)
	ARCHITECTURE := 64
	ARCH_SUFFIX := x64
endif
ifneq ($(filter %86,$(UNAME_M)),)
	ARCHITECTURE := 32
	ARCH_SUFFIX := x86
endif

PACKAGE_NAME := $(PRODUCT_NAME)-$(PRODUCT_VERSION)
ARCHIVE_NAME := $(PACKAGE_NAME)-$(ARCH_SUFFIX)$(ARCH_EXT)

PACKAGE := $(OUTPUT)/$(PACKAGE_NAME)
ARCHIVE := $(OUTPUT)/$(ARCHIVE_NAME)

TARGET := $(PLATFORM)_$(ARCHITECTURE)

CONVERTER_BINARIES += core/build/lib/$(TARGET)/$(LIB_PREFFIX)DjVuFile$(SHARED_EXT)
CONVERTER_BINARIES += core/build/lib/$(TARGET)/$(LIB_PREFFIX)doctrenderer$(SHARED_EXT)
CONVERTER_BINARIES += core/build/lib/$(TARGET)/$(LIB_PREFFIX)HtmlFile$(SHARED_EXT)
CONVERTER_BINARIES += core/build/lib/$(TARGET)/$(LIB_PREFFIX)HtmlRenderer$(SHARED_EXT)
CONVERTER_BINARIES += core/build/lib/$(TARGET)/$(LIB_PREFFIX)PdfReader$(SHARED_EXT)
CONVERTER_BINARIES += core/build/lib/$(TARGET)/$(LIB_PREFFIX)PdfWriter$(SHARED_EXT)
CONVERTER_BINARIES += core/build/lib/$(TARGET)/$(LIB_PREFFIX)XpsFile$(SHARED_EXT)
CONVERTER_BINARIES += core/build/lib/$(TARGET)/$(LIB_PREFFIX)UnicodeConverter$(SHARED_EXT)

ifeq ($(PLATFORM),linux)
CONVERTER_BINARIES += core/Common/3dParty/icu/$(TARGET)/build/libicudata$(SHARED_EXT)
CONVERTER_BINARIES += core/Common/3dParty/icu/$(TARGET)/build/libicuuc$(SHARED_EXT)
CONVERTER_BINARIES += core/Common/3dParty/v8/$(TARGET)/icudtl.dat
endif

ifeq ($(PLATFORM),win)
CONVERTER_BINARIES += core/Common/3dParty/icu/$(TARGET)/build/icudt55$(SHARED_EXT)
CONVERTER_BINARIES += core/Common/3dParty/icu/$(TARGET)/build/icuuc55$(SHARED_EXT)
CONVERTER_BINARIES += core/Common/3dParty/v8/$(TARGET)/release/icudt.dll
endif

CONVERTER_BINARIES += core/build/bin/$(TARGET)/x2t$(EXEC_EXT)

CONVERTER_BINARIES += desktop-apps/common/converter/DoctRenderer.config

#CONVERTER_BINARIES += empty

HTML_FILE_INTERNAL_FILES += core/build/lib/$(TARGET)/HtmlFileInternal$(EXEC_EXT)
HTML_FILE_INTERNAL_FILES += core/Common/3dParty/cef/$(TARGET)/build/**


SCRIPTS += web-apps/deploy/**

QT_PATH := $(shell qmake -v | grep Using | sed -e 's/Using Qt version 5\.6\.[0-9]\+ in \(.*\)/\1/')
QT_LINKED := shared
QT_PLUGINS_PATH := $(QT_PATH)/../plugins
QT_PLUGINS += $(QT_PLUGINS_PATH)/bearer
QT_PLUGINS += $(QT_PLUGINS_PATH)/imageformats
QT_PLUGINS += $(QT_PLUGINS_PATH)/platforminputcontexts
QT_PLUGINS += $(QT_PLUGINS_PATH)/platforms
QT_PLUGINS += $(QT_PLUGINS_PATH)/platformthemes
QT_PLUGINS += $(QT_PLUGINS_PATH)/printsupport
QT_PLUGINS += $(QT_PLUGINS_PATH)/xcbglintegrations

QT_LIBS_PATH := $(QT_PATH)
QT_LIBS += $(QT_LIBS_PATH)/$(LIB_PREFFIX)Qt5Core$(SHARED_EXT)
QT_LIBS += $(QT_LIBS_PATH)/$(LIB_PREFFIX)Qt5DBus$(SHARED_EXT)
QT_LIBS += $(QT_LIBS_PATH)/$(LIB_PREFFIX)Qt5Gui$(SHARED_EXT)
QT_LIBS += $(QT_LIBS_PATH)/$(LIB_PREFFIX)Qt5Network$(SHARED_EXT)
QT_LIBS += $(QT_LIBS_PATH)/$(LIB_PREFFIX)Qt5PrintSupport$(SHARED_EXT)
QT_LIBS += $(QT_LIBS_PATH)/$(LIB_PREFFIX)Qt5Widgets$(SHARED_EXT)
QT_LIBS += $(QT_LIBS_PATH)/$(LIB_PREFFIX)Qt5X11Extras$(SHARED_EXT)
QT_LIBS += $(QT_LIBS_PATH)/$(LIB_PREFFIX)Qt5XcbQpa$(SHARED_EXT)

COMMON_BINARIES += $(HTML_FILE_INTERNAL_FILES)

ifeq ($(QT_LINKED),shared)
COMMON_BINARIES += $(QT_LIBS) 
COMMON_BINARIES += $(QT_PLUGINS)
endif

SYS_LIB_PATH := /usr/lib
ICU_LIBS += $(SYS_LIB_PATH)/x86_64-linux-gnu/$(LIB_PREFFIX)icudata$(SHARED_EXT)
ICU_LIBS += $(SYS_LIB_PATH)/x86_64-linux-gnu/$(LIB_PREFFIX)icui18n$(SHARED_EXT)
ICU_LIBS += $(SYS_LIB_PATH)/x86_64-linux-gnu/$(LIB_PREFFIX)icuuc$(SHARED_EXT)

ifeq ($(PLATFORM),linux)
COMMON_BINARIES += $(ICU_LIBS)
endif

COMMON_BINARIES += desktop-apps/win-linux/ASCDocumentEditor.build/DesktopEditors
COMMON_BINARIES += desktop-apps/common/loginpage/deploy/index.html

COMMON_BINARIES += core/build/lib/$(TARGET)/$(LIB_PREFFIX)ascdocumentscore$(SHARED_EXT)
COMMON_BINARIES += core/build/lib/$(TARGET)/$(LIB_PREFFIX)ooxmlsignature$(SHARED_EXT)
COMMON_BINARIES += core/build/lib/$(TARGET)/$(LIB_PREFFIX)hunspell$(SHARED_EXT)
COMMON_BINARIES += core/Common/3dParty/openssl/openssl/$(LIB_PREFFIX)crypto$(SHARED_EXT)

COMMON_BINARIES += desktop-apps/common/package/license/3dparty/3DPARTYLICENSE

LICENSE += desktop-apps/common/package/license/agpl-3.0.htm

DICTIONARIES += dictionaries/**

.PHONY: all clean

all: $(PACKAGE)

$(PACKAGE):
	mkdir -p $(PACKAGE)
	cp -r -t $(PACKAGE) $(COMMON_BINARIES)
	cp $(LICENSE) $(PACKAGE)/LICENSE.htm

	mkdir -p $(PACKAGE)/converter
	cp -r -t $(PACKAGE)/converter $(CONVERTER_BINARIES)

	mkdir -p $(PACKAGE)/editors
	cp -r -t $(PACKAGE)/editors $(SCRIPTS)

	mkdir -p $(PACKAGE)/dictionaries
	cp -r -t $(PACKAGE)/dictionaries $(DICTIONARIES)

clean:
	rm -fr $(PACKAGE)
