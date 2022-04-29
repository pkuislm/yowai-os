display/z $x1
display/z $x2
display/z $x5
display/z $x6
display/z $x7
display/z $a0
display/z $a1
display/z $a2
display/z $a3
display/z $a4
display/z $a5

set disassemble-next-line on
b _start
target remote : 1234
c
