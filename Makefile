all:Image

.PHONY=clean run-qemu

Image: bootsect.bin demo.bin
	dd if=bootsect.bin of=Image bs=512 count=1
	dd if=demo.bin of=Image bs=512 count=4 seek=1

bootsect.bin: bootsect.s
	@as -n -o bootsect.o bootsect.s
	@ld -Ttext 0 -o bootsect bootsect.o
	@objcopy -O binary bootsect bootsect.bin

demo.bin: demo.s
	@as -n -o demo.o demo.s
	@ld -Ttext 0 -o demo demo.o
	@objcopy -O binary demo demo.bin
clean:
	rm -rf *.o bootsect bootsect.bin demo.bin demo Image

run-qemu: Image
	qemu-system-i386 -fda Image -boot a
