SECTION "lib",ROMX

INCLUDE "hardware.inc"

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
    ld bc,_VRAM
    call memcpy
    ret

EXPORT setup_vram
setup_vram:

    ld a,0
    ld [rSCY],a
    ld [rSCX],a

    ld a,%11100100
    ld [rBGP],a

    ld hl,starting
    ld de,(starting_end-starting)
    ld bc,$9800
    call memcpy

    ld a,(LCDCF_ON | LCDCF_WINOFF | LCDCF_BG8000 | LCDCF_BG9800 | LCDCF_OBJOFF | LCDCF_BGON)
    ld [rLCDC],a

    ret

EXPORT setup
setup:
    call wait_for_vblank
    call disable_lcd
    call setup_font
    call setup_vram
    ret

EXPORT passed
passed:
    call wait_for_vblank
    ld hl,passed_msg
    ld de,(passed_msg_end-passed_msg)
    ld bc,$9800
    call memcpy
.passed_wait:
    ei
    halt
    nop
    jp .passed_wait


EXPORT wait_for_vblank
wait_for_vblank:
    ld a,[rLY]
    cp 145
    jp nz,wait_for_vblank
    ret

disable_lcd:
    ld a,[rLCDC]
    res 7,a
    ld [rLCDC],a
    ret

font_data:
INCBIN "build/font.2bpp"
font_data_end:

starting:
DB "Starting"
starting_end:

passed_msg:
DB "Passed     "
passed_msg_end:
