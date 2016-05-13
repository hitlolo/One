//
//  ONEAuthor.h
//  One
//
//  Created by Lolo on 16/4/14.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ONEAuthor : NSObject

@property(nonatomic,copy)NSString* user_id;
@property(nonatomic,copy)NSString* user_name;
@property(nonatomic,copy)NSString* web_url;
@property(nonatomic,copy)NSString* desc;
@property(nonatomic,copy)NSString* wb_name;

- (instancetype)initWithDictionary:(NSDictionary*)dic;
@end
