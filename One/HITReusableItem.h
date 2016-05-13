//
//  HITReusableItem.h
//  One
//
//  Created by Lolo on 16/4/1.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HITReusableItem <NSObject>

@required

@property(nonatomic,copy)NSString* reuseIdentifier;

@optional
- (instancetype)initWithReuseIdentifier:(NSString*)reuseIdentifier;
- (void)prepareForReuse;

@end

