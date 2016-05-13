//
//  ONEReadingIndexController.h
//  One
//
//  Created by Lolo on 16/4/30.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ONEReadingIndexController : UITableViewController

@property(nonatomic,weak)NSMutableArray* articles;
@property(nonatomic,assign)ONEContentType articleType;
- (void)triggerRefresh;
@end
