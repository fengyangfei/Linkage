//
//  VCCountryViewController.m
//  Linkage
//
//  Created by Mac mini on 2017/1/4.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCCountryViewController.h"
#import "VCCountryUtil.h"

@interface VCCountryViewController ()
@property (nonatomic, strong) NSDictionary *countryMap;
@end

@implementation VCCountryViewController
@synthesize tableView = _tableView;

- (instancetype)init
{
    self = [super init];
    if (self) {
        @weakify(self);
        [VCCountryUtil queryModelsFromServer:^(NSArray *models) {
            @strongify(self);
            self.countryMap = [VCCountryUtil generateDicFromArray:models];
            [self reloadData];
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -UITableView delegate&&datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.countryMap allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionKey = [[self.countryMap allKeys] objectAtIndex:section];
    return [[self.countryMap objectForKey:sectionKey] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.countryMap allKeys] objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSString *sectionKey = [[self.countryMap allKeys] objectAtIndex:indexPath.section];
    id<XLFormOptionObject> option = [[self.countryMap objectForKey:sectionKey] objectAtIndex:indexPath.row];
    cell.textLabel.text = [option formDisplayText];
    cell.textLabel.textColor = IndexTitleFontColor;
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionKey = [[self.countryMap allKeys] objectAtIndex:indexPath.section];
    id<XLFormOptionObject> option = [[self.countryMap objectForKey:sectionKey] objectAtIndex:indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter setter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

@end
