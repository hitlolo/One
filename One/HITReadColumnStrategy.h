//
//  HITReadColumnStrategy.h
//  One
//
//  Created by Lolo on 16/5/16.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol HITReadColumnStrategy <NSObject,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak)UITableViewController* hosterController;
@property(nonatomic,strong)NSMutableArray* columnContents;

- (void)rigisterTableViewCellForTableView:(UITableView*)tableview;
- (void)refreshForTableviewController:(UITableViewController*)tableviewController;
- (void)loadmoreForTableviewController:(UITableViewController*)tableviewController;
@end
