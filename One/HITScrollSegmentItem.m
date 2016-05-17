//
//  HITScrollSegmentItem.m
//  HITScrollListController
//
//  Created by Lolo on 16/5/12.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "HITScrollSegmentItem.h"

#define minimumFontSize 13
#define maxmumFontSize 15

@implementation HITScrollSegmentItem

- (instancetype)init{
    self = [super init];
    if (self) {
        [self prepare];
    }
    return self;
}

- (void)prepare{
    self.layoutMargins = UIEdgeInsetsMake(8, 8, 8, 8);
    self.textAlignment = NSTextAlignmentCenter;
    self.font = [self defaultFont];
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 2.0f;
    self.layer.cornerRadius = 3.0f;
    self.layer.masksToBounds = YES;
    
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(60, 25);
}

- (void)setHighlighted:(BOOL)highlighted{
    
//    CGFloat scale = [self scaleFactor];
//    
//    if (!highlighted) {
//        self.font = [self defaultFont];
//
//        self.transform = CGAffineTransformMakeScale(scale, scale);
//        [UIView animateWithDuration:0.2f animations:^{
//            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
//        }];
//    }
//    else{
//        self.font = [self highlightedFont];
//        self.transform = CGAffineTransformMakeScale(scale - 1.0, scale - 1.0);
//        [UIView animateWithDuration:0.2f animations:^{
//            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
//        }];
//    }
    if (!highlighted) {
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    else{
        self.layer.borderColor = self.highlightedTextColor.CGColor;
    }
    [super setHighlighted:highlighted];

}

- (UIFont*)defaultFont{
    return [UIFont systemFontOfSize:minimumFontSize];
}

- (UIFont*)highlightedFont{
    return [UIFont systemFontOfSize:maxmumFontSize];
}

- (void)setHighlightProgress:(CGFloat)highlightProgress{
    _highlightProgress = highlightProgress;
    CGFloat fontSize = (maxmumFontSize - minimumFontSize) * highlightProgress;
    fontSize += minimumFontSize;
    [self setFont:[UIFont systemFontOfSize:fontSize]];
    
}

- (CGPoint)scaleFactor{
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(100, 100)
                                          options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                       attributes:@{NSFontAttributeName:[self defaultFont]}
                                          context:nil];
    CGRect rectHighlighted = [self.text boundingRectWithSize:CGSizeMake(100, 100)
                                                     options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                                  attributes:@{NSFontAttributeName:[self highlightedFont]}
                                                     context:nil];
    
    CGFloat x = rectHighlighted.size.width / rect.size.width;
    CGFloat y = rectHighlighted.size.height / rect.size.height;
    return CGPointMake(x, y);
}



@end
