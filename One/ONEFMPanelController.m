//
//  ONEFMPanelController.m
//  One
//
//  Created by Lolo on 16/5/3.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "ONEFMPanelController.h"
#import "ONEFMProgressView.h"
#import "ONEFMPlayer.h"
#import <MediaPlayer/MediaPlayer.h>

static void *panelStatusKVOKey = &panelStatusKVOKey;
static void *panelSongKVOKey = &panelSongKVOKey;
static void *panelChannelKVOKey = &panelChannelKVOKey;
static void *panelDurationKVOKey = &panelDurationKVOKey;

@interface ONEFMPanelController ()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *channelTitleTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *channelCoverHeightConstraint;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UIImageView *albumCoverImage;
@property (strong, nonatomic) IBOutlet UILabel *channelTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *songTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *singerNameLabel;
@property (strong, nonatomic) IBOutlet ONEFMProgressView *albumProgressImage;

//@property (strong, nonatomic) CADisplayLink*  progressTimer;
@property (strong, nonatomic) NSTimer*  progressTimer;
@property (assign, nonatomic) NSInteger currentSongLength;
@property (assign, nonatomic) ONEFMStatus playerStatus;
@end

@implementation ONEFMPanelController

- (void)awakeFromNib{
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self prepare];
}


- (void)prepare{
    
    _currentSongLength = 0;
    [self setPlayerStatus:FMIdle];
    
    [self.albumCoverImage setUserInteractionEnabled:YES];
    UITapGestureRecognizer* oneTap = [[UITapGestureRecognizer alloc]init];
    oneTap.numberOfTapsRequired = 1;
    [oneTap addTarget:self action:@selector(albumCoverTaped:)];
    [self.albumCoverImage addGestureRecognizer:oneTap];
    
}

- (void)dealloc{
    [self removeKVO];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self registerKVO];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                        target:self
                                                      selector:@selector(updateProgress)
                                                      userInfo:nil
                                                       repeats:YES];
    if (self.playerStatus != FMPlaying) {
        [self.progressTimer setFireDate:[NSDate distantFuture]];
    }
    else{
        [self.progressTimer setFireDate:[NSDate date]];
    }
//    self.progressTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];

// CADisplayLink有点耗CPU
    
//    self.progressTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
//    [self.progressTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
//    if (self.playerStatus != FMPlaying) {
//        [self.progressTimer setPaused:YES];
//    }
//    else{
//        [self.progressTimer setPaused:NO];
//    }
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    if ([[UIScreen mainScreen]scale] == 3.0) {
        self.channelTitleTopConstraint.constant = 80;
    }
    self.channelCoverHeightConstraint.constant = [[UIScreen mainScreen]bounds].size.height/2.5;
    self.albumCoverImage.layer.cornerRadius = self.albumCoverImage.bounds.size.width/2;
    self.albumCoverImage.layer.masksToBounds = YES;
    //self.albumCoverImage.layer.borderColor = [UIColor blackColor].CGColor;
    //self.albumCoverImage.layer.borderWidth = 8.0f;
    
}


- (void)registerKVO{
    [[ONEFMPlayer sharedPlayer]addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:panelStatusKVOKey];
    
    [[ONEFMPlayer sharedPlayer]addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:panelDurationKVOKey];
    
    [[ONEFMPlayer sharedPlayer].playList addObserver:self forKeyPath:@"currentChannel" options:NSKeyValueObservingOptionNew context:panelChannelKVOKey];
    
    [[ONEFMPlayer sharedPlayer].playList addObserver:self forKeyPath:@"currentSong" options:NSKeyValueObservingOptionNew context:panelSongKVOKey];
}

- (void)removeKVO{
    [[ONEFMPlayer sharedPlayer]removeObserver:self forKeyPath:@"status" context:panelStatusKVOKey];
    [[ONEFMPlayer sharedPlayer]removeObserver:self forKeyPath:@"duration" context:panelDurationKVOKey];
    [[ONEFMPlayer sharedPlayer].playList removeObserver:self forKeyPath:@"currentChannel" context:panelChannelKVOKey];
    [[ONEFMPlayer sharedPlayer].playList removeObserver:self forKeyPath:@"currentSong" context:panelSongKVOKey];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)palyButtonClicked:(id)sender {
    if (self.playerStatus == FMIdle) {
        [[ONEFMPlayer sharedPlayer]startFM];
        //[self.playButton setHidden:YES];
    }
    else if (self.playerStatus == FMPaused){
        [[ONEFMPlayer sharedPlayer]unpause];
    }
}

