//
//  MainViewController.m
//  Linkage
//
//  Created by Mac mini on 16/2/22.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewCell.h"
#import "BillTypeViewController.h"
#import "LoginUser.h"
#import "Company.h"
#import "CycleScrollCell.h"


@interface MainViewController ()

@end

@implementation MainViewController
@synthesize tableView = _tableView;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeForm];
    }
    return self;
}

- (void)initializeForm
{
    XLFormDescriptor *form = [self createForm];
    self.form = form;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    WeakSelf
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf setupData];
    });
}

-(void)setupData
{
    WeakSelf
    NSDictionary *paramter = @{
                               @"mobile":[LoginUser shareInstance].mobile?:@"",
                               @"password":[LoginUser shareInstance].password?:@""
                               };
    [[YGRestClient sharedInstance] postForObjectWithUrl:LoginUrl form:paramter success:^(id responseObject) {
        NSError *error = nil;
        LoginUser *loginUser = [MTLJSONAdapter modelOfClass:[LoginUser class] fromJSONDictionary:responseObject error:&error];
        if (loginUser && !error) {
            loginUser.mobile = [LoginUser shareInstance].mobile;
            loginUser.password = [LoginUser shareInstance].password;
            [loginUser save];
            XLFormDescriptor *form = [weakSelf createForm];
            [weakSelf setForm:form];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

-(XLFormDescriptor *)createForm
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptor];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:CycleScrollDescriporRowType];
    row.value = [LoginUser shareInstance].advertes;
    [section addFormRow:row];
    
    for (Company *company in [LoginUser shareInstance].companies) {
        NSString *rowType = CompanyInfoDescriporType;
        if ([LoginUser shareInstance].ctype == UserTypeCompanyAdmin) {
            rowType = CompanyDescriporType;
        }else if([LoginUser shareInstance].ctype == UserTypeSubCompanyAdmin) {
            rowType = CompanyInfoDescriporType;
        }
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:rowType];
        row.value = company;
        [section addFormRow:row];
    }
    return form;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
