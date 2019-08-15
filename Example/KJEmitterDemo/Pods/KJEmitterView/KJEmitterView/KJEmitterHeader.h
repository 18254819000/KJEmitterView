//
//  KJEmitterHeader.h
//  KJEmitterDemo
//
//  Created by 杨科军 on 2018/11/26.
//  Copyright © 2018 杨科军. All rights reserved.
//
/*
 Github地址：https://github.com/yangKJ
 简书地址：https://www.jianshu.com/u/c84c00476ab6
 博客地址：https://blog.csdn.net/qq_34534179
 
 ####版本更新日志：
 
 #### Add 4.1.0
 1、整理新增控件类 Control
 2、KJSelectControl   自定义一款动画选中控件
 3、KJSwitchControl   自定义一款可爱的动画Switch控件
 4、KJMarqueeLabel    自定义一款跑马灯Label
 5、UINavigationController+FDFullscreenPopGesture 侧滑返回扩展

 ##### Add 4.0.0
 1、加入弱引用宏 kWeakObject 和 kStrongObject
 2、新增扩展 UIButton+KJBlock   改变UIButton的响应区域 - 点击事件ButtonBlock
 3、新增扩展 UILabel+KJAttributedString   富文本
 4、UIView+KJFrame   新增一些轻量级布局链式属性
 5、UIView+KJRectCorner  新增方法  虚线边框  kj_DashedLineColor
 
 */

#ifndef KJEmitterHeader_h
#define KJEmitterHeader_h

// 输出日志 (格式: [时间] [哪个方法] [哪行] [输出内容])
#ifdef DEBUG
#define NSLog(format, ...)printf("\n[%s] %s [第%d行] 😎😎 %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)
#endif

/******************* Control ******************************/
#import "KJAlertView.h"      // 提示选择框
#import "KJSelectControl.h"  // 自定义一款动画选中控件
#import "KJSwitchControl.h" // 自定义一款可爱的动画Switch控件
#import "KJMarqueeLabel.h"  // 一款跑马灯Label

/******************* UIKit ******************************/
#import "KJEmitterView.h"    // 粒子效果
#import "KJErrorView.h"      // 错误效果

/******************* Category ******************************/
#import "UIButton+KJButtonContentLayout.h"  // 图文混排
#import "UIButton+KJBlock.h" // 改变UIButton的响应区域 - 点击事件ButtonBlock

#import "UILabel+KJAttributedString.h" // 富文本

#import "UIView+KJXib.h"   // Xib
#import "UIView+KJFrame.h" // Frame - 轻量级布局
#import "UIView+KJRectCorner.h" // 切圆角 - 渐变

#import "UINavigationBar+KJExtension.h" // 设置NavigationBar背景
#import "UIBarButtonItem+KJExtension.h" // 设置BarButtonItem
#import "UINavigationController+FDFullscreenPopGesture.h" // 侧滑返回

#import "UITextView+KJPlaceHolder.h"  // 输入框扩展
#import "UITextView+KJLimitCounter.h" // 限制字数

#import "UIImage+KJFloodFill.h" /// 图片泛洪算法
#import "UIImage+KJFrame.h"     /// 处理图片尺寸相关
#import "UIImage+KJFilter.h"    /// 处理图片滤镜，渲染相关

/******************* Foundation ******************************/
#import "NSArray+KJLog.h"
#import "NSDictionary+KJLog.h"  /// Xcode控制台打印中文问题，调试模式打印

#endif /* KJEmitterHeader_h */
