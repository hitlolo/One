//
//  ONEPageController.m
//  One
//
//  Created by Lolo on 16/4/18.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "ONEPageController.h"


@interface ONEPageController ()<HITPageRefreshControlDataSource>


@end

@implementation ONEPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)prepare{

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (HITPageRefreshControl*)refreshControl{
    if (_refreshControl == nil) {
        CGRect frame = CGRectMake(0, 0, 50, 50);
        _refreshControl = [[HITPageRefreshControl alloc]initWithFrame:frame];
        _refreshControl.controlType = HITRefresh;
        _refreshControl.datasource = self;
        [self.view addSubview:_refreshControl];
    }
    return _refreshControl;
}

- (HITPageRefreshControl*)loadmoreControl{
    if (_loadmoreControl == nil) {
        CGRect frame = CGRectMake(0, 0, 50, 50);
        _loadmoreControl = [[HITPageRefreshControl alloc]initWithFrame:frame];
        _loadmoreControl.controlType = HITLoadmore;
        _loadmoreControl.datasource = self;
        [self.view addSubview:_loadmoreControl];
    }
    return _loadmoreControl;
}

- (void)beginRefresh{
    [self.refreshControl triggerRefresh];
}

- (void)endRefresh{
    if ([self.refreshControl isRefreshing]) {
        [self.refreshControl endRefresh];
    }
    else if ([self.loadmoreControl isRefreshing]){
        [self.loadmoreControl endRefresh];
    }
}


@end
