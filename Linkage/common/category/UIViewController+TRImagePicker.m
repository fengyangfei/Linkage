//
//  TRImagePicker.m
//  YGTravel
//
//  Created by Mac mini on 16/1/5.
//  Copyright © 2016年 ygsoft. All rights reserved.
//

#import "UIViewController+TRImagePicker.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <objc/runtime.h>

@implementation UIViewController(TRImagePicker)

//选择单个图片
- (void)addSignalPhoto:(void (^)(UIImage *image, NSString *fileName))block
{
    [self tr_imagePickerDelegate].selectBlock = block;
    if ([UIAlertController class])
    {
        [self presentViewController:[self tr_alertControlller] animated:YES completion:nil];
    }
    else
    {
        [[[UIActionSheet alloc] initWithTitle:nil delegate:[self tr_imagePickerDelegate] cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Take Photo", nil), NSLocalizedString(@"Photo Library", nil), nil] showInView:self.view];
    }
}

//选择多个图片
- (void)addMultiplePhoto:(void (^)(UIImage *image, NSString *fileName))block
{
    [self tr_qbImagePickerController].allowsMultipleSelection = YES;
    [self tr_qbImagePickerController].showsNumberOfSelectedAssets = YES;
    [self addSignalPhoto:block];
}

#pragma mark - image picker
static char kTRImagePickerKey;
- (UIImagePickerController *)tr_imagePickerController
{
    UIImagePickerController *imagePickerController = objc_getAssociatedObject(self, &kTRImagePickerKey);
    if (!imagePickerController) {
        imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        imagePickerController.delegate = [self tr_imagePickerDelegate];
        imagePickerController.allowsEditing = NO;
        objc_setAssociatedObject(self, &kTRImagePickerKey, imagePickerController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return imagePickerController;
}

static char kTRQBImagePickerKey;
-(QBImagePickerController *)tr_qbImagePickerController
{
    QBImagePickerController *qbImagePickerController = objc_getAssociatedObject(self, &kTRQBImagePickerKey);
    if (!qbImagePickerController) {
        qbImagePickerController = [QBImagePickerController new];
        qbImagePickerController.delegate = [self tr_imagePickerDelegate];
        qbImagePickerController.allowsMultipleSelection = NO;
        qbImagePickerController.showsNumberOfSelectedAssets = NO;
        objc_setAssociatedObject(self, &kTRQBImagePickerKey, qbImagePickerController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return qbImagePickerController;
}

static char kTRQBImagePickerDelegateKey;
-(TRImagePickerDelegate *)tr_imagePickerDelegate
{
    TRImagePickerDelegate *imagePickerDelegate = objc_getAssociatedObject(self, &kTRQBImagePickerDelegateKey);
    if (!imagePickerDelegate) {
        WeakSelf
        imagePickerDelegate = [TRImagePickerDelegate new];
        imagePickerDelegate.presentBlock = ^(UIImagePickerControllerSourceType sourceType){
            [[weakSelf tr_alertControlller] dismissViewControllerAnimated:NO completion:nil];
            
            if ([UIImagePickerController isSourceTypeAvailable:sourceType] && sourceType == UIImagePickerControllerSourceTypeCamera)
            {
                [weakSelf tr_imagePickerController].sourceType = sourceType;
                [weakSelf presentViewController:[weakSelf tr_imagePickerController] animated:YES completion:nil];
            }else{
                [weakSelf presentViewController:[weakSelf tr_qbImagePickerController] animated:YES completion:nil];
            }
        };
        objc_setAssociatedObject(self, &kTRQBImagePickerDelegateKey, imagePickerDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return imagePickerDelegate;
}

static char kTRAlertControllerKey;
-(UIAlertController *)tr_alertControlller
{
    WeakSelf
    UIAlertController *trAlertController = objc_getAssociatedObject(self, &kTRAlertControllerKey);
    if (!trAlertController) {
        trAlertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [trAlertController addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[weakSelf tr_imagePickerDelegate] actionSheet:nil didDismissWithButtonIndex:0];
        }]];
        
        [trAlertController addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[weakSelf tr_imagePickerDelegate] actionSheet:nil didDismissWithButtonIndex:1];
        }]];
        
        [trAlertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            
        }]];
        objc_setAssociatedObject(self, &kTRAlertControllerKey, trAlertController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return trAlertController;
}

@end