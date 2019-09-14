SECTION	"start",ROM0[$0100]
    nop
    jp main

SECTION "main",ROM0[$0150]
main:
    di
    ld sp,$DFFF
    call setup_font
    jp main


setup_font:
    ld hl,font_data
    ld de,(font_data_end-font_data)
    ld bc,$8000
    call memcpy
    ret

memcpy:
    ld a,[hl+]
    ld [bc],a
    inc bc
    dec de
    ld a,d
    or e
    jp nz,memcpy
    ret

font_data:
INCBIN "build/font.2bpp"
font_data_end:
