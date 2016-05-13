//
//  ONEMovieDescription.h
//  One
//
//  Created by Lolo on 16/4/14.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ONEMovieDescription : NSObject

@property(nonatomic,copy)NSString* movie_id;
@property(nonatomic,copy)NSString* title;
@property(nonatomic,copy)NSString* verse;
@property(nonatomic,copy)NSString* verse_en;
@property(nonatomic,copy)NSString* score;
@property(nonatomic,copy)NSString* revisedscore;
@property(nonatomic,copy)NSString* releasetime;
@property(nonatomic,copy)NSString* scoretime;
@property(nonatomic,copy)NSString* cover;
@property(nonatomic,assign)NSInteger servertime;

@end
