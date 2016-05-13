//
//  HITReuseQueue.h
//  One
//
//  Created by Lolo on 16/4/1.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HITReusableItem.h"

@protocol HITReusableItem;

@interface HITReuseQueue : NSObject


+(nonnull instancetype)queue;

-(void)enqueueReusableItem:(nonnull id<HITReusableItem>)item;
-(nullable id<HITReusableItem>)dequeueReusableItemWithIdentifier:(nonnull NSString*)identifier;

-(void)registerNib:(nonnull UINib*)nib forItemReuseIdentifier:(nonnull NSString*)identifier;
-(void)registerClass:(nonnull Class)class forItemReuseIdentifier:(nonnull NSString*)identifier;
-(void)registerStoryboard:(nonnull UIStoryboard*)storyboard forItemReuseIdentifier:(nonnull NSString*)identifier;

@end
