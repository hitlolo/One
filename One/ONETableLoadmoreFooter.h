//
//  ONETableLoadmoreFooter.h
//  One
//
//  Created by Lolo on 16/4/27.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ONETableLoadmoreFooter : UIView

- (void)setInfo:(NSString*)info;

- (void)beginAnimation;
- (void)endAnimation;
- (BOOL)isAnimating;
@end
