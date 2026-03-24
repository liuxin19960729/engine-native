# JNI
## 设计概述
### 编译
```
Java 虚拟机是多线程的,编译的时候应该带上线程安全相关的宏定义
例如 GCC  -D_REENTRANT 或 -D_POSIX_C_SOURCE 
```
### 加载
```java
 System.loadLibrary(name)
```
### 解析本地方法
```java
Java_{fully-qualified class name}_{method name}


// 函数重载
Java_{fully-qualified class name}_{method name}__{mangled argument signature}




```
