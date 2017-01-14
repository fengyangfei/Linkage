//
//  VCSortTagView.h
//  Linkage
//
//  Created by Mac mini on 2017/1/14.
//  Copyright © 2017年 LA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VCPage;
@class VCSortTagView;
@protocol VCSortTagViewDelegate <NSObject>
@optional
- (void)VCSortTagViewRefresh:(VCSortTagView *)gridView;
@end
@interface VCSortTagView : UIView
@property(weak, nonatomic) id<VCSortTagViewDelegate> delegate;
-(void)reloadData;
@end
