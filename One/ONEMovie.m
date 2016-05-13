//
//  ONEMovie.m
//  One
//
//  Created by Lolo on 16/4/14.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "ONEMovie.h"

@implementation ONEMovie

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"movie_item_id" : @"id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"photo" : [NSString class]};
}
@end
