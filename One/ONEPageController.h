//
//  ONEPageController.h
//  One
//
//  Created by Lolo on 16/4/18.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HITPageRefreshControl.h"

@class HITPageRefreshControl;

@interface ONEPageController : UIPageViewController

@property(nonatomic,assign)NSInteger currentPageIndex;
@property(nonatomic,assign)NSInteger pageCount;

@property(nonatomic,strong)HITPageRefreshControl* refreshControl;
@property(nonatomic,strong)HITPageRefreshControl* loadmoreControl;

- (void)beginRefresh;
- (void)endRefresh;

@end
