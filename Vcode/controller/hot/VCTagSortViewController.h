//
//  VCTagSortViewController.h
//  Linkage
//
//  Created by Mac mini on 2017/1/14.
//  Copyright © 2017年 LA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VCTagSortViewControllerDelegate <NSObject>
@optional
-(void)refreshTag;
@end

@interface VCTagSortViewController : UIViewController
@property(weak, nonatomic) id<VCTagSortViewControllerDelegate> delegate;
@end
