####  此脚本应该在command目录下执行

if [[ ! -d "../lib" || ! -d "../build" ]];then
   echo "dependent dir don\`t exist!"
   cwd=$(pwd)
   cwd=${cwd##*/}
   cwd=${cwd%/}
   if [[ $cwd != "command" ]];then
      echo -e "you\`d better in command dir\n"
   fi 
   exit
fi

BIN="prog"
CFLAGS="-Wall -c -fno-builtin -W -Wstrict-prototypes \
      -Wmissing-prototypes -Wsystem-headers"
CFLAGS_S="-Wall -S -fno-builtin -W -Wstrict-prototypes \
      -Wmissing-prototypes -Wsystem-headers -O"
LIBS="-I ../lib/ -I ../lib/kernel/ -I ../lib/user/ -I \
      ../kernel/ -I ../device/ -I ../thread/ -I \
      ../userprog/ -I ../fs/ -I ../shell/"
OBJS="../build/string.o ../build/syscall.o \
      ../build/stdio.o ../build/assert.o start.o"

DD_IN=$BIN
DD_OUT="../hd50M.img" 

nasm -f elf ./start.S -o ./start.o
ar rcs simple_crt.a $OBJS start.o


# i686-elf-gcc $CFLAGS $LIBS -o $BIN".o" $BIN".c"
# i686-elf-gcc $CFLAGS_S $LIBS -o $BIN".S" $BIN".c"
i686-elf-gcc $CFLAGS $LIBS -o $BIN".o" $BIN".S"


ld -melf_i386 $BIN".o" simple_crt.a -o $BIN
SEC_CNT=$(ls -l $BIN|awk '{printf("%d", ($5+511)/512)}')

if [[ -f $BIN ]];then
   dd if=./$DD_IN of=$DD_OUT bs=512 \
   count=$SEC_CNT seek=300 conv=notrunc
fi
