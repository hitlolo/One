//
//  ONEDBManager.h
//  One
//
//  Created by Lolo on 16/4/15.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

@interface ONEDBManager : NSObject

@property(nonatomic,strong)FMDatabaseQueue* dbQueue;

+ (instancetype)sharedManager;
- (void)prepareDatabase;
- (void)cleanDatabase;

//gallery
- (NSArray*)getPaintingsForGelleryFromID:(NSString*)itemid;
@end
