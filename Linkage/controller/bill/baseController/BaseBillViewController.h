//
//  BaseBillViewController.h
//  Linkage
//
//  Created by Mac mini on 16/3/4.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HMSegmentedControl/HMSegmentedControl.h>

@interface BaseBillViewController : UIViewController

@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

- (void)segmentedControlChangeIndex:(NSInteger)index;
@end
