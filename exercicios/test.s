    .section .data                   # Data section
input_data:                          # Label to store input
    .space 10                        # Allocate 10 bytes for the input

    .section .text                   # Code section
    .globl _start                    # Global label, entry point of the program

_start:
    # Read 10 bytes from standard input
    li a7, 63                        # System call number for read (adjust if needed)
    li a0, 0                         # File descriptor 0 (stdin)
    la a1, input_data                # Address to store the read data
    li a2, 10                        # Number of bytes to read
    ecall                            # Perform the system call

    # Write 10 bytes to standard output
    li a7, 64                        # System call number for write (adjust if needed)
    li a0, 1                         # File descriptor 1 (stdout)
    la a1, input_data                # Address of the data to write
    li a2, 10                        # Number of bytes to write
    ecall                            # Perform the system call

    ret