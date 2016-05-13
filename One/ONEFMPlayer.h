//
//  ONEFMPlayer.h
//  One
//
//  Created by Lolo on 16/5/3.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ONEFMPlaylist.h"


typedef NS_ENUM(NSInteger,ONEFMStatus) {
    FMIdle,
    FMPlaying,
    FMPaused,
    FMFinished,
    FMBuffering,
    FMError
};

typedef NS_ENUM(NSInteger,ONEFMAudioType) {
    FMAudioArticle,
    FMAudioFm,
    FMAudioNone
};

@protocol DOUAudioFile;
@interface ONEFMPlayer : NSObject

@property(nonatomic,assign,readonly)ONEFMStatus status;
@property(nonatomic,strong,readonly)ONEFMPlaylist* playList;

+ (instancetype)sharedPlayer;

- (void)startFM;
- (void)pause;
- (void)unpause;
- (void)next;
- (void)skip;
- (void)rewind;
- (void)stop;

- (void)playArticleAudio:(id<DOUAudioFile>)articleAudio;
- (NSTimeInterval)playedTime;
- (BOOL)isPlaying;
- (BOOL)isPaused;
@end
