//
//  ONELoadingView.m
//  One
//
//  Created by Lolo on 16/4/17.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "ONELoadingView.h"

@implementation ONELoadingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
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

- (void)prepare{
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    NSInteger animationImageCount = 12;
    for (int i = 1; i < animationImageCount; i++) {
        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading_%d", i]]];
    }
    
    for (int i = 12; i > 1; i--) {
        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading_%d", i]]];
    }
    
    self.animationImages = images;
    self.animationDuration = 4.0f;
    
    self.animationRepeatCount = CGFLOAT_MAX;
}

@end
