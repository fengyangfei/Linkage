//
//  DriverInfoCell.m
//  Linkage
//
//  Created by lihaijian on 16/3/28.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "TaskCell.h"
#import "Task.h"
#import "NSString+Hint.h"
#import "LinkUtil.h"
#import "YGRestClient.h"
#import "LoginUser.h"
#import <SVProgressHUD/SVProgressHUD.h>

NSString *const TaskInfoDescriporType = @"TaskInfoRowType";
NSString *const TaskEditDescriporType = @"TaskEditRowType";
NSString *const TaskAddDescriporType = @"TaskAddRowType";


@interface TaskCell()<UITextFieldDelegate>
@property (nonatomic, readonly) UILabel *textLabel;
@property (nonatomic, readonly) UILabel *detailLabel;
@property (nonatomic, readonly) UITextField *textField;
@end

#pragma mark - 任务基类
@implementation TaskCell
@synthesize textLabel = _textLabel;
@synthesize detailLabel = _detailLabel;
@synthesize textField = _textField;

-(void)configure
{
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setupUI];
    [self.textField setEnabled:!self.rowDescriptor.disabled];
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)update
{
    [super update];
    Task *model = self.rowDescriptor.value;
    if (model) {
        self.textLabel.attributedText = [model.driverName ?:@"" attributedStringWithTitle:@"司机：" font:[UIFont systemFontOfSize:16]];
        self.detailLabel.attributedText = [model.driverLicense ?:@"" attributedStringWithTitle:@"车牌：" font:[UIFont systemFontOfSize:16]];
        if (model.cargoNo && model.cargoNo.length > 0) {
            self.textField.text = model.cargoNo;
        }
    }
}

-(void)formDescriptorCellDidSelectedWithViewController:(UIViewController<FormViewController> *)controller
{
    [self.textField becomeFirstResponder];
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 64;
}

-(UIView *)inputAccessoryView
{
    return nil;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self textFieldDidChange:textField];
    [self unhighlight];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Helper
- (void)textFieldDidChange:(UITextField *)textField{
    Task *model = self.rowDescriptor.value;
    if([self.textField.text length] > 0) {
        model.cargoNo = self.textField.text;
    } else {
        model.cargoNo = @"";
    }
}

-(UIViewController *)formViewController
{
    id responder = self;
    while (responder){
        if ([responder isKindOfClass:[UIViewController class]]){
            return responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

#pragma mark - updateUI
-(void)setupUI
{
    [self.contentView addSubview:self.textLabel];
    [self.textLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(16);
        make.top.equalTo(self.contentView.top).offset(10);
    }];
    
    [self.contentView addSubview:self.detailLabel];
    [self.detailLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLabel.right).offset(18);
        make.top.equalTo(self.contentView.top).offset(10);
    }];
    
    [self.contentView addSubview:self.textField];
    [self.textField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(16);
        make.bottom.equalTo(self.contentView.bottom).offset(-10);
    }];
}

// 属性
-(UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.textColor = IndexTitleFontColor;
    }
    return _textLabel;
}

-(UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.textColor = [UIColor grayColor];
    }
    return _detailLabel;
}

-(UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.font = [UIFont systemFontOfSize:16];
        _textField.textColor = IndexTitleFontColor;
        _textField.placeholder = @"请填入货柜号";
        _textField.delegate = self;
        _textField.returnKeyType = UIReturnKeyDone;
    }
    return _textField;
}
@end

#pragma mark - 添加Cell
@implementation TaskAddCell
+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[self class] forKey:TaskAddDescriporType];
}
@end

#pragma mark - 编辑Cell
@interface TaskEditCell()
@property (nonatomic, readonly) UIButton *statusBtn;
@property (nonatomic, readonly) UILabel *subTextLabel;
@property (nonatomic, readonly) UILabel *subDetailLabel;
@end

@implementation TaskEditCell
@synthesize statusBtn = _statusBtn;
@synthesize subTextLabel = _subTextLabel;
@synthesize subDetailLabel = _subDetailLabel;

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[self class] forKey:TaskEditDescriporType];
}

-(void)configure
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setupUI];
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 64;
}

-(void)setupUI
{
    [self.contentView addSubview:self.textLabel];
    [self.textLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(16);
        make.top.equalTo(self.contentView.top).offset(10);
    }];
    
    [self.contentView addSubview:self.subTextLabel];
    [self.subTextLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLabel.right).offset(18);
        make.top.equalTo(self.contentView.top).offset(10);
    }];
    
    [self.contentView addSubview:self.detailLabel];
    [self.detailLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(16);
        make.bottom.equalTo(self.contentView.bottom).offset(-10);
    }];
    
    [self.contentView addSubview:self.subDetailLabel];
    [self.subDetailLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailLabel.right).offset(18);
        make.bottom.equalTo(self.contentView.bottom).offset(-10);
    }];
    
    [self.contentView addSubview:self.statusBtn];
    [self.statusBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-12);
        make.centerY.equalTo(self.contentView.centerY);
        make.width.equalTo(80);
        make.height.equalTo(30);
    }];
}

