//
//  UIViewController+Extensions.m
//  TechnologyTemplate
//
//  Copyright (c) 2015年 leitaiyuan. All rights reserved.
//

#import "UIViewController+Extensions.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import <objc/runtime.h>

@implementation UIViewController (Extensions)

- (void)setupBackgroundImage:(UIImage *)backgroundImage {
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundImageView.image = backgroundImage;
    [self.view insertSubview:backgroundImageView atIndex:0];
}

- (void)pushNewViewController:(UIViewController *)newViewController {
    if (self.navigationController) {
        [self.navigationController pushViewController:newViewController animated:YES];
    }else{
        [self presentViewController:newViewController animated:YES completion:nil];
    }
}

- (void)addBackSwipeGestureRecognizer
{
    //加右滑动的手势
    UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(responesSwipeGesture:)];
    swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGestureRight];
}

#pragma mark -添加单击事件 UIGestureRecognizer
//响应滑动事件
- (void)responesSwipeGesture:(UISwipeGestureRecognizer *)gesture
{
    [self backViewController];
}

- (void)backViewController{
    [self backViewControllerAnimated:YES];
}
- (void)backViewControllerAnimated:(BOOL)animated {
    if (self.navigationController) {
        NSArray *viewControllers = [self.navigationController viewControllers];
        // 根据viewControllers的个数来判断此控制器是被present的还是被push的
        if (1 <= viewControllers.count && 0 < [viewControllers indexOfObject:self]) {
            [self.navigationController popViewControllerAnimated:animated];
            return;
        }
    }
    [self dismissViewControllerAnimated:animated completion:nil];
}

#pragma mark -添加单击事件 UIGestureRecognizer
- (void)addTapGestureRecognizer {

}

- (void)removeGestureRecognizers {
    if ([self isViewLoaded]) {
        UIView *view = self.view;
        for (UIGestureRecognizer *gestureRecognizer in view.gestureRecognizers) {
            [view removeGestureRecognizer:gestureRecognizer];
        }
    }
}

-(void)setNavigationItemTitle:(NSString *)title {
    self.title = title;
}

#pragma mark - Loading
- (void)showLoading {
    [self showLoadingWithText:nil];
}

- (void)showLoadingWithText:(NSString *)text {
    [self showLoadingWithText:text onView:self.view];
}

- (void)showLoadingWithText:(NSString *)text onView:(UIView *)view {
    
}

- (void)showSuccess {
    
}
- (void)showError {
    
}

- (void)hideLoading {
    
}

#pragma mark - UIKeyboardNotification

- (void)setupGestureControlKeyboard:(BOOL)isGestured; {
    // 键盘通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWillShowKeyboardNotification:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWillHideKeyboardNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    WeakSelf
    if (isGestured) {
        [self.view bk_whenTapped:^{
            [weakSelf dismissKeyboard];
        }];
    }
}

- (void)disSetupGestureControlKeyboard:(BOOL)isGestured; {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    WeakSelf
    if (isGestured) {
        [self.view bk_whenTapped:^{
            [weakSelf dismissKeyboard];
        }];
    }
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:touch.view];
    if (CGRectContainsPoint(gestureRecognizer.view.frame, point)) {
        if ([touch.view.superview isKindOfClass:[UITableViewCell class]]) {
            return NO;
        }
        if ([touch.view.superview isKindOfClass:[UICollectionViewCell class]]) {
            return NO;
        }
        return YES;
    }
    return NO;
}

#pragma mark - Keyboard notifications

//开始显示键盘
- (void)handleWillShowKeyboardNotification:(NSNotification *)notification {//1
    [self handleKeyboardNotification:notification hidden:NO];
}

- (void)handleDidShowKeyboardNotification:(NSNotification *)notification {//2
    [self handleKeyboardNotification:notification hidden:NO];
}

//开始隐藏键盘
- (void)handleWillHideKeyboardNotification:(NSNotification *)notification {//3
    [self handleKeyboardNotification:notification hidden:YES];
}

- (void)handleDidHideKeyboardNotification:(NSNotification *)notification {//4
    [self handleKeyboardNotification:notification hidden:YES];
}

- (void)handleKeyboardNotification:(NSNotification *)notification hidden:(BOOL)hidden{
    NSArray *viewControllers = [self.navigationController viewControllers];
    if (viewControllers && viewControllers.count) {
        id vc = [viewControllers lastObject];
        if (vc != self) {
            return;
        }
    }
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameEnd = value.CGRectValue;
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        NSLog(@"%@键盘。", hidden?@"隐藏":@"显示");
        [self handleKeyboard:keyboardFrameEnd hidden:hidden];
    }];
}

- (void)handleKeyboard:(CGRect)keyboardFrame hidden:(BOOL)hidden
{
}

- (void)dismissKeyboard
{

}
@end


//定义导航返回按钮默认文字
@implementation UINavigationItem (BackBarButtonItem)
static const char kBackBarButtonItemTitleKey;

- (void)setupBackBarButtonItem {
    UIBarButtonItem *backBarButtonItem = self.backBarButtonItem;
    if (backBarButtonItem == nil) {
        //将导航左边按钮文字改为“返回”
        backBarButtonItem = [[UIBarButtonItem alloc] init];
        NSString *title = self.backBarButtonItemTitle;
        if (title == nil) {
            title = @"返回";
        }else{
            if (title.length > 4) {
                title = [title substringWithRange:NSMakeRange(0, 4)];
            }
        }
        backBarButtonItem.title = title;
        self.backBarButtonItem = backBarButtonItem;
        self.hidesBackButton = NO;
    }
}

- (NSString *)backBarButtonItemTitle {
    return objc_getAssociatedObject(self, &kBackBarButtonItemTitleKey);
}

- (void)setBackBarButtonItemTitle:(NSString *)backBarButtonItemTitle {
    objc_setAssociatedObject(self, &kBackBarButtonItemTitleKey, backBarButtonItemTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end