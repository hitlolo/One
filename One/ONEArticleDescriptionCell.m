//
//  ONEEssayDescrptionCell.m
//  One
//
//  Created by Lolo on 16/4/23.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "ONEArticleDescriptionCell.h"
#import "ONEArticle.h"



@interface ONEArticleDescriptionCell()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UITextView *excerptText;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIImageView *authorImage;
@property (strong, nonatomic) IBOutlet UIImageView *articleIcon;

@end

@implementation ONEArticleDescriptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.authorImage.layer.masksToBounds = YES;
    self.authorImage.layer.cornerRadius = self.authorImage.bounds.size.width/2;
    self.authorImage.layer.borderColor = one_tintColor.CGColor;
    self.authorImage.layer.borderWidth = 2.0f;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setArticle:(id<ONEArticleDescription>)article{
    
    self.titleLabel.text = [article articleTitle];
    self.authorLabel.text = [article articleAuthor];
    self.excerptText.text = [article articleExcerpt] ;
    self.dateLabel.text = [article articleTime];
    NSURL* imageURL = [NSURL URLWithString:[article articleAuthorImageURL]];
    UIImage* placeHolder = one_placeHolder_head;
    [self.authorImage sd_setImageWithURL:imageURL placeholderImage:placeHolder];
    
    UIImage* icon;
    if ([article articleType] == Essay) {
        icon = one_placeHolder_essay;
    }
    else if ([article articleType] == Serial){
        icon = one_placeHolder_serial;
    }
    [self.articleIcon setImage:icon];
    
    [self setTextSize];
}

- (void)setTextSize{
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.authorLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    self.excerptText.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.dateLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
}

@end