-(void)update
{
    Task *model = self.rowDescriptor.value;
    if (model) {
        NSString *cargoType = [LinkUtil.cargoTypes objectForKey:model.cargoType];
        NSString *title = [[LinkUtil taskStatus] objectForKey:model.status];
        self.textLabel.text = cargoType;
        self.subTextLabel.text = model.cargoNo;
        self.detailLabel.text = [NSString stringWithFormat:@"%@%@",@"司机：", model.driverName];
        self.subDetailLabel.text = [NSString stringWithFormat:@"%@%@",@"车牌：", model.driverLicense];;
        [self.statusBtn setTitle:title forState:UIControlStateNormal];
    }
}

-(void)changeStatusAction:(id)sender
{
    Task *model = self.rowDescriptor.value;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请更新状态" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }]];
    
    WeakSelf
    for (NSNumber *key in [LinkUtil taskStatus].allKeys) {
        if ([model.status compare:key] == NSOrderedSame) {
            continue;
        }
        UIAlertAction *action = [UIAlertAction actionWithTitle:[[LinkUtil taskStatus] objectForKey:key] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            //改变按钮状态的文字
            NSString *title = [[LinkUtil taskStatus] objectForKey:key];
            [weakSelf.statusBtn setTitle:title forState:UIControlStateNormal];
            ((Task *)weakSelf.rowDescriptor.value).status = key;
            //同步状态到服务端
            NSDictionary *parameter = @{
                                        @"task_id":model.taskId ?:@"1",
                                        @"status":key
                                        };
            parameter = [[LoginUser shareInstance].baseHttpParameter mtl_dictionaryByAddingEntriesFromDictionary:parameter];
            [[YGRestClient sharedInstance] postForObjectWithUrl:UpdataTaskStatusUrl form:parameter success:^(id responseObject) {
                [SVProgressHUD showSuccessWithStatus:@"任务状态更新成功"];
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }];
        }];
        [alertController addAction:action];
    }
    if (self.formViewController) {
        [self.formViewController presentViewController:alertController animated:YES completion:^{
            
        }];
    }
}

// 属性
-(UIButton *)statusBtn
{
    if (!_statusBtn) {
        _statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_statusBtn setTitleColor:HeaderColor forState:UIControlStateNormal];
        [_statusBtn setBackgroundImage:ButtonFrameImage forState:UIControlStateNormal];
        [_statusBtn setBackgroundImage:ButtonFrameImage forState:UIControlStateHighlighted];
        [_statusBtn addTarget:self action:@selector(changeStatusAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _statusBtn;
}

-(UILabel *)subTextLabel
{
    if (!_subTextLabel) {
        _subTextLabel = [UILabel new];
        _subTextLabel.textColor = IndexTitleFontColor;
        _subTextLabel.font = [UIFont systemFontOfSize:16];
    }
    return _subTextLabel;
}

-(UILabel *)subDetailLabel
{
    if (!_subDetailLabel) {
        _subDetailLabel = [UILabel new];
        _subDetailLabel.textColor = [UIColor grayColor];
        _subDetailLabel.font = [UIFont systemFontOfSize:16];
    }
    return _subDetailLabel;
}

@end

#pragma mark - 查看cell
@interface TaskInfoCell()
@property (nonatomic, readonly) UILabel *statusLabel;
@end

@implementation TaskInfoCell
@synthesize statusLabel = _statusLabel;
+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[self class] forKey:TaskInfoDescriporType];
}

-(void)configure
{
    [super configure];
    [self.textField setEnabled:NO];
}

-(void)setupUI
{
    [super setupUI];
    [self.contentView addSubview:self.statusLabel];
    [self.statusLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top);
        make.bottom.equalTo(self.contentView.bottom);
        make.right.equalTo(self.contentView.right);
        make.width.equalTo(80);
    }];
}

-(void)update
{
    Task *model = self.rowDescriptor.value;
    if (model) {
        self.textLabel.attributedText = [model.driverName ?:@"" attributedStringWithTitle:@"司机：" font:[UIFont systemFontOfSize:16]];
        self.detailLabel.attributedText = [model.driverLicense ?:@"" attributedStringWithTitle:@"车牌：" font:[UIFont systemFontOfSize:16]];
        self.textField.attributedText = [model.cargoNo ?:@"" attributedStringWithTitle:@"货柜号：" font:[UIFont systemFontOfSize:16]];
        self.statusLabel.text = [[LinkUtil taskStatus] objectForKey:@([model.status intValue])];
    }
}

-(UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [UILabel new];
        _statusLabel.backgroundColor = ButtonColor;
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.font = [UIFont systemFontOfSize:14];
    }
    return _statusLabel;
}
@end