//
//  VCAdviceViewController.m
//  Linkage
//
//  Created by Mac mini on 2017/1/5.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCAdviceViewController.h"
#import "BFPaperButton.h"
#import "LoginUser.h"
#import "YGRestClient.h"
#import "VcodeUtil.h"
#import <IQKeyboardManager/KeyboardManager.h>
#import <XLForm/XLFormTextView.h>
#import <Mantle/NSDictionary+MTLJSONKeyPath.h>
#import <SVProgressHUD/SVProgressHUD.h>
@interface VCAdviceViewController ()
@property (strong, nonatomic) XLFormTextView *textView;

@end

@implementation VCAdviceViewController

+(void)load
{
    [[IQKeyboardManager sharedManager] disableDistanceHandlingInViewControllerClass:[self class]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = VCThemeString(@"advices");
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:VCThemeString(@"ok") style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.view.backgroundColor = BackgroundColor;
    
    [self.view addSubview:self.textView];
    [self.textView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(18);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.height.equalTo(@(200));
    }];
    
    UILabel *phoneLabel = [UILabel new];
    phoneLabel.backgroundColor = BackgroundColor;
    phoneLabel.text = VCThemeString(@"phonetext");
    phoneLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:phoneLabel];
    [phoneLabel makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self.view.left).offset(8);
         make.right.equalTo(self.view.right);
         make.top.equalTo(self.textView.bottom);
         make.height.equalTo(44);
    }];
    
    UITextField *phoneTextField = [[UITextField alloc]init];
    phoneTextField.backgroundColor = [UIColor whiteColor];
    phoneTextField.placeholder = VCThemeString(@"phone_ed");
    phoneTextField.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:phoneTextField];
    [phoneTextField makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self.view.left);
         make.right.equalTo(self.view.right);
         make.top.equalTo(phoneLabel.bottom);
         make.height.equalTo(@44);
    }];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)doneAction
{
    [self.textView resignFirstResponder];
    NSDictionary *paramter = @{
                               @"deviceCode":[VcodeUtil UUID],
                               @"feedback":self.textView.text,
                               @"phoneNumber":@"123456789"
                               };
    paramter = [paramter mtl_dictionaryByAddingEntriesFromDictionary:[LoginUser shareInstance].baseHttpParameter];
    [[YGRestClient sharedInstance] postForObjectWithUrl:FeedbackUrl form:paramter success:^(id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"提交成功"];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"提交失败"];
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
}

-(UITextView *)textView
{
    if (!_textView) {
        _textView = [XLFormTextView new];
        _textView.placeholder = VCThemeString(@"pleaseEnterQuestions");
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.textColor = [UIColor blackColor];
        _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return _textView;
}

@end
