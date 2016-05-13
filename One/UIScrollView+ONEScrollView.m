//
//  UIScrollView+ONEScrollView.m
//  hitOne
//
//  Created by Lolo on 15/10/17.
//  Copyright © 2015年 Lolo. All rights reserved.
//

#import "UIScrollView+ONEScrollView.h"

@implementation UIScrollView (ONEScrollView)

- (BOOL)isAtTop {
    return (self.contentOffset.y <= [self verticalOffsetForTop]);
}

- (BOOL)isAtBottom {
    return (self.contentOffset.y >= [self verticalOffsetForBottom]);
}

- (CGFloat)verticalOffsetForTop {
    CGFloat topInset = self.contentInset.top;
    return -topInset;
}

- (CGFloat)verticalOffsetForBottom {
    CGFloat scrollViewHeight = self.bounds.size.height;
    CGFloat scrollContentSizeHeight = self.contentSize.height;
    CGFloat bottomInset = self.contentInset.bottom;
    CGFloat scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight;
    return scrollViewBottomOffset;
}

- (void)scrollToTop{
    self.contentOffset = CGPointMake(0.0f, 0.0f);
}


@end
