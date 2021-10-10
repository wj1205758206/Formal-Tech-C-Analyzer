## 部署环境 

Frama-C版本：Frama-C-Chlorine-20180502

Cygwin版本：  3.2.0-1	(64位Cygwin)

Ocaml版本：   4.06.0

Opam版本：   2.0.8  

虚拟机系统：   Windows7系统

## 编译部署步骤 

### 1. 在Windows7环境安装Cygwin

Cygwin下载地址：https://cygwin.com/

按照说明安装Cygwin，同时安装附加包：rsync、patch、diffutils、curl、make、unzip、git、m4、perl、mingw64-x86_64-gcc-core

### 2. 安装Opam包管理器

Opam下载地址：https://github.com/fdopen/opam-repository-mingw/releases/download/0.0.0.2/opam64.tar.xz

按照以下命令安装opam，并初始化opam，同时下载并安装ocaml-variants.4.06.0+mingw64c

```bash
tar -xf 'opam64.tar.xz'
bash opam64/install.sh  # the default prefix is /usr/local
opam init default "https://github.com/fdopen/opam-repository-mingw.git#opam2" -c "ocaml-variants.4.06.0+mingw64c" --disable-sandboxing
eval $(opam config env)
```

### 3. 安装Opam和Frama-C相关依赖

```bash
opam install depext depext-cygwinports
opam depext frama-c
opam install --deps-only frama-c
```

注意：需要添加`/usr/x86_64-w64-mingw32/sys-root/mingw/bin`到`$PATH `路径中(必须在`/usr/bin`之前，而不是之后！)

### 4. 编译Frama-C源代码

在Cygwin执行以下命令

`./configure --disable-gui --prefix="$(cygpath -a -m <installation path>)"`

编译

`make`

安装

`make install`

编译并且安装成功后，会在指定的安装目录生成`bin`、`lib`、`share`三个文件夹

### 5. 部署编译完成的Frama-C到Windows新环境

拷贝以下文件到新环境的C盘下

- `/cygwin64/x86_64-w64-mingw32/sys-root/mingw/`路径下的`bin`文件夹
- `/.opam/ocaml-variants.4.06.0+mingw64c/`路径下的`bin`文件夹
- `/cygwin64/`路径下的`bin`文件夹
- `/cygwin64/`路径下的`lib`文件夹

在新环境下配置以下环境变量

- `C:\Formal-Tech-C-Analyzer\cygwin64\x86_64-w64-mingw32\sys-root\mingw\bin`
- `C:\Formal-Tech-C-Analyzer\cygwin64\home\Administrator\.opam\ocaml-variants.4.06.0+mingw64c\bin`
- `C:\Formal-Tech-C-Analyzer\cygwin64\bin`
- `C:\Formal-Tech-C-Analyzer\cygwin64\lib`

至此Frama-C编译部署完成。

### 6. 示例展示

执行`frama-c -wp -print -rte C:/Formal-Tech-C-Analyzer/test/max_seq.c`命令

可检查C代码文件中常见的运行时错误，比如除零异常、内存访问越界、整型数据溢出等错误

![image-20211010092651940](https://user-images.githubusercontent.com/52147760/136679442-3358a235-16a5-4da1-9e71-4bfb041ecf03.png)

执行`frama-c -metrics C:/Formal-Tech-C-Analyzer/test/max_seq.c`命令

对C代码文件进行度量分析，包括统计全局变量的数量、if/while循环语句的数量、函数调用以及指针解引用等相关度量分析。

![image-20211010092631866](https://user-images.githubusercontent.com/52147760/136679461-bfe6827a-b7d5-473d-b2d0-7e2bb19c88d3.png)

除外之外还有其他对C代码进行静态分析验证的功能，不再一一展示。这款基于形式化规约验证工具，通过在C代码中插入规范的形式化语言，自动的进行对C代码的规约验证。
