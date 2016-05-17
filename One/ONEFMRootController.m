//
//  ONEFMRootController.m
//  One
//
//  Created by Lolo on 16/5/3.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "ONEFMRootController.h"
#import <AVFoundation/AVFoundation.h>
#import "ONEFMPageController.h"
#import "ONEFMPlayer.h"
#import "DOUAudioVisualizer.h"
static void *rootFMStatusKVOKey = &rootFMStatusKVOKey;

@interface ONEFMRootController ()
@property (strong, nonatomic) ONEFMPageController* pageController;

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIStackView *buttonStack;
@property (strong, nonatomic) IBOutlet UIButton *skipButton;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;

@property (strong, nonatomic) DOUAudioVisualizer *visualizer;
@end

@implementation ONEFMRootController

- (void)awakeFromNib{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self unenableButtons];
    [self prepareDouVisualizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[ONEFMPlayer sharedPlayer]addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:rootFMStatusKVOKey];

    //远程控制中心
    //[[UIApplication sharedApplication]beginReceivingRemoteControlEvents];
    //[self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[ONEFMPlayer sharedPlayer]removeObserver:self forKeyPath:@"status" context:rootFMStatusKVOKey];
    // 停止接受远程控制事件
    //[[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    //[self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)prepareDouVisualizer{
    
    _visualizer= [[DOUAudioVisualizer alloc]initWithFrame:_contentView.bounds];
    
//    [visualizer setBackgroundColor:[UIColor colorWithRed:239.0 / 255.0
//                                                   green:244.0 / 255.0
//                                                    blue:240.0 / 255.0
//                                                   alpha:0.2]];
    [self.contentView addSubview:_visualizer];
    
    //[self.view bringSubviewToFront:self.buttonStack];
}


//- (BOOL)canBecomeFirstResponder
//{
//    return YES;
//}


#pragma mark - background playing



#pragma mark - Buttons

- (IBAction)skipButtonClicked:(id)sender {
    [[ONEFMPlayer sharedPlayer]skip];
}

- (IBAction)nextButtonClicked:(id)sender {
    [[ONEFMPlayer sharedPlayer]next];
}

- (IBAction)lastButtonClicked:(id)sender {

}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"fmPageControllerSegue"]) {
        self.pageController = segue.destinationViewController;
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if (context == rootFMStatusKVOKey) {
        ONEFMStatus status = [[change objectForKey:NSKeyValueChangeNewKey]intValue];
        [self updateByPlayerStatus:status];
    }

}

- (void)updateByPlayerStatus:(ONEFMStatus)status{
    switch (status) {
            
        case FMPlaying:{
            [self enableButtons];
        }
            break;
        case FMPaused:
        case FMIdle:
        case FMFinished:
        case FMError:{
            [self unenableButtons];
        }
            break;
        default:
 
            break;
    }
}

- (void)enableButtons{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.skipButton setEnabled:YES];
        [self.nextButton setEnabled:YES];
    });
  
}

- (void)unenableButtons{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.skipButton setEnabled:NO];
        [self.nextButton setEnabled:NO];

    });
    
}


////响应远程音乐播放控制消息
//- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent
//{
//    
//    if (receivedEvent.type == UIEventTypeRemoteControl)
//    {
//        
//        switch (receivedEvent.subtype)
//        {
//                
//            case UIEventSubtypeRemoteControlPlay:
//                [[ONEFMPlayer sharedPlayer]unpause];
//                break;
//            case UIEventSubtypeRemoteControlPause:
//                [[ONEFMPlayer sharedPlayer]pause];
//                break;
//            case UIEventSubtypeRemoteControlNextTrack:
//                [[ONEFMPlayer sharedPlayer]next];
//                break;
//            case UIEventSubtypeRemoteControlPreviousTrack:
//                break;
//            default:
//                break;
//        }
//    }
//}
@end
