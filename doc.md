## native
```cpp
se:Object 创建对象的几种方式
se::Object::createPlainObject   ----> var a = {};
se::Object::createArrayObject   ----> var a = [];
se::Object::createTypedArrayObject   ----> var a = new Uint8Array(buffer);
se::Object::createArrayBufferObject  ----> var a = new ArrayBuffer(buffer);

note: 抽象层是完全独立的一个模块，并不依赖与 cocos2d-x 的 autorelease 机制


例如:手动创建和手动释放对象
se::Object* obj = se::Object::createPlainObject();
...
...
obj->decRef(); // 释放引用，避免内存泄露

推荐的管理手动创建对象的辅助类
se::HandleObject 
{
    se::HandleObject obj(se::Object::createPlainObject());
    obj->setProperty(...);
    otherObject->setProperty("foo", se::Value(obj));
}


等价于：
{
    se::Object* obj = se::Object::createPlainObject();
    obj->root(); // 在手动创建完对象后立马 root，防止对象被 GC

    obj->setProperty(...);
    otherObject->setProperty("foo", se::Value(obj));
    
    obj->unroot(); // 当对象被使用完后，调用 unroot
    obj->decRef(); // 引用计数减一，避免内存泄露
}


note:
    JS 控制CPP 的模式中 对象的释放会自动处理所以不要使用 se:HandleObject 创建一个native 与JS 绑定的对象

```
## se::Class
```cpp
se::Class  用于暴露 CPP 类到 JS 中，它会在 JS 中创建一个对应名称的 constructor function。

static se::Class* create(className, obj, parentProto, ctor)
se::Class* cls = se::Class::create("WebSocket", obj, nullptr, _SE(WebSocket_constructor))
成功后JS 层可以 let ws= new WebSocket()


Class 中的成员函数
bool defineFunction(name, func)
cls->defineFunction("send", _SE(WebSocket_send));

定义 Class 属性读写器
bool defineProperty(name, getter, setter)
cls->defineProperty("readyState", _SE(WebSocket_getReadyState), nullptr);


定义 Class 的静态成员函数
bool defineStaticFunction(name, func)
可通过 SomeClass.foo() 这种非 new 的方式访问，与类实例对象无关


定义 Class 的静态属性读写器，可通过 SomeClass.propertyA 直接读写，与类实例对象无关
bool defineStaticProperty(name, getter, setter)

定义 JS 对象被 GC 后的 CPP 回调
bool defineFinalizeFunction(func)
cls->defineFinalizeFunction(_SE(WebSocket_finalize));


注册此类到 JS 虚拟机中
bool install()

获取注册到 JS 中的类（其实是 JS 的 constructor）的 prototype 对象，类似 function Foo(){} 的 Foo.prototype
Object* getProto()

获取当前 Class 的名称
const char* getName() const：

note:
    Class 类型创建后，不需要手动释放内存，它会被封装层自动处理。

```

## se::AutoHandleScope
```cpp
se::AutoHandleScope 对象类型完全是为了解决V8兼容问题而引入的概念


se::AutoHandleScope 中间层为了兼容V8
V8 中  CPP 函数中需要触发 JS 相关操作(JS 函数调用,属性访问等V8::Local<> 操作), V8 强制要求在调用这些操作前必须存在一个 v8::HandleScope 作用域，否则会引发程序崩溃。


因此抽象层中引入了 se::AutoHandleScope 的概念，其只在 V8 上有实现，其他 JS 引擎目前都只是空实现

note:
    在任何代码执行中，需要调用 JS 的逻辑前，声明一个 se::AutoHandleScope


例如:

class SomeClass {
	void update(float dt) {
		se::ScriptEngine::getInstance()->clearException();
        // 做任何JS 调用和使用JS钱需要声明一个 se::AutoHandleScope hs;
		se::AutoHandleScope hs;
		
		se::Object* obj = ...;
		obj->setProperty(...);
		...
		...
		obj->call(...);
	}
};


```
## Se::State
```cpp
Se::State
  可以获取se::Object 指针 参数列表 返回值引用

// se::Object 对象指针
thisObject() 获取
// 获取 native 对象指针
SomeClass* cobj = (SomeClass*)s.nativeThisObject(); 
	// 获取参数列表
const se::ValueArray& args = s.args();
	// 设置返回值
s.rval().setInt32(100);

```