//
//  ONEGalleryCell.m
//  One
//
//  Created by Lolo on 16/4/22.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "ONEGalleryCell.h"
#import "ONEPainting.h"
@interface ONEGalleryCell()

@property (strong, nonatomic) IBOutlet UIImageView *paintingImage;
@property (strong, nonatomic) IBOutlet UITextView *mottoText;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;

@end

@implementation ONEGalleryCell

- (void)awakeFromNib{
    
    
    [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    //[self.contentView setBounds:self.bounds];
    CGRect rect = [[UIScreen mainScreen]bounds];
    self.widthConstraint.constant = rect.size.width/2 - 2*8;
    self.contentView.layer.cornerRadius = 5.0f;
    self.contentView.layer.masksToBounds = YES;
    //[self updateConstraints];
    
    //self.mottoText.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
   

}


- (void)prepareForReuse{
    self.paintingImage.image = nil;
    self.mottoText.text = nil;
    //[self setNeedsLayout];
}

- (void)setPainting:(ONEPainting *)painting{
    _painting = painting;
    
    [self.paintingImage sd_setImageWithURL:[NSURL URLWithString:painting.hp_img_url] placeholderImage:[UIImage imageNamed:@"painting_placeholder"]];
    self.mottoText.text = painting.hp_content;
    self.mottoText.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
}
@end