- (void)albumCoverTaped:(UITapGestureRecognizer*)tap{
    if (self.playerStatus == FMPaused) {
        return;
    }
    else if (self.playerStatus == FMPlaying){
        [[ONEFMPlayer sharedPlayer]pause];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if (context == panelStatusKVOKey) {
        ONEFMStatus status = [[change objectForKey:NSKeyValueChangeNewKey]intValue];
        [self updateByPlayerStatus:status];
    }
    else if ([object isKindOfClass:[ONEFMPlaylist class]] && context == panelSongKVOKey) {
        ONESong* song = [change objectForKey:NSKeyValueChangeNewKey];
        [self updateSongInfo:song];
    }
    else if (context == panelChannelKVOKey) {
        
        ONEChannel* channel = [change objectForKey:NSKeyValueChangeNewKey];
        [self updateChannelInfo:channel];
    }
//    else if (context == panelDurationKVOKey){
//        NSTimeInterval duration = [[change objectForKey:NSKeyValueChangeNewKey]doubleValue];
//        [self updateProgress:duration];
//    }
}

- (void)updateByPlayerStatus:(ONEFMStatus)status{
    switch (status) {
            
        case FMPlaying:{
            
            self.playerStatus = FMPlaying;
            [self.progressTimer setFireDate:[NSDate date]];
            //[self.progressTimer setPaused:NO];
           
        }
            break;
        case FMPaused:{
            //[self.playButton setHidden:NO];
            self.playerStatus = FMPaused;
            [self.progressTimer setFireDate:[NSDate distantFuture]];
            //[self.progressTimer setPaused:YES];
            
        }
            break;
        case FMIdle:{
            self.playerStatus = FMIdle;
            [self.progressTimer setFireDate:[NSDate distantFuture]];
            //[self.progressTimer setPaused:YES];
            //[self.playButton setHidden:NO];
            
        }
            break;
        case FMFinished:{
            self.playerStatus = FMFinished;
            [self.progressTimer setFireDate:[NSDate distantFuture]];
            //[self.progressTimer setPaused:YES];

        }
            break;
        case FMError:{
            self.playerStatus = FMError;
            [self.progressTimer setFireDate:[NSDate distantFuture]];
            //[self.progressTimer setPaused:YES];

        }
            break;
        default:
           
            break;
    }
}

- (void)updateSongInfo:(ONESong*)song{
    self.songTitleLabel.text = song.title;
    self.singerNameLabel.text = song.artist;
    self.currentSongLength = song.length;
    NSURL* url = [NSURL URLWithString:song.picture];
    
//    [self.albumCoverImage sd_setImageWithURL:url placeholderImage:one_placeHolder_album];
//    
//    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:url options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//        if (finished && image) {
//            if (NSClassFromString(@"MPNowPlayingInfoCenter")){
//                
//                
//                NSDictionary * dict = [[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo];
//                NSMutableDictionary *mutableDict = [dict mutableCopy];
//                [mutableDict setObject:[[MPMediaItemArtwork alloc]initWithImage:image] forKey:MPMediaItemPropertyArtwork];
//                [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:mutableDict];
//                
//            }
//            
//        }
//    }];

    [self updateLockScreenWithNewSong:song];
    __weak typeof(self) weakerSelf = self;
    [self.albumCoverImage sd_setImageWithURL:url placeholderImage:one_placeHolder_album completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (NSClassFromString(@"MPNowPlayingInfoCenter")){
            
            if (song != nil && image != nil)
            {
                NSDictionary * dict = [[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo];
                NSMutableDictionary *mutableDict = [dict mutableCopy];
                [mutableDict setObject:[[MPMediaItemArtwork alloc]initWithImage:image] forKey:MPMediaItemPropertyArtwork];
                [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:mutableDict];
            }
        }
        weakerSelf.albumCoverImage.image = image;

    }];


}

- (void)updateChannelInfo:(ONEChannel*)channel{
    self.channelTitleLabel.text = [NSString stringWithFormat:@"%@Mhz",channel.name];

}

- (void)updateProgress{
    NSTimeInterval duration = [[ONEFMPlayer sharedPlayer]playedTime];
    //NSLog(@"%f",duration);
    CGFloat progress = duration/self.currentSongLength;
    [self.albumProgressImage setProgress:progress];
}

- (void)setPlayerStatus:(ONEFMStatus)playerStatus{
    if (playerStatus == FMPlaying) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.playButton.hidden = YES;
        });
        
    }
    else if(playerStatus == FMPaused || playerStatus == FMError || playerStatus == FMIdle){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.playButton.hidden = NO;
        });
        
    }
    
    _playerStatus = playerStatus;
}


#pragma mark - remote controll & info center
//
- (void)updateLockScreenWithNewSong:(ONESong*)song{
    if (NSClassFromString(@"MPNowPlayingInfoCenter")){
        
        if (song != nil){
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
            
            [dict setObject:song.title forKey:MPMediaItemPropertyTitle];
            [dict setObject:song.artist forKey:MPMediaItemPropertyArtist];
            NSTimeInterval duration = [[ONEFMPlayer sharedPlayer]playedTime];
            [dict setObject:[NSNumber numberWithFloat:duration] forKey:MPMediaItemPropertyPlaybackDuration]; //音乐当前已经播放时间
            [dict setObject:[NSNumber numberWithFloat:1.0] forKey:MPNowPlayingInfoPropertyPlaybackRate];//进度光标的速度 （这个随 自己的播放速率调整，我默认是原速播放）
            [dict setObject:[NSNumber numberWithInteger:song.length]forKey:MPMediaItemPropertyPlaybackDuration];
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
        }
    }
}

@end
