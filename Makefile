TOOLS_PREFIX := ./build/tools
AS           := $(TOOLS_PREFIX)/bin/rgbasm
LD           := $(TOOLS_PREFIX)/bin/rgblink
FIX          := $(TOOLS_PREFIX)/bin/rgbfix
TOOLS        := $(AS) $(LD) $(FIX)

AS_FLAGS  :=
LD_FLAGS  :=
FIX_FLAGS :=

OBJ_DIR := ./build/objs
ROM_DIR := ./build/roms
SRCS    := $(shell find tests -type f -name '*.asm')
OBJS    := $(SRCS:%.asm=$(OBJ_DIR)/%.o)
ROMS    := $(SRCS:%.asm=$(ROM_DIR)/%.gb)

.DELETE_ON_ERROR:

.PHONY: all
all: $(ROMS)

$(TOOLS): rgbds | $(TOOLS_PREFIX)
	make -C rgbds install PREFIX="$(abspath $(TOOLS_PREFIX))"

$(OBJ_DIR)/%.o: ./%.asm $(AS)
	mkdir -p $(@D)
	$(AS) $(AS_FLAGS) -o $@ $<

$(ROM_DIR)/%.gb: $(OBJ_DIR)/%.o $(LD) $(FIX)
	mkdir -p $(@D)
	$(LD) $(LD_FLAGS) -o $@ $<
	$(FIX) $(FIX_FLAGS) $@

$(TOOLS_PREFIX):
	mkdir -p $@

rgbds:
	git submodule update --init

.PHONY: clean
clean:
	make -C rgbds clean
	rm -rf build
