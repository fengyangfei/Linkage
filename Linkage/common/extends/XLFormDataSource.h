//
//  XLFormDataSource.h
//  Linkage
//
//  Created by Mac mini on 16/3/28.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLFormDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) XLFormDescriptor *form;
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, weak) UITableView *tableView;

- (instancetype)initWithViewController:(UIViewController *)viewController tableView:(UITableView *)tableView;
@end
