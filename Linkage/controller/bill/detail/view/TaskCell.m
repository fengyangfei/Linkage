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

#pragma mark - 任务基类
@implementation TaskCell
@synthesize textLabel = _textLabel;
@synthesize detailLabel = _detailLabel;
-(void)configure
{
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setupUI];
}

-(void)setupUI
{
    //子类实现
}

+(CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 64;
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

// 属性
-(UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textColor = IndexTitleFontColor;
    }
    return _textLabel;
}

-(UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.textColor = [UIColor grayColor];
    }
    return _detailLabel;
}

@end

#pragma mark - 添加Cell
@interface TaskAddCell()<UITextFieldDelegate>
@property (nonatomic, readonly) UITextField *textField;
@end

@implementation TaskAddCell
@synthesize textField = _textField;

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[self class] forKey:TaskAddDescriporType];
}

-(void)configure
{
    [super configure];
    [self.textField setEnabled:!self.rowDescriptor.disabled];
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)update
{
    [super update];
    Task *model = self.rowDescriptor.value;
    if (model) {
        self.textLabel.attributedText = [model.driverName ?:@"" attributedStringWithTitle:@"司机："];
        self.detailLabel.attributedText = [model.driverLicense ?:@"" attributedStringWithTitle:@"车牌："];
        if (StringIsNotEmpty(model.cargoNo)) {
            self.textField.text = model.cargoNo;
            self.textField.enabled = NO;
        }
    }
}

-(void)formDescriptorCellDidSelectedWithViewController:(UIViewController<FormViewController> *)controller
{
    [self.textField becomeFirstResponder];
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

-(UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.textColor = IndexTitleFontColor;
        _textField.placeholder = @"请填入货柜号";
        _textField.delegate = self;
        _textField.returnKeyType = UIReturnKeyDone;
    }
    return _textField;
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
        self.subTextLabel.text = [NSString stringWithFormat:@"%@%@",@"货柜号：", model.cargoNo];
        self.detailLabel.text = [NSString stringWithFormat:@"%@%@",@"司机：", model.driverName];
        self.subDetailLabel.text = [NSString stringWithFormat:@"%@%@",@"车牌：", model.driverLicense];
        [self.statusBtn setAttributedTitle:[title attributedString] forState:UIControlStateNormal];
    }
}

-(void)changeStatusAction:(id)sender
{
    Task *model = self.rowDescriptor.value;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请更新状态" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }]];
    
    WeakSelf
    NSArray *sortKeys = [[LinkUtil taskStatus].allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    for (NSNumber *key in sortKeys) {
        if ([model.status compare:key] == NSOrderedSame) {
            continue;
        }
        UIAlertAction *action = [UIAlertAction actionWithTitle:[[LinkUtil taskStatus] objectForKey:key] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            //改变按钮状态的文字
            NSString *title = [[LinkUtil taskStatus] objectForKey:key];
            [weakSelf.statusBtn setAttributedTitle:[title attributedString] forState:UIControlStateNormal];
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
        _subTextLabel.font = [UIFont systemFontOfSize:14];
    }
    return _subTextLabel;
}

-(UILabel *)subDetailLabel
{
    if (!_subDetailLabel) {
        _subDetailLabel = [UILabel new];
        _subDetailLabel.textColor = [UIColor grayColor];
        _subDetailLabel.font = [UIFont systemFontOfSize:14];
    }
    return _subDetailLabel;
}

@end

#pragma mark - 查看cell
@interface TaskInfoCell()
@property (nonatomic, readonly) UILabel *subTextLabel;
@property (nonatomic, readonly) UILabel *subDetailLabel;
@property (nonatomic, readonly) UILabel *statusLabel;
@end

@implementation TaskInfoCell
@synthesize statusLabel = _statusLabel;
@synthesize subTextLabel = _subTextLabel;
@synthesize subDetailLabel = _subDetailLabel;

+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[self class] forKey:TaskInfoDescriporType];
}

-(void)configure
{
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
    [self.contentView addSubview:self.statusLabel];
    [self.statusLabel makeConstraints:^(MASConstraintMaker *make) {
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
        self.subTextLabel.text = [NSString stringWithFormat:@"%@%@",@"货柜号：", model.cargoNo];
        self.detailLabel.text = [NSString stringWithFormat:@"%@%@",@"司机：", model.driverName];
        self.subDetailLabel.text = [NSString stringWithFormat:@"%@%@",@"车牌：", model.driverLicense];;
        self.statusLabel.text = title;
    }
}

//属性
-(UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [UILabel new];
        _statusLabel.textColor = IndexButtonColor;
        _statusLabel.textAlignment = NSTextAlignmentRight;
        _statusLabel.font = [UIFont systemFontOfSize:14];
    }
    return _statusLabel;
}

-(UILabel *)subTextLabel
{
    if (!_subTextLabel) {
        _subTextLabel = [UILabel new];
        _subTextLabel.textColor = IndexTitleFontColor;
        _subTextLabel.font = [UIFont systemFontOfSize:14];
    }
    return _subTextLabel;
}

-(UILabel *)subDetailLabel
{
    if (!_subDetailLabel) {
        _subDetailLabel = [UILabel new];
        _subDetailLabel.textColor = [UIColor grayColor];
        _subDetailLabel.font = [UIFont systemFontOfSize:14];
    }
    return _subDetailLabel;
}
@end