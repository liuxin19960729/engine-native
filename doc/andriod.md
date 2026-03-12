# Andriod
## Activity
### Activity LifeCycle
```java

onCreate()->onDestory()

onStart()->onStop()
//在此期间，用户可以在屏幕上看到活动，尽管活动可能不在前景并与用户互动
//相当于Cocos onEnable()->onDisable
//可以注册和取消影响界面的事件相关

onResume()-> onPause()
// 在此期间，活动为 可见、主动并与用户互动。

onCreate()
// 刚创建的时候被触发

onRestart()	
// Activity停止 在活动重新Start 之前调用  紧接着触发onStart()

onStart()
// Activity对用户可见调用

onResume()
// Activity对用户可见 并与用户交互调用

onStop()
// Activity对用户不可见
// 原因:
// 1.新Acitivity在上方启动
// 2.当前活动被销毁

onDestroy()
// Activity 销毁前被调用
// 原因
// 1.Activity.finish() 调用
// 2.系统内存不足崩溃 销毁Activity

// Activity.isFinishing() 用来区分是崩溃或则调用Activity.finish()



onPause()
// 写入持久化数据到磁盘
onSaveInstanceState()


// 在销毁前被调用 可以存储状态 在 下一个词触发 onCreate or onRestoreInstanceState 用来恢复状态

onPause() 和  onSaveInstanceState() 区别
//1.销毁 和 另一个Activity盖住了当前Activity Activity 会触发 onPause()调用
//1.onSaveInstanceState 只会在销毁的时候调用
```
###  Configuration Changes
```java
// 没有特殊的说明 改变屏幕方向 language 或者输入设置等 都会导致Acitivty被销毁
// 如果触发销毁 并且Activity在前景 在触发onDesotry的时候会创建一个新Activity 可以在 onSaveInstanceState 保存状态 并且 通过这个状态用于恢复


//android:configChanges 配置 可以改变的属性
//配置的属性 改变不重启 触发 onConfigurationChanged() 
//note:如果有未配置的属性修改 也会触发重启

// cocos 配置
//android:configChanges="orientation|keyboardHidden|screenSize|screenLayout|uiMode"
// 

```
### Starting Activities and Getting Results
```java
// Activity 启动
startActivity(Intent)
//启动新增的Activity 并将放入最上面


// Activity 启动 并且等待返回
// 运用创建  启动通讯录Activity 关闭 返回选中联系人的数据
startActivityForResult(Intent,requestCode)
// requestCode >=0  Activity 结束 onActivityResult 触发 code 返回
// requestCode <0   Activity 结束 不触发返回

//打开活动退出setResult()返回父数据

```
### Saving Persistent State
```java
// 一般有两种方式存储数据持久化
// 1.share doucument(存储在SQLite中)
// 2.user preferences




```     