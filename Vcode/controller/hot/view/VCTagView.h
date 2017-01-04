//
//  VCTagView.h
//  Linkage
//
//  Created by lihaijian on 2017/1/4.
//  Copyright © 2017年 LA. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol VCTagViewDelegate <NSObject>
@required
- (NSArray *)tagViewDataSource;
@end

@interface VCTagView : UIView
@property(weak, nonatomic) id<VCTagViewDelegate> delegate;
-(void)reloadData;
@end

