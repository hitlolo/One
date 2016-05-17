//
//  HITReadContent.h
//  HITScrollListController
//
//  Created by Lolo on 16/5/13.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HITReadColumn <NSObject>
@property(nonatomic,strong)NSString* title;
@property(nonatomic,assign)NSInteger type;
@end

@interface HITReadColumn : NSObject<NSCoding,HITReadColumn>

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end
