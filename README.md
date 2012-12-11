# 功能
emacs开发go-lang的插件,提供编译,自动完成,快捷执行,格式化代码,调试的支持  

# 安装
### 安装gocode
安装gocode的方法可以参照https://github.com/nsf/gocode  
或者执行:  
`go get -u github.com/nsf/gocode`  

### 安装godev
直接`git clone https://github.com/iyf/godev.git`到load-path  
然后  
`(require 'godev)`  
即可  
# 使用方法  
## 调试界面快捷键  

`f5`没运行就会执行，断点按f5继续  
`S-f5`退出调试  
`f8`输出变量的值  
`C-f8`打印出指针对应的值  
`f9`当前f9行没有断点则加入断点,否则移除断点  
`f10`单步执行  
`C-f10` 一直执行光标位置  
`S-f10` 跳到光标位置，下一次会从光标处执行  
`f11`单步执行，f11会进入函数内部  
`C-f11`跳出当前函数  

## 编辑模式下快捷键

`f5`运行程序  
`C-f5`调试程序  

我的blog:http://iyf.cc