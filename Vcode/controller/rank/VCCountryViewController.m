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
@property (nonatomic, strong) NSArray *keyIndexs;
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
            self.keyIndexs = [self keysFromMap:self.countryMap];
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

#pragma mark - helper 排序与去空
-(NSArray *)keysFromMap:(NSDictionary *)map
{
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSEnumerator *enumerator = [map keyEnumerator];
    NSString *key;
    while (key = [enumerator nextObject]) {
        if ([map[key] count]) {
            //过滤为空的组，字母为空的组不要在tableview上显示
            [mutableArray addObject:key];
        }
    }
    
    [mutableArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 isEqualToString:@"#"]) {
            return NSOrderedDescending;
        }else if ([obj2 isEqualToString:@"#"]){
            return NSOrderedAscending;
        }else{
            return [obj1 compare:obj2];
        }
    }];
    return [mutableArray copy];
}

#pragma mark -UITableView delegate&&datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.keyIndexs count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionKey = [self.keyIndexs objectAtIndex:section];
    return [[self.countryMap objectForKey:sectionKey] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.keyIndexs objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSString *sectionKey = [self.keyIndexs objectAtIndex:indexPath.section];
    id<XLFormOptionObject> option = [[self.countryMap objectForKey:sectionKey] objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)", [option formDisplayText],  [option formValue]];
    cell.textLabel.textColor = IndexTitleFontColor;
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionKey = [self.keyIndexs objectAtIndex:indexPath.section];
    id<XLFormOptionObject> option = [[self.countryMap objectForKey:sectionKey] objectAtIndex:indexPath.row];
    NSLog(@"countryCode - %@", [option formValue]);
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
