//
//  ONEBarButtonPlay.m
//  One
//
//  Created by Lolo on 16/4/26.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "ONEBarButtonAudioPlay.h"


@interface ONEBarButtonAudioPlay()
@property(nonatomic,strong)UIButton* playButton;

@end

@implementation ONEBarButtonAudioPlay


- (void)awakeFromNib{
    
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commentButton.frame = CGRectMake(00, 0, 34, 34);
    [commentButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [commentButton setImage:[UIImage imageNamed:@"play_unenable"] forState:UIControlStateDisabled];
    commentButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [commentButton addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    //_commentButton = commentButton;
    self.customView = commentButton;
}

- (void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    [self.playButton setEnabled:enabled];
}

- (void)clicked:(id)sender{
    [self.target performSelectorOnMainThread:self.action withObject:self waitUntilDone:NO];
}

@end
