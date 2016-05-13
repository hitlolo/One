//
//  ONETableLoadmoreFooter.m
//  One
//
//  Created by Lolo on 16/4/27.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "ONETableLoadmoreFooter.h"

@interface ONETableLoadmoreFooter()

@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadIndicator;
@end

@implementation ONETableLoadmoreFooter

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    [self.loadIndicator setHidden:YES];
    [self.loadIndicator setHidesWhenStopped:YES];
}

- (void)beginAnimation{
    [self.infoLabel setHidden:YES];
    [self.loadIndicator setHidden:NO];
    [self.loadIndicator startAnimating];
}

- (void)endAnimation{
    [self.infoLabel setHidden:NO];
    [self.loadIndicator stopAnimating];
}

- (BOOL)isAnimating{
    return [self.loadIndicator isAnimating];
}

- (void)setInfo:(NSString *)info{
    self.infoLabel.text = info;
}


@end
