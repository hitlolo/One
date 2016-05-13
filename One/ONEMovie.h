//
//  ONEMovie.h
//  One
//
//  Created by Lolo on 16/4/14.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ONEMovie : NSObject

@property(nonatomic,copy)NSString* movie_item_id;
@property(nonatomic,copy)NSString* title;
@property(nonatomic,copy)NSString* indexcover;
@property(nonatomic,copy)NSString* detailcover;
@property(nonatomic,copy)NSString* video;
@property(nonatomic,copy)NSString* verse;
@property(nonatomic,copy)NSString* verse_en;
@property(nonatomic,copy)NSString* score;
@property(nonatomic,copy)NSString* revisedscore;
@property(nonatomic,copy)NSString* review;
@property(nonatomic,copy)NSString* keywords;
@property(nonatomic,copy)NSString* movie_id;
@property(nonatomic,copy)NSString* info;
@property(nonatomic,copy)NSString* officialstory;//剧情简介
@property(nonatomic,copy)NSString* charge_edt;
@property(nonatomic,copy)NSString* web_url;
@property(nonatomic,assign)NSInteger praisenum;
@property(nonatomic,copy)NSString* sort;
@property(nonatomic,copy)NSString* releasetime;
@property(nonatomic,copy)NSString* scoretime;
@property(nonatomic,copy)NSString* maketime;
@property(nonatomic,copy)NSString* last_update_date;
@property(nonatomic,copy)NSString* read_num;
@property(nonatomic,strong)NSArray* photo;
@property(nonatomic,assign)NSInteger sharenum;
@property(nonatomic,assign)NSInteger commentnum;
@property(nonatomic,assign)NSInteger servertime;
@end
