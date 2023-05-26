#include "stdio.h"
#include "interrupt.h"
#include "global.h"
#include "string.h"
#include "syscall.h"
#include "print.h"

#include "stdint.h"
#include "syscall.h"
#include "file.h"
#include "assert.h"

#define va_start(ap, v) ap = (va_list)&v  // 把ap指向第一个固定参数v
#define va_arg(ap, t) *((t*)(ap += 4))	  // ap指向下一个参数并返回其值
#define va_end(ap) ap = NULL		  // 清除ap

static char cmd_line[100] = {0};

/* 将整型转换成字符(integer to ascii) */
static void itoa(uint32_t value, char** buf_ptr_addr, uint8_t base) {
   uint32_t m = value % base;	    // 求模,最先掉下来的是最低位   
   uint32_t i = value / base;	    // 取整
   if (i) {			    // 如果倍数不为0则递归调用。
      itoa(i, buf_ptr_addr, base);
   }
   if (m < 10) {      // 如果余数是0~9
      *((*buf_ptr_addr)++) = m + '0';	  // 将数字0~9转换为字符'0'~'9'
   } else {	      // 否则余数是A~F
      *((*buf_ptr_addr)++) = m - 10 + 'A'; // 将数字A~F转换为字符'A'~'F'
   }
}

/* 将参数ap按照格式format输出到字符串str,并返回替换后str长度 */
uint32_t vsprintf(char* str, const char* format, va_list ap) {
   char* buf_ptr = str;
   const char* index_ptr = format;
   char index_char = *index_ptr;
   int32_t arg_int;
   float arg_float;
   char* arg_str;
   while(index_char) {
      if (index_char != '%') {
	 *(buf_ptr++) = index_char;
	 index_char = *(++index_ptr);
	 continue;
      }
      index_char = *(++index_ptr);	 // 得到%后面的字符
      switch(index_char) {
         case 's':
            arg_str = va_arg(ap, char*);
            strcpy(buf_ptr, arg_str);
            buf_ptr += strlen(arg_str);
            index_char = *(++index_ptr);
            break;

         case 'c':
            *(buf_ptr++) = va_arg(ap, char);
            index_char = *(++index_ptr);
            break;

         case 'd':
            arg_int = va_arg(ap, int);
            /* 若是负数, 将其转为正数后,再正数前面输出个负号'-'. */
            if (arg_int < 0) {
               arg_int = 0 - arg_int;
               *buf_ptr++ = '-';
            }
            itoa(arg_int, &buf_ptr, 10); 
            index_char = *(++index_ptr);
            break;

         case 'x':
            arg_int = va_arg(ap, int);
            itoa(arg_int, &buf_ptr, 16); 
            index_char = *(++index_ptr); // 跳过格式字符并更新index_char
            break;
      }
   }
   return strlen(str);
}

/* 同printf不同的地方就是字符串不是写到终端,而是写到buf中 */
uint32_t sprintf(char* buf, const char* format, ...) {
   va_list args;
   uint32_t retval;
   va_start(args, format);
   retval = vsprintf(buf, format, args);
   va_end(args);
   return retval;
}

/* 格式化输出字符串format */
uint32_t printf(const char* format, ...) {
   va_list args;
   va_start(args, format);	       // 使args指向format
   char buf[1024] = {0};	       // 用于存储拼接后的字符串
   vsprintf(buf, format, args);
   va_end(args);
   return write(1, buf, strlen(buf)); 
}

// 用于编译器的函数

/* 从键盘缓冲区中最多读入count个字节到buf。*/
static void readline(char* buf, int32_t count) {
   assert(buf != NULL && count > 0);
   char* pos = buf;

   while (read(stdin_no, pos, 1) != -1 && (pos - buf) < count) { // 在不出错情况下,直到找到回车符才返回
      switch (*pos) {
       /* 找到回车或换行符后认为键入的命令结束,直接返回 */
	 case '\n':
	 case '\r':
	    *pos = 0;	   // 添加cmd_line的终止字符0
	    putchar('\n');
	    return;

	 case '\b':
	    if (cmd_line[0] != '\b') {		// 阻止删除非本次输入的信息
	       --pos;	   // 退回到缓冲区cmd_line中上一个字符
	       putchar('\b');
	    }
	    break;

	 /* 非控制键则输出字符 */
	 default:
	    putchar(*pos);
	    pos++;
      }
   }
   printf("readline: can`t find enter_key in the cmd_line, max num of char is 100\n");
}

void putint(int i){
   printf("%d\n", i);
}

void putch(int i){
   printf("%c\n", i);
}

int getint(void){
   int pos = 0;
   int num = 0;
   int negative = 0;
   readline(cmd_line, 100);
   if(cmd_line[0] == '-'){
      negative = 1;
      pos ++;
   }
   while(cmd_line[pos] != 0){
      int n = cmd_line[pos] - '0';
      num = num * 10 + n;
      pos ++;
   }
   if(negative == 1){
      num = - num;
   }
   return num;

}
int getch(void){
   readline(cmd_line, 100);
   return cmd_line[0];
}
