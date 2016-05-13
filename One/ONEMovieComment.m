//
//  ONEMovieComment.m
//  One
//
//  Created by Lolo on 16/4/15.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "ONEMovieComment.h"

@implementation ONEMovieComment
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"comment_id" : @"id"};
}
@end
