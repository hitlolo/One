//
//  ONEAuthor.m
//  One
//
//  Created by Lolo on 16/4/14.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "ONEAuthor.h"

@implementation ONEAuthor

- (instancetype)initWithDictionary:(NSDictionary*)dic{
    self = [super init];
    if (self) {
        _user_name = [dic objectForKey:@"user_name"];
        _user_id = [dic objectForKey:@"user_id"];
        _web_url = [dic objectForKey:@"web_url"];
        _desc = [dic objectForKey:@"desc"];
        _wb_name = [dic objectForKey:@"wb_name"];
    }
    return self;
}


@end
