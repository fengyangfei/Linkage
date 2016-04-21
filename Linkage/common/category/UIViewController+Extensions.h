//
//  UIViewController+Extensions.h
//  TechnologyTemplate
//
//  Copyright (c) 2015年 leitaiyuan. All rights reserved.
//

//定义导航返回按钮默认文字
#define ksetNavigationItemBackBarButtonItem [self.navigationItem setupBackBarButtonItem];

/*
 * 控件触发点击、选择等事件后执行的Block，如果有返回值，则页面跳转到返回的viewController
 * @param viewController 传人的控制器，一般为控件所在的控制器
 * @param sender 事件源
 * @return 返回要跳转的控制器，如果返回值为nil，则不做任何处理，否则页面跳转到返回的viewController，也可以在Block内部实现跳转处理
 */
@interface UIViewController (Extensions) <UIGestureRecognizerDelegate>

/// 返回上一页(子类实现)
- (void)backViewController;
- (void)backViewControllerAnimated:(BOOL)animated;

/// 返回滑动手势
- (void)addBackSwipeGestureRecognizer;

//添加单击手势 UIGestureRecognizer
- (void) addTapGestureRecognizer;

//移除所有手势
- (void) removeGestureRecognizers;

/**
 *  统一设置背景图片
 *
 *  @param backgroundImage 目标背景图片
 */
- (void)setupBackgroundImage:(UIImage *)backgroundImage;

/**
 *  push新的控制器到导航控制器
 *
 *  @param newViewController 目标新的控制器对象
 */
- (void)pushNewViewController:(UIViewController *)newViewController;

/**
 *  显示加载的loading，没有文字的
 */
- (void)showLoading;
/**
 *  显示带有某个文本加载的loading
 *
 *  @param text 目标文本
 */
- (void)showLoadingWithText:(NSString *)text;

- (void)showLoadingWithText:(NSString *)text onView:(UIView *)view;

/**
 *  显示成功的HUD
 */
- (void)showSuccess;
/**
 *  显示错误的HUD
 */
- (void)showError;

/**
 *  隐藏在该View上的所有HUD，不管有哪些，都会全部被隐藏
 */
- (void)hideLoading;

//设置手势及键盘通知
- (void)setupGestureControlKeyboard:(BOOL)isGestured;

//异常手势及键盘通知
- (void)disSetupGestureControlKeyboard:(BOOL)isGestured;;

/*
 *  处理键盘显示或隐藏
 *
 *  @param keyboardFrame 键盘frame
 *  @param hidden 隐藏键盘，YES：隐藏，NO：显示
 */
- (void)handleKeyboard:(CGRect) keyboardFrame hidden:(BOOL)hidden;

- (void)dismissKeyboard;

@end

//设置导航栏背景透明
/*@interface UIViewController (UINavigationBarAlpha) <UINavigationControllerDelegate>
@property (nonatomic, assign) CGFloat alpha;
@end*/

//定义导航返回按钮默认文字
@interface UINavigationItem (BackBarButtonItem)

- (void)setupBackBarButtonItem;

@end