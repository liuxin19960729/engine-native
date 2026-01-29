# $(call my-dir)  构建系统 提供my-dir 宏函数返回当前目录
# Android.mk 文件必须先定义 LOCAL_PATH 变量
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

#构建的模块的名字 动态库名称 lib模块名.so(默认)
LOCAL_MODULE := cocos2dxandroid_static
# 将模块构建成libcocos2dandroid.so
LOCAL_MODULE_FILENAME := libcocos2dandroid

# 列举源文件
LOCAL_SRC_FILES := \
CCDevice-android.cpp \
CCFileUtils-android.cpp \
CCApplication-android.cpp \
CCCanvasRenderingContext2D-android.cpp \
jni/JniImp.cpp \
jni/JniHelper.cpp \

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)

LOCAL_C_INCLUDES := $(LOCAL_PATH) \
                    $(LOCAL_PATH)/.. \
                    $(LOCAL_PATH)/../.. \
                    $(LOCAL_PATH)/../../..

LOCAL_EXPORT_LDLIBS := -lGLESv2 \
                       -lEGL \
                       -llog \
                       -landroid

LOCAL_STATIC_LIBRARIES := v8_static

include $(BUILD_STATIC_LIBRARY)
