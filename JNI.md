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
### 本地方法参数
```java


package pkg;

class Cls {
    native double f(int i, String s);
    // ...
}



// ILjava_lang_String_2 参数
// obj 静态 Class 对象  or 非静态 对象
jdouble Java_pkg_Cls_f__ILjava_lang_String_2 (
     JNIEnv *env,        /* interface pointer */
     jobject obj,        /* "this" pointer */
     jint i,             /* argument #1 */
     jstring s)          /* argument #2 */
{
     /* Obtain a C-copy of the Java string */
     const char *str = (*env)->GetStringUTFChars(env, s, 0);

     /* process the string */
     ...

     /* Now we are done with str */
     (*env)->ReleaseStringUTFChars(env, s, str);

     return ...
}


```

### 引用Java对象
#### 全局和本地(Local)引用
```java

本地引用:native 方法执行完返回释放
全局应用:在被手动明确释放前都是有效的




JNI 函数返回所有JAVA对象都是本地引用
JNI 允许程序员从本地引用创建全局引用
native 函数可以返回给虚拟机本地引用和全局引用

JNI 允许程序员在本地方法中任意时刻手动删除本地引用。为了确保程序员能够手动释放本地引用，JNI 函数不允许创建额外的本地引用，除非是它们作为结果返回的引用


本地引用仅在创建它们的线程中有效。本地代码不得将本地引用从一个线程传递到另一个线程。

```
#### 实现Local引用
```
所有传递给本地方法的Java对象都会注册的注册表(防止这些对象垃圾回收)
本地方法执行完返回后注册表会删除这些Java独享(允许这些对象被垃圾回收)


```