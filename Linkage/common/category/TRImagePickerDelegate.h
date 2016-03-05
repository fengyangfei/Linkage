//
//  TRImagePickerDelegate.h
//  YGTravel
//
//  Created by Mac mini on 16/1/5.
//  Copyright © 2016年 ygsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QBImagePickerController.h>
typedef void(^TRImagePickerPresentBlock)(UIImagePickerControllerSourceType sourceType);
typedef void(^TRImagePickerDidSelectBlock)(UIImage *image, NSString *fileName);
@interface TRImagePickerDelegate : NSObject<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate,QBImagePickerControllerDelegate>

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;

@property (nonatomic, copy) TRImagePickerPresentBlock presentBlock;
@property (nonatomic, copy) TRImagePickerDidSelectBlock selectBlock;

+(void)clearImageIndentifies;
+(void)removeImageIndentifyByKey:(NSString *)imageKey;
@end
