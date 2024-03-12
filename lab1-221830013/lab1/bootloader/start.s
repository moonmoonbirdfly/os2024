# TODO: This is lab1.1
/* Real Mode Hello World */
#.code16

#.global start
#start:
#	movw %cs, %ax
#	movw %ax, %ds
#	movw %ax, %es
#	movw %ax, %ss
#	movw $0x7d00, %ax
#	movw %ax, %sp # setting stack pointer to 0x7d00
#	pushw $13 
#	pushw $message
#	callw displayStr
#	# TODO:通过中断输出Hello World
#
#loop:
#	jmp loop
#
#message:
#	.string "Hello, World!\n\0"

#displayStr:
# pushw %bp
# movw 4(%esp), %ax #message address
# movw %ax, %bp     #ES:BP=串地址 
# movw 6(%esp), %cx #message.length(13)--> %cx
# movw $0x1301, %ax #AH=13-->print string AL=01-->cursor return origin
# movw $0x000c, %bx #BL=properity,BH=页号
# movw $0x0000, %dx #DH,DL=起始行,列
# int $0x10				#invoke
# popw %bp
# ret

# TODO: This is lab1.2
/* Protected Mode Hello World */

#.code16

#.global start
#start:
#	movw %cs, %ax
#	movw %ax, %ds
#	movw %ax, %es
#	movw %ax, %ss
#	# TODO:关闭中断
#	cli

#	# 启动A20总线
#	inb $0x92, %al #这条指令从I/O端口0x92读取一个字节的数据到寄存器%al中。inb指令用于从指定的I/O端口读取数据。
#	orb $0x02, %al
#	outb %al, $0x92 #这条指令将寄存器%al中的数据写入I/O端口0x92。outb指令用于向指定的I/O端口写入数据。

	# 加载GDTR
#	data32 addr32 lgdt gdtDesc # loading gdtr, data32, addr32

	# TODO：设置CR0的PE位（第0位）为1
#  movl %cr0, %eax
#  orl  $0x1, %eax
#  movl %eax, %cr0


	# 长跳转切换至保护模式
#	data32 ljmp $0x08, $start32 # reload code segment selector and ljmp to start32, data32

#.code32
#start32:
#	movw $0x10, %ax # setting data segment selector
#	movw %ax, %ds
#	movw %ax, %es
#	movw %ax, %fs
#	movw %ax, %ss
#	movw $0x18, %ax # setting graphics data segment selector
#	movw %ax, %gs
	
#	movl $0x8000, %eax # setting esp
#	movl %eax, %esp
#	jmp bootMain
	# TODO:输出Hello World
		
#loop32:
#	jmp loop32

#message:
#	.string "Hello, World!\n\0"



#.p2align 2
#gdt: # 8 bytes for each table entry, at least 1 entry
	# .word limit[15:0],base[15:0]
	# .byte base[23:16],(0x90|(type)),(0xc0|(limit[19:16])),base[31:24]
	# GDT第一个表项为空
#	.word 0,0
#	.byte 0,0,0,0

	# TODO：code segment entry
#	.word 0xffff,0
#	.byte 0,0x9e,0xcf,0

	# TODO：data segment entry
#	.word 0xffff,0
#	.byte 0,0x92,0xcf,0

	# TODO：graphics segment entry
#	.word 0xffff,0x8000
#	.byte 0x0b,0x92,0xcf,0

#gdtDesc: 
#	.word (gdtDesc - gdt -1) 
#	.long gdt 


#TODO: This is lab1.3
/* Protected Mode Loading Hello World APP */
.code16

.global start
start:
	movw %cs, %ax
	movw %ax, %ds
	movw %ax, %es
	movw %ax, %ss
	# TODO:关闭中断
  cli

	# 启动A20总线
	inb $0x92, %al 
 orb $0x02, %al
	outb %al, $0x92

	# 加载GDTR
	data32 addr32 lgdt gdtDesc # loading gdtr, data32, addr32

	# TODO：设置CR0的PE位（第0位）为1
  movl %cr0, %eax
  orl  $0x1, %eax
  movl %eax, %cr0

	# 长跳转切换至保护模式
	data32 ljmp $0x08, $start32 # reload code segment selector and ljmp to start32, data32

.code32
start32:
	movw $0x10, %ax # setting data segment selector
	movw %ax, %ds
	movw %ax, %es
	movw %ax, %fs
	movw %ax, %ss
	movw $0x18, %ax # setting graphics data segment selector
	movw %ax, %gs
	
	movl $0x8000, %eax # setting esp
	movl %eax, %esp
	jmp bootMain # jump to bootMain in boot.c

.p2align 2
gdt: # 8 bytes for each table entry, at least 1 entry
	# .word limit[15:0],base[15:0]
  # .byte base[23:16],(0x90|(type)),(0xc0|(limit[19:16])),base[31:24]
	# GDT第一个表项为空
	.word 0,0
	.byte 0,0,0,0

	# TODO：code segment entry
	.word 0xffff,0
	.byte 0,0x9e,0xcf,0

	# TODO：data segment entry
	.word 0xffff,0
	.byte 0,0x92,0xcf,0

	# TODO：graphics segment entry
	.word 0xffff,0x8000
	.byte 0x0b,0x92,0xcf,0

gdtDesc: 
	.word (gdtDesc - gdt - 1) 
	.long gdt 

