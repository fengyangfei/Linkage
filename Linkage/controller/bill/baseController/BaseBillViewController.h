//
//  BaseBillViewController.h
//  Linkage
//
//  Created by Mac mini on 16/3/4.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseBillViewController : UIViewController

@property (nonatomic, strong) UITableView *todoTableView;
@property (nonatomic, strong) UITableView *doneTableView;

- (void)segmentedControlChangeIndex:(NSInteger)index;
@end
