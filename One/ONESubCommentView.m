//
//  ONESubCommentView.m
//  One
//
//  Created by Lolo on 16/4/27.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "ONESubCommentView.h"

@interface ONESubCommentView() 
@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation ONESubCommentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
//        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
//        // 2. add as subview
//        [self addSubview:self.contentView];
//        // 3. allow for autolayout
//        [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
//        // 4. add constraints to span entire view
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view":self.contentView}]];
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view":self.contentView}]];
        
    }
    return self;
}


@end
