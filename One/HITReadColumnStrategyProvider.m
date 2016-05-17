//
//  HITReadColumnStrategyProvider.m
//  One
//
//  Created by Lolo on 16/5/16.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "HITReadColumnStrategyProvider.h"
#import "HITReadColumnEssayStrategy.h"
#import "HITReadColumnSerialStrategy.h"
#import "HITReadColumnQuestionStrategy.h"
@implementation HITReadColumnStrategyProvider

- (id<HITReadColumnStrategy>)strategyForColumnType:(NSInteger)type{
    if (type == HITReadColumnEssay) {
        return [[HITReadColumnEssayStrategy alloc]init];
    }
    
    if (type == HITReadColumnSerial) {
        return [[HITReadColumnSerialStrategy alloc]init];
    }
    
    if (type == HITReadColumnQuestion) {
        return [[HITReadColumnQuestionStrategy alloc]init];
    }
    
    return nil;
}
@end
