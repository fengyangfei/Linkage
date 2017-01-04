//
//  VCHotChildViewController.h
//  Linkage
//
//  Created by lihaijian on 2017/1/3.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "ModelBaseViewController.h"
#import "ZJScrollPageViewDelegate.h"

@interface VCHotChildViewController : ModelBaseViewController<ZJScrollPageViewChildVcDelegate>
@property (strong, nonatomic) NSArray *data;
@end
