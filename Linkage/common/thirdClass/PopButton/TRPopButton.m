//
//  TRPopButton.m
//  YGTravel
//
//  Created by Mac mini on 16/2/1.
//  Copyright © 2016年 ygsoft. All rights reserved.
//

#import "TRPopButton.h"

@interface TRPopButton()
@property (nonatomic, readonly) CAShapeLayer *plusLayer;
@end

@implementation TRPopButton
@synthesize circleLayer = _circleLayer;
@synthesize plusLayer = _plusLayer;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

/**
 * Draw layers.
 */
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self.layer addSublayer:self.circleLayer];
    [self.layer addSublayer:self.plusLayer];
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowRadius = 2;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.4;
}

//圆圈
-(CAShapeLayer *)circleLayer
{
    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.frame = self.bounds;
        _circleLayer.backgroundColor = UIColorFromRGB(0x007AFF).CGColor;
        _circleLayer.cornerRadius = CGRectGetWidth(self.bounds)/2;
    }
    return _circleLayer;
}

//加号
-(CAShapeLayer *)plusLayer
{
    if (!_plusLayer) {
        _plusLayer = [CAShapeLayer layer];
        _plusLayer.frame = self.bounds;
        _plusLayer.lineCap = kCALineCapRound;
        _plusLayer.strokeColor = [UIColor whiteColor].CGColor;
        _plusLayer.lineWidth = 2.0;
        _plusLayer.path = [self plusBezierPath].CGPath;
    }
    return _plusLayer;
}

//加号的路径
-(UIBezierPath *)plusBezierPath
{
    CGFloat size = CGRectGetWidth(self.bounds);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(size/2, size/3)];
    [path addLineToPoint:CGPointMake(size/2, size - size/3)];
    [path moveToPoint:CGPointMake(size/3, size/2)];
    [path addLineToPoint:CGPointMake(size - size/3, size/2)];
    return path;
}

@end
