//
//  ONEQuestionDescriptionCell.m
//  One
//
//  Created by Lolo on 16/5/1.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "ONEQuestionDescriptionCell.h"
#import "ONEArticle.h"
@interface ONEQuestionDescriptionCell ()

@property (strong, nonatomic) IBOutlet UILabel *questionTitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *answerTitleLabel;
@property (strong, nonatomic) IBOutlet UITextView *excerptText;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@end

@implementation ONEQuestionDescriptionCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setArticle:(id<ONEArticleDescription>)article{
    
    self.questionTitleLabel.text = [article articleTitle];
    self.answerTitleLabel.text = [article articleSubtitle];
    self.excerptText.text = [article articleExcerpt] ;
    self.dateLabel.text = [article articleTime];
    
    [self setTextSize];
}

- (void)setTextSize{
    self.questionTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.answerTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    self.excerptText.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.dateLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
}

@end
