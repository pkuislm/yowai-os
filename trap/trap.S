.global mtrap_vector
    .section .text
    .align 4
    mtrap_vector:
    nop                     # User Software Interrupt
    nop                     # Supervisor software Interrupt
    nop                     # 
    nop                     # Machine software Interrupt
    nop                     # User timer Interrupt
    nop                     # Supervisor timer Interrupt
    nop                     #
    nop                     # Machine timer Interrupt