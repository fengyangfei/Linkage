//
//  TRPopView.h
//  YGTravel
//
//  Created by Mac mini on 16/2/1.
//  Copyright © 2016年 ygsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRPopView : UIControl
- (instancetype)initWithItems:(NSArray *)array;
-(void)controlPressed;
- (void)presentMenu;
- (void)dismissMenu;
@end


@interface TRPopItemView : UIControl
- (instancetype)initWithTitle:(NSString *)title andImageName:(NSString *)imageName;
- (instancetype)initWithTitle:(NSString *)title andImage:(UIImage *)image;
@end