//
//  XLFormDataSource.h
//  Linkage
//
//  Created by lihaijian on 16/3/28.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol FormViewController;
@protocol XLFormDataSourceDelegate <NSObject>
@optional
-(void)didSelectFormRow:(XLFormRowDescriptor *)formRow;
-(void)deselectFormRow:(XLFormRowDescriptor *)formRow;
-(void)reloadFormRow:(XLFormRowDescriptor *)formRow;
-(UITableViewCell<XLFormDescriptorCell> *)updateFormRow:(XLFormRowDescriptor *)formRow;
-(NSDictionary *)formValues;
@end


@interface XLFormDataSource : NSObject<UITableViewDataSource,UITableViewDelegate, XLFormDescriptorDelegate,XLFormDataSourceDelegate>
@property (nonatomic, strong) XLFormDescriptor *form;
@property (nonatomic, weak) UIViewController<FormViewController> *viewController;
@property (nonatomic, weak) UITableView *tableView;

- (instancetype)initWithViewController:(UIViewController *)viewController tableView:(UITableView *)tableView;
@end
