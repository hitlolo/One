//
//  HITReadColumnSerialStrategy.m
//  One
//
//  Created by Lolo on 16/5/16.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "HITReadColumnSerialStrategy.h"
#import "ONESerialDescription.h"
#import "ONEArticleDescriptionCell.h"
#import "ONESerialReadingController.h"
static NSString* const iCellIndetifier = @"articleindexCell";

@implementation HITReadColumnSerialStrategy

@synthesize columnContents = _columnContents;
@synthesize hosterController = _hosterController;

- (NSMutableArray*)columnContents{
    if (_columnContents == nil) {
        _columnContents = [NSMutableArray array];
    }
    return _columnContents;
}

- (void)rigisterTableViewCellForTableView:(UITableView *)tableview{
    
}

- (void)refreshForTableviewController:(UITableViewController *)tableviewController{
    
    [[ONEHTTPManager sharedManager]fetchReadingIndexWithCompletionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"error");
            [tableviewController.refreshControl endRefreshing];
            return;
        }
        
        [self.columnContents removeAllObjects];
        
        NSDictionary* data = [responseObject objectForKey:@"data"];
        NSArray* serialsJson = [data objectForKey:@"serial"];
        
        
        for (id serial in serialsJson) {
            ONESerialDescription* serialDescription = [ONESerialDescription yy_modelWithJSON:serial];
            [self.columnContents addObject:serialDescription];
        }
        
        [tableviewController.refreshControl endRefreshing];
        [tableviewController.tableView reloadData];
        
    }];
    
}

- (void)loadmoreForTableviewController:(UITableViewController *)tableviewController{
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.columnContents count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ONEArticleDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:iCellIndetifier forIndexPath:indexPath];
    
    id<ONEArticleDescription> article = self.columnContents[indexPath.row];
    [cell setArticle:article];
    // Configure the cell...
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [self pushEssayAtIndexPath:indexPath];
    
}

- (void)pushEssayAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Reading" bundle:[NSBundle mainBundle]];
    ONESerialReadingController* nextReading = [storyboard instantiateViewControllerWithIdentifier:@"serialReadingController"];
    nextReading.articleDescription = self.columnContents[indexPath.row];
    [self.hosterController.navigationController pushViewController:nextReading animated:YES];
}

@end
