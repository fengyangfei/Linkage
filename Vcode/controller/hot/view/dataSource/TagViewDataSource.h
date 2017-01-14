//
//  TagViewDataSource.h
//  Linkage
//
//  Created by lihaijian on 2017/1/15.
//  Copyright © 2017年 LA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMGridView.h"
@class VCPage;
@protocol VCTagDataSourceDelegate <NSObject>
@optional
- (void)VCTagView:(GMGridView *)gridView didTapOnPage:(VCPage *)page;
- (void)VCTagView:(GMGridView *)gridView changedEdit:(BOOL)edit;
- (void)VCTagView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index;
@end
@interface TagViewDataSource : NSObject<GMGridViewDataSource, GMGridViewSortingDelegate, GMGridViewTransformationDelegate, GMGridViewActionDelegate>
@property (nonatomic, weak) NSMutableArray *pages;
@property (nonatomic, weak) id<VCTagDataSourceDelegate> delegate;
@end
