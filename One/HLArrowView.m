//
//  HLAnimationView.m
//  HLRefreshView
//
//  Created by Lolo on 15/12/6.
//  Copyright © 2015年 Lolo. All rights reserved.
//

#import "HLArrowView.h"
#import "HLArrowShapeLayer.h"

@implementation HLArrowView

+ (Class)layerClass{
    return [HLArrowShapeLayer class];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)prepare{
    self.backgroundColor = [UIColor clearColor];
    
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self prepare];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self prepare];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepare];
    }
    return self;
}


- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    HLArrowShapeLayer* shapeLayer = (HLArrowShapeLayer*)self.layer;
    shapeLayer.progress = progress;
    //[shapeLayer setAffineTransform:CGAffineTransformMakeRotation(M_PI/2 * (progress))];
}

- (void)setShapeType:(ShapeType)shapeType{
    _shapeType = shapeType;
    HLArrowShapeLayer* shapeLayer = (HLArrowShapeLayer*)self.layer;
    [shapeLayer setShapeType:shapeType];
}

- (void)startAnimation{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(M_PI * 2.0);
    rotationAnimation.duration = 1.0f;
    rotationAnimation.autoreverses = NO;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.layer addAnimation:rotationAnimation forKey:@"spinningAnimation"];
}

- (void)endAnimation{
    [self.layer removeAnimationForKey:@"spinningAnimation"];
}


@end
