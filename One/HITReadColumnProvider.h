//
//  HITReadSegmentContentProvider.h
//  HITScrollListController
//
//  Created by Lolo on 16/5/13.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HITReadColumn.h"


@interface HITReadColumnProvider : NSObject

@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,strong)NSMutableOrderedSet* columnsOn;
@property(nonatomic,strong)NSMutableOrderedSet* columnsOff;

- (instancetype)initWithColumnPlistFilename:(NSString*)plist;
@end
