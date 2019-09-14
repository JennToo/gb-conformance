SECTION "lib",ROMX
EXPORT memcpy

memcpy:
    ld a,[hl+]
    ld [bc],a
    inc bc
    dec de
    ld a,d
    or e
    jp nz,memcpy
    ret

EXPORT setup_font

setup_font:
    ld hl,font_data
    ld de,(font_data_end-font_data)
    ld bc,$8000
    call memcpy
    ret

font_data:
INCBIN "build/font.2bpp"
font_data_end:
