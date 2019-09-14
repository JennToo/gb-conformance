SECTION	"VBlank",ROM0[$0040]
	reti
SECTION	"LCDC",ROM0[$0048]
	reti
SECTION	"Timer",ROM0[$0050]
	reti
SECTION	"Serial",ROM0[$0058]
	reti
SECTION	"Control",ROM0[$0060]
	reti

SECTION	"start",ROM0[$0100]
    nop
    jp main

SECTION "main",ROM0[$0150]
main:
    di
    ld sp,$DFFF
    call setup
    call passed
