TOOLS_PREFIX := ./build/tools
AS           := $(TOOLS_PREFIX)/bin/rgbasm
LD           := $(TOOLS_PREFIX)/bin/rgblink
FIX          := $(TOOLS_PREFIX)/bin/rgbfix
GFX          := $(TOOLS_PREFIX)/bin/rgbgfx
TOOLS        := $(AS) $(LD) $(FIX) $(GFX)

AS_FLAGS  := -i ./include/hardware/
LD_FLAGS  :=
FIX_FLAGS := -f lhg

OBJ_DIR  := ./build/objs
ROM_DIR  := ./build/roms
LIB_SRCS := $(shell find lib -type f -name '*.asm')
LIB_OBJS := $(LIB_SRCS:%.asm=$(OBJ_DIR)/%.o)
SRCS     := $(shell find tests -type f -name '*.asm')
OBJS     := $(SRCS:%.asm=$(OBJ_DIR)/%.o)
ROMS     := $(SRCS:%.asm=$(ROM_DIR)/%.gb)

FONT_SRC := font.png
FONT_OUT := build/font.2bpp

.SECONDARY: $(ROMS) $(OBJS) $(LIB_OBJS)

.DELETE_ON_ERROR:

.PHONY: all
all: $(ROMS)

$(TOOLS): rgbds | $(TOOLS_PREFIX)
	make -C rgbds install PREFIX="$(abspath $(TOOLS_PREFIX))"

$(OBJ_DIR)/%.o: ./%.asm $(AS)
	mkdir -p $(@D)
	$(AS) $(AS_FLAGS) -o $@ $<

$(ROM_DIR)/%.gb: $(OBJ_DIR)/%.o $(LIB_OBJS) $(LD) $(FIX) $(FONT_OUT)
	mkdir -p $(@D)
	$(LD) $(LD_FLAGS) -o $@ $(LIB_OBJS) $<
	$(FIX) $(FIX_FLAGS) $@

$(FONT_OUT): $(FONT_SRC) $(GFX)
	$(GFX) -o $@ $<

$(TOOLS_PREFIX):
	mkdir -p $@

rgbds:
	git submodule update --init

.PHONY: clean
clean:
	make -C rgbds clean
	rm -rf build
