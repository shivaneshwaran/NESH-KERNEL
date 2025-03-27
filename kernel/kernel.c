void kernel_main() {
    char *video_memory = (char*) 0xB8000;  // VGA text mode memory address
    const char *message = "Welcome to NESH OS!";
    int i = 0;

    while (message[i]) {
        video_memory[i * 2] = message[i];   // Character
        video_memory[i * 2 + 1] = 0x07;     // White text on black background
        i++;
    }

    while (1) {
        __asm__ volatile ("hlt");  // Halt the CPU
    }
}
