//
//  ONERootController.m
//  One
//
//  Created by Lolo on 16/4/19.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "ONERootController.h"
#import "ONEFMPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface ONERootController ()<UIGestureRecognizerDelegate>

@end

@implementation ONERootController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addGestureRecognizer:self.leftEdgeGeture];
    self.leftEdgeGeture.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    //远程控制中心
    [[UIApplication sharedApplication]beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    
       // 停止接受远程控制事件
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}



- (BOOL)canBecomeFirstResponder
{
    return YES;
}



#pragma mark - background playing

- (void)setupBackgroundSession{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
}
// let the leftEdgeGesture has the most highest priority。

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    //this means the otherGestureRecognizer is the UINavigationController's interactivePopGesture;
    if ([[otherGestureRecognizer.view nextResponder]isKindOfClass:[UINavigationController class]]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

#pragma mark - remote controll & info center
// MARK: 响应远程音乐播放控制消息
- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent
{
    
    if (receivedEvent.type == UIEventTypeRemoteControl)
    {
        
        switch (receivedEvent.subtype)
        {
                
            case UIEventSubtypeRemoteControlPlay:
                [[ONEFMPlayer sharedPlayer]unpause];
                break;
            case UIEventSubtypeRemoteControlPause:
                [[ONEFMPlayer sharedPlayer]pause];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [[ONEFMPlayer sharedPlayer]next];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                break;
            default:
                break;
        }
    }
}



@end
