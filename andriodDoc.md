# Andriod 启动流程
```java
AppActivity.class extends Cocos2dxActivity.class
AppActivity.class
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }
Cocos2dxActivity.class
    protected void onCreate(final Bundle savedInstanceState){
         this.init();
    }
    public void init() {
        Cocos2dxRenderer renderer = this.addSurfaceView();
    }
    private Cocos2dxRenderer addSurfaceView(){
         Cocos2dxRenderer renderer = new Cocos2dxRenderer();
    }


Cocos2dxRenderer.java

/**实现的是OpenGL Renderer 接口*/
@Override
public void onSurfaceCreated(final GL10 GL10, final EGLConfig EGLConfig) {
     Cocos2dxRenderer.nativeInit(this.mScreenWidth, this.mScreenHeight, mDefaultResourcePath);
 }


private static native void nativeInit(final int width, final int height, final String resourcePath);


JniImp.cpp
/** JNI nativeInit  CPP 实现的 nativeInit */
JNIEXPORT void JNICALL JNI_RENDER(nativeInit)(JNIEnv*  env, jobject thiz, jint w, jint h, jstring jDefaultResourcePath){
     
     g_app = cocos_android_app_init(env, w, h);

}
```
## note
```java
Cocos 并未承诺在在多个线程的安全性

Cocos 引擎的渲染和 JS 的逻辑是在 GL 线程中进行的
        Cocos2dxHelper.runOnGLThread(()->{
                Cocos2dxJavascriptJavaBridge.evalString("cc.log(\"Javascript Java bridge!\")");
        });

而 Android 本身的 UI 更新是在 App 的 UI 线程进行的
    /*创建一个UI线程的任务*/
    Cocos2dxHelper.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    mGameEngineInitializedListener.onGameEngineInitialized();
                }
            });


c++ 层 调用js 代码也必须要在JS引擎所在的线程被调用
Application::getInstance()->getScheduler()->performFunctionInCocosThread([=](){
    se::ScriptEngine::getInstance()->evalString(script.c_str());
});
```