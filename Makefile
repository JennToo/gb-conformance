TOOLS_PREFIX := $(abspath ./build/tools)
AS           := $(TOOLS_PREFIX)/bin/rgbasm
LD           := $(TOOLS_PREFIX)/bin/rgblink
FIX          := $(TOOLS_PREFIX)/bin/rgbfix
TOOLS        := $(AS) $(LD) $(FIX)

.PHONY: all
all: $(TOOLS)

$(TOOLS): rgbds | $(TOOLS_PREFIX)
	make -C rgbds install PREFIX=$(TOOLS_PREFIX)

$(TOOLS_PREFIX):
	mkdir -p $@

rgbds:
	git submodule update --init

.PHONY: clean
clean:
	make -C rgbds clean
	rm -rf build
