//
//  ONEReadingListController.h
//  One
//
//  Created by Lolo on 16/5/1.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ONEReadingListController : UITableViewController

@property(nonatomic, assign)ONEContentType articleType;
@property(nonatomic, strong)NSString* selectedDate;
@end
