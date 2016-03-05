//
//  TRImagePickerDelegate.m
//  YGTravel
//
//  Created by Mac mini on 16/1/5.
//  Copyright © 2016年 ygsoft. All rights reserved.
//

#import "TRImagePickerDelegate.h"

@implementation TRImagePickerDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    switch (buttonIndex)
    {
        case 0:
        {
            sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        }
        case 1:
        {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        }
    }
    if (self.presentBlock) {
        self.presentBlock(sourceType);
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *fileName = [NSString stringWithFormat:@"%@.JPG", [[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""]];
    if (self.selectBlock) {
        self.selectBlock(info[UIImagePickerControllerOriginalImage], fileName);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - QBImagePickerControllerDelegate
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    ALAssetRepresentation *representation = [asset defaultRepresentation];
    NSString *fileName = [representation filename];
    CGImageRef ref = [representation fullScreenImage];
    UIImage *image = [[UIImage alloc]initWithCGImage:ref];
    if (self.selectBlock) {
        self.selectBlock(image, fileName);
    }
    [imagePickerController dismissViewControllerAnimated:YES completion:NULL];
}

static NSMutableArray *imageIndentifies;
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    if (!imageIndentifies) {
        imageIndentifies = [NSMutableArray array];
    }
    for (ALAsset *asset in assets) {
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        NSString *fileName = [representation filename];
        if (![imageIndentifies containsObject:fileName]) {
            CGImageRef ref = [representation fullScreenImage];
            UIImage *image = [[UIImage alloc]initWithCGImage:ref];
            if (self.selectBlock) {
                self.selectBlock(image, fileName);
            }
            [imageIndentifies addObject:fileName];
        }
    }
    [imagePickerController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [imagePickerController dismissViewControllerAnimated:YES completion:NULL];
}

+(void)clearImageIndentifies
{
    if(imageIndentifies){
        imageIndentifies = nil;
    }
}

+(void)removeImageIndentifyByKey:(NSString *)imageKey
{
    if (imageIndentifies && [imageIndentifies isKindOfClass:[NSMutableArray class]]) {
        [imageIndentifies removeObject:imageKey];
    }
}

@end
