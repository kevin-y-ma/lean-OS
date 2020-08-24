# BIOS服务程序使用说明 http://stanislavs.org
.code16

.equ BOOTSEG, 0x07c0
.equ DEMOSEG, 0x1000
.equ LEN, 23

.global _start

.text 
	ljmp $BOOTSEG, $_start 

_start:
	mov $BOOTSEG, %ax
	mov %ax, %es

	#Get Cursor Position
	mov $0x03, %ah
	xor %bh, %bh 
	int $0x10

	#Show stirng
	mov $0x1301, %ax
	mov $0x000b, %bx	#设置显示模式
	mov $LEN, %cx		#写入字符串长度
	mov $_msg, %bp		#es:bp 字符串指针
	int $0x10

	#read disk

_load_demo:
	mov $DEMOSEG, %ax
	mov %ax, %es

	mov $0x02, %ah		#表示读取硬盘扇区
	mov $0x04, %al		#要读取的扇区数量
	mov $0002, %cx 		#ch:柱面号 cl:扇区号
	xor %dx, %dx		#dh:此头号 dl驱动器号
	mov $0x0200, %bx	#es:bx 缓冲区位置
	int $0x13
	jnc _load_demo_ok
	jmp _load_demo 

	

_load_demo_ok:	
	ljmp $0x1020, $0

_msg:
	.byte 13, 10
	.ascii "Hello Bootloader!"
	.byte 13, 10, 13, 10 
.=510
.word 0xaa55
