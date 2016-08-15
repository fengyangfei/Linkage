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
#import <MJRefresh/MJRefresh.h>
#import "SearchViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize tableView = _tableView;

-(void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAction:)];
    self.navigationItem.rightBarButtonItem = searchItem;    
    [self initializeForm];
    WeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        StrongSelf
        [self login:^(LoginUser *user) {
            XLFormDescriptor *form = [strongSelf createForm:user];
            [strongSelf setForm:form];
            if ([strongSelf.tableView.mj_header isRefreshing]) {
                [strongSelf.tableView.mj_header endRefreshing];
            }
        }];
    }];
}

-(void)initializeForm
{
    XLFormDescriptor *form = [self createForm:[LoginUser shareInstance]];
    self.form = form;
}

-(void)login:(void(^)(LoginUser *user))completion
{
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
            if (completion) {
                completion(loginUser);
            }
        }else{
            NSLog(@"%@",error.localizedDescription);
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

-(XLFormDescriptor *)createForm:(LoginUser *)user
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptor];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:CycleScrollDescriporRowType];
    row.value = user.advertes;
    [section addFormRow:row];
    
    for (Company *company in user.companies) {
        NSString *rowType = CompanyInfoDescriporType;
        if (user.ctype == UserTypeCompanyAdmin || user.ctype == UserTypeCompanyUser) {
            rowType = CompanyDescriporType;
        }else if(user.ctype == UserTypeSubCompanyAdmin) {
            rowType = CompanyInfoDescriporType;
        }
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:rowType];
        row.value = company;
        [section addFormRow:row];
    }
    return form;
}

-(void)searchAction:(id)sender
{
    SearchViewController *searchViewController = [[SearchViewController alloc]init];
    searchViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchViewController animated:YES];
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
