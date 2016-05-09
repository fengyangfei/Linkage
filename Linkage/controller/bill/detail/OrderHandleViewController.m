//
//  OrderHandleViewController.m
//  Linkage
//
//  Created by Mac mini on 16/4/28.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "OrderHandleViewController.h"
#import "XLFormDataSource.h"
#import "LoginUser.h"
#import "Order.h"
#import "Cargo.h"
#import "OrderUtil.h"
#import "CargoToDriverCell.h"
#import "LinkUtil.h"
#import <HMSegmentedControl/HMSegmentedControl.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "BFPaperButton.h"

@interface OrderHandleViewController ()<XLFormRowDescriptorViewController>

@end

@implementation OrderHandleViewController
@synthesize rowDescriptor = _rowDescriptor;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Order *order = self.rowDescriptor.value;
    if (order.orderId) {
        [SVProgressHUD show];
        [OrderUtil queryModelFromServer:order completion:^(Order *result) {
            [OrderUtil syncToDataBase:result completion:nil];
            [SVProgressHUD dismiss];
            [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveParentContexts | MRSaveSynchronously completion:nil];
        }];
    }
}

-(void)setupBottomView
{
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = TableBackgroundColor;
    [self.view addSubview:bottomView];
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.height.equalTo(44);
        make.bottom.equalTo(self.view.bottom);
    }];
    
    BFPaperButton *receiveButton = ({
        BFPaperButton *button = [[BFPaperButton alloc]initWithRaised:YES];
        button.cornerRadius = 4;
        [button setBackgroundColor:ButtonColor];
        [button setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20.f]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"a" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(receiveAction:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [bottomView addSubview:receiveButton];
    [receiveButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.left).offset(10);
        make.right.equalTo(bottomView.right).offset(-10);
        make.top.equalTo(bottomView.top).offset(5);
        make.height.equalTo(@44);
    }];
    
    BFPaperButton *distributionButton = ({
        BFPaperButton *button = [[BFPaperButton alloc]initWithRaised:YES];
        button.cornerRadius = 4;
        [button setBackgroundColor:ButtonColor];
        [button setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20.f]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"a" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(distributionAction:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [bottomView addSubview:distributionButton];
    [distributionButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.left).offset(10);
        make.right.equalTo(bottomView.right).offset(-10);
        make.top.equalTo(bottomView.top).offset(5);
        make.height.equalTo(@44);
    }];
    
    BFPaperButton *completeButton = ({
        BFPaperButton *button = [[BFPaperButton alloc]initWithRaised:YES];
        button.cornerRadius = 4;
        [button setBackgroundColor:ButtonColor];
        [button setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20.f]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"a" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(completeAction:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [bottomView addSubview:completeButton];
    [completeButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.left).offset(10);
        make.right.equalTo(bottomView.right).offset(-10);
        make.top.equalTo(bottomView.top).offset(5);
        make.height.equalTo(@44);
    }];
    
    BFPaperButton *cancelButton = ({
        BFPaperButton *button = [[BFPaperButton alloc]initWithRaised:YES];
        button.cornerRadius = 4;
        [button setBackgroundColor:ButtonColor];
        [button setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20.f]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"a" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [bottomView addSubview:cancelButton];
    [cancelButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.left).offset(10);
        make.right.equalTo(bottomView.right).offset(-10);
        make.top.equalTo(bottomView.top).offset(5);
        make.height.equalTo(@44);
    }];
    
}

@end
