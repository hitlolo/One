//
//  HITReadColumnPage.m
//  One
//
//  Created by Lolo on 16/5/15.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "HITReadColumnIndexPage.h"

@interface HITReadColumnIndexPage ()

@end

@implementation HITReadColumnIndexPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepare];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     [self triggerRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepare{
    
    self.tableView.delegate = self.strategy;
    self.tableView.dataSource = self.strategy;
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.clearsSelectionOnViewWillAppear = YES;
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.tintColor = one_tintColor;
    [self.refreshControl addTarget:self action:@selector(triggerRefresh) forControlEvents:UIControlEventValueChanged];
    
    [self.strategy setHosterController:self];
    [self.strategy rigisterTableViewCellForTableView:self.tableView];
}


- (void)triggerRefresh{
    if (![self.refreshControl isRefreshing]) {
        [self.refreshControl beginRefreshing];
    }
    
    [self.strategy refreshForTableviewController:self];
    
}

- (void)endRefresh{
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
