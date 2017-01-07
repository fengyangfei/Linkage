//
//  VCFavorCell.m
//  Linkage
//
//  Created by lihaijian on 2017/1/7.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCFavorCell.h"
#import "VCFavor.h"
#import "VCFavorUtil.h"
#import "NSDate+Format.h"
#import "FormDescriptorCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SVProgressHUD/SVProgressHUD.h>

NSString *const VCFavorDescriporType = @"VCFavorDescriporType";

@interface VCFavorCell()
@property (nonatomic, readonly) UIImageView *iconView;
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *detailLabel;
@property (nonatomic, readonly) UILabel *subDetailLabel;
@property (nonatomic, readonly) UILabel *countLabel;
@end

@implementation VCFavorCell
@synthesize iconView = _iconView;
@synthesize titleLabel = _titleLabel;
@synthesize detailLabel = _detailLabel;
@synthesize subDetailLabel = _subDetailLabel;
@synthesize countLabel = _countLabel;

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[self class] forKey:VCFavorDescriporType];
}

#pragma mark - 右滑按钮
-(void)configureSwipe
{
    @weakify(self);
    MGSwipeButton *cancel = [MGSwipeButton buttonWithTitle:@"取消收藏" backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell *sender) {
        @strongify(self);
        XLFormRowDescriptor * row = self.rowDescriptor;
        [row.sectionDescriptor removeFormRow:row];
        [VCFavorUtil deleteFromDataBase:row.value completion:^{
            [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveParentContexts | MRSaveSynchronously completion:nil];
        }];
        return YES;
    }];
    MGSwipeButton *copy = [MGSwipeButton buttonWithTitle:@"复制网址" backgroundColor:[UIColor greenColor] callback:^BOOL(MGSwipeTableCell *sender) {
        @strongify(self);
        VCFavor *favor = self.rowDescriptor.value;
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        [pab setString:favor.url];
        if (!pab) {
            [SVProgressHUD showErrorWithStatus:@"复制失败"];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"已复制"];
        }
        return YES;
    }];
    self.rightButtons = @[cancel, copy];
}

#pragma mark - XLFormBaseCell 的生命周期
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configure];
        [self configureSwipe];
    }
    return self;
}

-(XLFormViewController *)formViewController
{
    id responder = self;
    while (responder){
        if ([responder isKindOfClass:[XLFormViewController class]]){
            return responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

#pragma mark - 生命周期
-(void)configure
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self setupUI];
}

-(void)update
{
    VCFavor *favor = self.rowDescriptor.value;
    //    [self.iconView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"地区"]];
    [self.iconView setImage:[UIImage imageNamed:@"website"]];
    self.titleLabel.text = favor.title;
    self.detailLabel.text = favor.url;
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 60;
}

-(void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller
{
    [self formDescriptorCellDidSelectedWithViewController:(UIViewController<FormViewController> *)controller];
}

-(void)formDescriptorCellDidSelectedWithViewController:(UIViewController<FormViewController> *)controller
{
    if (self.rowDescriptor.action.formBlock){
        self.rowDescriptor.action.formBlock(self.rowDescriptor);
    }else if (self.rowDescriptor.action.formSelector){
        [controller performFormSelector:self.rowDescriptor.action.formSelector withObject:self.rowDescriptor];
    }
    else{
        UIViewController * controllerToPresent = [[self.rowDescriptor.action.viewControllerClass alloc] init];
        if (controllerToPresent){
            if ([controllerToPresent conformsToProtocol:@protocol(XLFormRowDescriptorViewController)]){
                ((UIViewController<XLFormRowDescriptorViewController> *)controllerToPresent).rowDescriptor = self.rowDescriptor;
            }
            if (controller.navigationController == nil || [controllerToPresent isKindOfClass:[UINavigationController class]] || self.rowDescriptor.action.viewControllerPresentationMode == XLFormPresentationModePresent){
                [controller presentViewController:controllerToPresent animated:YES completion:nil];
            }
            else{
                controllerToPresent.hidesBottomBarWhenPushed = YES;
                [controller.navigationController pushViewController:controllerToPresent animated:YES];
            }
        }
    }
}

#pragma mark - UI
-(void)setupUI
{
    @weakify(self);
    [self.contentView addSubview:self.iconView];
    [self.iconView makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.contentView.top).offset(12);
        make.left.equalTo(self.contentView.left).offset(12);
        make.width.equalTo(16);
        make.height.equalTo(16);
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.contentView.top).offset(10);
        make.left.equalTo(self.iconView.right).offset(12);
        make.right.equalTo(self.contentView.right).offset(12);
    }];
    
    [self.contentView addSubview:self.detailLabel];
    [self.detailLabel makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.iconView.bottom).offset(5);
        make.left.equalTo(self.contentView.left).offset(12);
        make.right.equalTo(self.contentView.right).offset(-12);
    }];
}

-(UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
    }
    return _iconView;
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

-(UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.textColor = [UIColor lightGrayColor];
        _detailLabel.numberOfLines = 2;
        _detailLabel.textColor = [UIColor lightGrayColor];
    }
    return _detailLabel;
}

-(UILabel *)subDetailLabel
{
    if (!_subDetailLabel) {
        _subDetailLabel = [UILabel new];
        _subDetailLabel.font = [UIFont systemFontOfSize:12];
        _subDetailLabel.numberOfLines = 0;
        _subDetailLabel.textColor = [UIColor lightGrayColor];
    }
    return _subDetailLabel;
}

-(UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [UILabel new];
        _countLabel.font = [UIFont systemFontOfSize:12];
        _countLabel.textAlignment = NSTextAlignmentRight;
        _countLabel.textColor = [UIColor lightGrayColor];
    }
    return _countLabel;
}


@end
