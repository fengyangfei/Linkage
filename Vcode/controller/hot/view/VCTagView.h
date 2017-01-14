//
//  VCTagView.h
//  Linkage
//
//  Created by lihaijian on 2017/1/4.
//  Copyright © 2017年 LA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VCPage;
@class VCTagView;
@protocol VCTagViewDelegate <NSObject>
@optional
- (void)VCTagView:(VCTagView *)gridView didTapOnPage:(VCPage *)page;
- (void)VCTagView:(VCTagView *)gridView changedEdit:(BOOL)edit;
- (void)VCTagView:(VCTagView *)gridView sortTagOnClick:(UIButton *)sender;
@required
- (NSArray *)tagViewDataSource;
@end

@interface VCTagView : UIView
@property(weak, nonatomic) id<VCTagViewDelegate> delegate;
-(void)reloadData;
-(void)cancelEditing;
@end

