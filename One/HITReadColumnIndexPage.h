//
//  HITReadColumnPage.h
//  One
//
//  Created by Lolo on 16/5/15.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HITReadColumnStrategy.h"
@interface HITReadColumnIndexPage : UITableViewController

@property(nonatomic,strong)id<HITReadColumnStrategy> strategy;
@property(nonatomic,assign)NSInteger index;
@end
