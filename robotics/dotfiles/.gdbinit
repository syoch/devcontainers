# ---------- Configuration ----------
set print pretty on
set print object on
set print static-members on
set print vtbl on
set print demangle on
set print asm-demangle on
set print elements 0
set demangle-style gnu-v3
set pagination off

# ---------- Functions ----------
define lvt
  set $vt = $arg0
  set $vec = *(uint32_t [2]*)$vt

  set $msp=$vec[0]
  set $pc=$vec[1]

  printf "Vector table [\e[1;32m%08x\e[m]\n", $vt
  printf "  MSP = \e[32m%08x\e[m\n", $msp
  printf "  PC  = \e[32m%08x\e[m\n", $pc
end

define lfb
  printf "\e[1;34mLoading Fast-Bootloader\e[m\n"
  lvt 0x0800f800
end
define lbl
  printf "\e[1;34mLoading ST's bootloader\e[m\n"
  lvt 0x1FFFd800
end
define lap
  printf "\e[1;34mLoading user application\e[m\n"
  lvt 0x08000000
end

# ---------- Load target ----------

define ta
  file /workspaces/korobo-2025-d/build/NUCLEO_F303K8/src/F303K8-HAL-build/src/80-f3b-robobus/80-f3b-robobus
end

define tb
  file /workspaces/korobo-2025-d/build/NUCLEO_F303K8/src/F303K8-HAL-build/Bootloader/src/Bootloader-build/fast-bootloader
end

define tg
  target remote localhost:4242

  display SCB->ICSR & 0x1FF
  display /x SCB->HFSR
end

# ---------- display ... ----------
display /i $pc
