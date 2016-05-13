//
//  ONEFMChannelController.h
//  One
//
//  Created by Lolo on 16/5/3.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ONEChannel;
@protocol ONEChannelControllerSelectDelage;

@interface ONEFMChannelController : UITableViewController
@property(nonatomic,weak)id<ONEChannelControllerSelectDelage> delegate;
@end


@protocol ONEChannelControllerSelectDelage <NSObject>

- (void)channelController:(ONEFMChannelController*)channelController didSelectedChannel:(ONEChannel*)channel;

@end