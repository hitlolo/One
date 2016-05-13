//
//  ONEMovieReview.h
//  One
//
//  Created by Lolo on 16/4/15.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ONEAuthor.h"
@interface ONEMovieReview : NSObject

@property(nonatomic,copy)NSString* review_id;
@property(nonatomic,copy)NSString* movie_id;
@property(nonatomic,copy)NSString* content;
@property(nonatomic,copy)NSString* score;
@property(nonatomic,assign)NSInteger praisenum;
@property(nonatomic,copy)NSString* sort;
@property(nonatomic,copy)NSString* input_date;
@property(nonatomic,strong)ONEAuthor* author;
@end
