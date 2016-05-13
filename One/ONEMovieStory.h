//
//  ONEMovieStory.h
//  One
//
//  Created by Lolo on 16/4/15.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ONEAuthor.h"
@interface ONEMovieStory : NSObject

@property(nonatomic,copy)NSString* story_id;
@property(nonatomic,copy)NSString* movie_id;
@property(nonatomic,copy)NSString* title;
@property(nonatomic,copy)NSString* content;
@property(nonatomic,copy)NSString* user_id;
@property(nonatomic,copy)NSString* sort;
@property(nonatomic,assign)NSInteger praisenum;
@property(nonatomic,copy)NSString* input_date;
@property(nonatomic,copy)NSString* story_type;//1 means hot //0 means normal
@property(nonatomic,strong)ONEAuthor* author;


@end
