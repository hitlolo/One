//
//  HITReadColumnStrategyProvider.h
//  One
//
//  Created by Lolo on 16/5/16.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HITReadColumnStrategy.h"

typedef NS_ENUM(NSInteger,HITReadColumnType){
    HITReadColumnEssay,
    HITReadColumnSerial,
    HITReadColumnQuestion,
    HITReadColumnElephant,
    HITReadColumnDota2,
    HITReadColumnZhihu
};

@interface HITReadColumnStrategyProvider : NSObject

- (id<HITReadColumnStrategy>)strategyForColumnType:(NSInteger)type;
@end
