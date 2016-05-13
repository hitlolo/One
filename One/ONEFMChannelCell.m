//
//  ONEFMChannelCell.m
//  One
//
//  Created by Lolo on 16/5/4.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "ONEFMChannelCell.h"
#import "ONEChannel.h"

@interface ONEFMChannelCell ()
@property (strong, nonatomic) IBOutlet UIImageView *channelImage;
@property (strong, nonatomic) IBOutlet UILabel *channelLabel;

@end

@implementation ONEFMChannelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.channelImage.layer.masksToBounds = YES;
    self.channelImage.layer.cornerRadius = self.channelImage.bounds.size.width/2;
    self.channelImage.layer.borderColor = one_tintColor.CGColor;
    self.channelImage.layer.borderWidth = 2.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setChannel:(ONEChannel *)channel{
    
    NSURL* imageURL = [NSURL URLWithString:channel.cover];
    UIImage* placeHolder = one_placeHolder_channel;
    [self.channelImage sd_setImageWithURL:imageURL placeholderImage:placeHolder];
    self.channelLabel.text = channel.name;
}

@end
