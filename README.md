**yowai-os**

- [1. 项目简介](#1-项目简介)
- [2. 代码说明](#2-代码说明)
- [3. 构建和使用说明](#3-构建和使用说明)
- [4. 参考文献](#4-参考文献)

# 1. 项目简介

这个项目本质上是为了加深对操作系统的底层理解而开展的。所使用的编程语言为ASM/C。
依据开发需求，最终决定参考`linux 0.0.1`以及`linux 0.1.1`的源码进行开发。
遗憾的是，由于另外两名队员尚需学习操作系统的相关知识，目前的代码编写仅由我一人完成。
因此，并未在初赛的时限内完成赛题要求，实属遗憾。

# 2. 代码说明

大体上，我以linux的内核做蓝本进行开发。(不过说实在的，因为开发进度实在太少，所以基本上也看不出来 :( 。)

因为linux是基于x86架构，内部的汇编还是在用AT&T的那种很难看懂的（个人喜欢Intel式），所以就算是1等1的抄也需要改很多东西啊。（话说这不就变成移植了吗

由于并未使用过Rust进行开发，以及本着从0开始的原则（ ，我们的操作系统会从上电之后开始执行他的 [第一行](https://github.com/pkuislm/yowai-os/blob/main/boot/sbl1.S#L12) 代码。

在`boot/sbl1.S`中，还会同时进行全局指针、内核栈顶的设置、停靠多余的hart（稍后会初始化这些核），随后会进入C语言环境，也就是位于`init/kernel.c`的 [start_kernel](https://github.com/pkuislm/yowai-os/blob/main/init/kernel.c#L20) 。在这里，会对uart进行初始化，使能printf。随后还会对内存进行 [初始化](https://github.com/pkuislm/yowai-os/blob/main/mm/memory.c#L57)，并提供了以页（4kb）进行管理的 [kmalloc](https://github.com/pkuislm/yowai-os/blob/main/mm/memory.c#L40) 和 [kfree](https://github.com/pkuislm/yowai-os/blob/main/mm/memory.c#L50)。而目前系统的开发进度就到此处了。


接下来若要继续进行开发，首先要完成的是中断部分，以及开启sv39。随后即可进行syscall的编写了。在实现完进程相关系统调用之后（比如`fork`,`exec`,`schedule`这种），应该就可以进入用户环境啦。

# 3. 构建和使用说明

因为没有完成赛题的任何要求，因此无法通过评测机测试吧。
手动操作的话，是有以下选项：

- `make`：编译构建
- `make run`：启动 qemu 并运行
- `make debug`：启动调试
- `make clean`：清理

# 4. 参考文献

这个项目的编写离不开前辈们的研究成果。十分感谢~

- 循序渐进，学习开发一个RISC-V上的操作系统 - 汪辰 - 2021春：<https://www.bilibili.com/video/BV1Q5411w7z5>
- 品读 Linux 0.11 核心代码: <https://github.com/sunym1993/flash-linux0.11-talk>
- RISC-V from scratch：<https://dingfen.github.io/2020/07/24/riscv-from-scratch-1.html>
- RISC-V的官方SpecSheet和InstructionManual
