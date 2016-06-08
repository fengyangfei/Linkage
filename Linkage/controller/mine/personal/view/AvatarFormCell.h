//
//  AvatarFormCell.h
//  Linkage
//
//  Created by lihaijian on 16/3/26.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <XLForm/XLForm.h>

extern NSString *const AvatarDescriporType;
extern NSString *const CompanyLogoDescriporType;

@interface AvatarFormCell : XLFormBaseCell
@property (nonatomic,readonly) UIImageView *imageView;
@end

@interface CompanyLogoFormCell : AvatarFormCell
@end