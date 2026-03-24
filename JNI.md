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
### 访问Java对象
#### 访问原始数组
```java
JNI 提供了一组Java数组和本地缓冲区之间复制的函数(这些函数不同虚拟机有不同的实现)
    // 实现方式之一
    GC支持 pinning  native 方法要求的布局和目前虚拟机数组布局一直 则不需要复制数组

    or 数组被移动到不可移动的内存块(例如: C heap) 返回指向副本的指针、

JNI 还提供了不在访问数组的函数(当前不在使用数组的时候调用)

```
#### 访问字段和方法
```java


jmethodID methodID = env->GetMethodID(classID, methodName, paramCode);


// 本地方法可以反复使用 methodID 无需重复花费methodID 的代价
jdouble result = env->CallDoubleMethod(obj, mid, 10, str);

note:字段和id并不能阻止虚拟机类被卸载掉


```
#### 报告程序错误
```
JNI 不检查程序的错误
原因：
    1.检查错误条件会减低正确的本地方法性能
    2.在很多情况下，运行是类型信息不能够检查

```
#### Java Exceptions
```java

调用 Java 方法的 JNI 函数返回 Java 方法的结果。程序员必须调用 ExceptionOccurred（） 来检查在 Java 方法执行过程中可能出现的异常。


 JNI 数组访问函数不会返回错误代码，但可能会抛出 ArrayIndexOutOfBoundsException 或 ArrayStoreException。

```
#### 异步 Exceptions
```java


ExceptionOccurred（） 来显式检查同步和异步异常


//native 函数 清楚异常执行自己的异常代码处理
env->ExceptionClear();


note:
    异常出现后 native 必须 ExceptionClea() 清除异常才能执行其他的JNI调用


```
## JNI 类型和数据结构
### 原始类型
```java
基础类型  -> j+基础类型

例如:
boolean->jboolean
```
### 引用类型
```
jobject
jstring

// 数组
jobjectArray
j+基础类型+Array


//java.lang.Throwable objects
jthrowable

```
### Filed 和Method ID
```java

```