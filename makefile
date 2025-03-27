# Compiler and Assembler
CC = gcc
AS = nasm
LD = ld
CFLAGS = -m32 -ffreestanding -nostdlib -nostartfiles -fno-builtin -fno-stack-protector
ASFLAGS = -f elf32
LDFLAGS = -T linker.ld -m elf_i386

# Output files
OUTPUT = NESHOS.bin
ISO = NESHOS.iso

# Source files
BOOT = boot/boot.asm
KERNEL_ENTRY = boot/kernel_entry.asm
KERNEL_C = kernel/kernel.c

# Object files
OBJS = boot.o kernel_entry.o kernel.o

all: $(ISO)

# Compile bootloader
boot.o: $(BOOT)
	$(AS) $(ASFLAGS) $< -o $@

# Compile kernel entry
kernel_entry.o: $(KERNEL_ENTRY)
	$(AS) $(ASFLAGS) $< -o $@

# Compile kernel (C code)
kernel.o: $(KERNEL_C)
	$(CC) $(CFLAGS) -c $< -o $@

# Link everything into a kernel binary
$(OUTPUT): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $^

# Create bootable ISO
$(ISO): $(OUTPUT)
	mkdir -p iso/boot/grub
	cp $(OUTPUT) iso/boot/NESHOS.bin
	echo 'set timeout=0\nset default=0\nmenuentry "NESH OS" {\nmultiboot /boot/NESHOS.bin\nboot\n}' > iso/boot/grub/grub.cfg
	grub-mkrescue -o $(ISO) iso

# Run in QEMU
run: $(ISO)
	qemu-system-i386 -cdrom $(ISO)

# Clean build files
clean:
	rm -rf $(OBJS) $(OUTPUT) $(ISO) iso
