//
//  ONECommentCell.m
//  One
//
//  Created by Lolo on 16/4/26.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "ONECommentCell.h"
#import "ONESubCommentView.h"

@interface ONECommentCell()

@property (strong, nonatomic) IBOutlet UIImageView *authorImage;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIStackView *labelStack;
@property (strong, nonatomic) IBOutlet UIButton *praiseButton;
@property (strong, nonatomic) IBOutlet UILabel *praiseLabel;
@property (strong, nonatomic) IBOutlet ONESubCommentView *subCommentView;

@property (strong, nonatomic) IBOutlet UITextView *commentText;

@property (strong, nonatomic) NSLayoutConstraint *commentTopToStack;

@property (copy, nonatomic) NSArray* subCommentConstrains;
@end

@implementation ONECommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.subCommentConstrains = self.subCommentView.constraints;
    
    self.authorImage.layer.masksToBounds = YES;
    self.authorImage.layer.cornerRadius = self.authorImage.bounds.size.width/2;
    self.authorImage.layer.borderColor = one_tintColor.CGColor;
    self.authorImage.layer.borderWidth = 2.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setComment:(ONEReadingComment *)comment{
    NSURL* imageURL = [NSURL URLWithString:comment.user.web_url];
    UIImage* placeHolder = one_placeHolder_head;
    [self.authorImage sd_setImageWithURL:imageURL placeholderImage:placeHolder];
    
    self.authorLabel.text = comment.user.user_name;
    self.dateLabel.text = [ONEDateHelper getDayMonthYear:comment.input_date];
    self.praiseLabel.text = [NSString stringWithFormat:@"%ld", (long)comment.praisenum];
    
    if (comment.quote == nil || [comment.quote isEqualToString:@""]) {

        self.subCommentView.authoLabel.text = nil;
        self.subCommentView.contentText.text = nil;
        
        if (![self.subCommentView isHidden]) {
            [NSLayoutConstraint deactivateConstraints:self.subCommentView.constraints];
            [self.commentTopToStack setActive:YES];
            
            [self.subCommentView setHidden:YES];
        
        }
        //[self.subCommentView setNeedsUpdateConstraints];
        //[self.subCommentView invalidateIntrinsicContentSize];
        
    }
    else{
        
        if ([self.subCommentView isHidden]) {
            [NSLayoutConstraint activateConstraints:self.subCommentConstrains];
        
            [self.commentTopToStack setActive:NO];
            [self.subCommentView setHidden:NO];
        
        }
        
        
        self.subCommentView.authoLabel.text = [NSString stringWithFormat:@"%@:",comment.touser.user_name];
        self.subCommentView.contentText.text = comment.quote;
        
        //[self.subCommentView setNeedsUpdateConstraints];
        //[self.subCommentView invalidateIntrinsicContentSize];
    }
    
    self.commentText.text = comment.content;
    
    [self setTextSize];
}

- (NSLayoutConstraint*)commentTopToStack{
    if (_commentTopToStack) {
        _commentTopToStack = [NSLayoutConstraint constraintWithItem:self.commentText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.labelStack attribute:NSLayoutAttributeBottom multiplier:1.0f constant:8];
    }
    return _commentTopToStack;
}

- (void)setTextSize{
    self.authorLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.dateLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    self.praiseLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    if (![self.subCommentView isHidden]) {
        self.subCommentView.authoLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        self.subCommentView.contentText.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    self.commentText.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
}


@end
