#!/bin/sh

echo "Creating disk.img..."
sudo bximage -hd -mode="flat" -size=10 -q /home/disk.img

echo "Compiling..."
sudo nasm -I include/ -o /home/mbr.bin mbr.asm
sudo nasm -I include/ -o /home/loader.bin loader.asm

echo "Writing mbr and loader to disk..."
sudo dd if=/home/mbr.bin of=/home/disk.img bs=512 count=1 conv=notrunc
sudo dd if=/home/loader.bin of=/home/disk.img bs=512 count=1 seek=2 conv=notrunc

echo "Now start bochs and have fun!"
sudo bochs -f /root/Desktop/tiny-os-master/chapter3/bochsrc
