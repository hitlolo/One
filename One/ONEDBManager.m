//
//  ONEDBManager.m
//  One
//
//  Created by Lolo on 16/4/15.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "ONEDBManager.h"
#import "YYModel/YYModel.h"
#import "ONEPainting.h"

@implementation ONEDBManager{
    FMDatabase* database;
}

+ (instancetype)sharedManager{
    
    static ONEDBManager* _manager = nil;
    static dispatch_once_t once_token;
    
    dispatch_once(&once_token, ^{
        _manager = [[ONEDBManager alloc]init];
    });
    return _manager;
}


- (FMDatabaseQueue*)dbQueue{
    if (_dbQueue == nil) {
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:[self databaseFilePath]];
    }
    return _dbQueue;
}


- (void)prepareDatabase{
    
    database = [FMDatabase databaseWithPath: [self databaseFilePath]];
    NSAssert(database, @"Database initialize failed");
    NSString* sqlStatements = [self getTableCreatingSQLStatements];
    if (![database open]) {
        NSLog(@"open database failed;");
        return;
    }
    if (![database executeStatements:sqlStatements]) {
        NSLog(@"database => failed to create table.");
    };
    
    [database close];
}

- (NSString*)databaseFilePath{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingString:@"/one.db"];
}

- (NSString*)getTableCreatingSQLStatements{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"init" ofType:@"sql"];
    NSError *error;
    NSString *sql = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    NSAssert(!error, @"Failed to get init.sql file, message=%@",error);
    return sql;
}




#pragma mark - Gallery

- (NSArray*)getPaintingsForGelleryFromID:(NSString *)itemid{
    
    if (![database open]) {
        return nil;
    }
    NSMutableArray* paintings = [NSMutableArray array];
    NSString* sql = nil;
    if ([itemid isEqualToString:@"0"]) {
        sql = @"SELECT * FROM gallery ORDER BY hp_makettime DESC LIMIT 10";
    }
    else{
        sql = [NSString stringWithFormat:@"SELECT * FROM gallery WHERE hpcontent_id < %@ ORDER BY hp_makettime DESC LIMIT 10",itemid];
    }
    
    
    FMResultSet *resultSet = [database executeQuery:sql];
    while ([resultSet next]) {
        //retrieve values for each record
        NSDictionary* paintingDic = [resultSet resultDictionary];
        ONEPainting * paitingModel = [ONEPainting yy_modelWithDictionary:paintingDic];
        [paintings addObject:paitingModel];
    }
    
    [database close];
    return paintings;
}

@end
