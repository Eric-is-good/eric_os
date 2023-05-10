# eric_os


### 从 0 写一个操作系统

### 基于书籍      ***操作系统真象还原*** 

<img src="https://github.com/Eric-is-good/eric_os/raw/main/imgs/1.png" style="zoom: 50%;" />



## 完成效果

代码在文件夹 eric_os 里面。





## 章节对应



### 环境搭建   ->  直接 docker  pull  ericju/ubuntu-desktop-bochs:1.0

基于 ericju/ubuntu-desktop 镜像  ， 在 [**这里**](https://github.com/Eric-is-good/docker-ubuntu-desktop)， 效果如下

![](https://github.com/Eric-is-good/docker-ubuntu-desktop/blob/main/pics/1.png)



关于 **bximage** 的使用 (一定要跟着自己的系统来)

```shell
输入 :  bximage --help



Usage: bximage [options] [filename1] [filename2]

Supported options:
  -func=...     operation to perform (create, convert, resize, commit, info)
  -fd=...       create: floppy image with size code
  -hd=...       create/resize: hard disk image with size in megabytes (M)
                or gigabytes (G)
  -imgmode=...  create/convert: hard disk image mode
  -sectsize=... create: hard disk sector size
  -b            convert/resize: create a backup of the source image
                commit: create backups of the base image and redolog file
  -q            quiet mode (don't prompt for user input)
  --help        display this help and exit

Other arguments:
  filename1     create:  new image file
                convert/resize: source image file
                commit:  base image file
  filename2     convert/resize: destination image file
                commit:  redolog (journal) file

```



### 第三章    实现 MBR 和 简易 loader   

![](https://github.com/Eric-is-good/eric_os/raw/main/imgs/3.png)





### 第四章  实现了 GDT 表，进入保护模式后，使用段选择子来初始化寄存器

![](https://github.com/Eric-is-good/eric_os/raw/main/imgs/4.png)







### 第五章  实现了分页和内核加载，但因为暂未写打印函数，所以只有分页成功的截图

![](https://github.com/Eric-is-good/eric_os/raw/main/imgs/5.png)



### 第六章  
