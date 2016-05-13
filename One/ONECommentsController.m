//
//  ONECommentsController.m
//  One
//
//  Created by Lolo on 16/4/26.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "ONECommentsController.h"
#import "ONEHTTPManager.h"

#import "ONEEssayDescription.h"
#import "ONESerialDescription.h"
#import "ONEQuestionDescription.h"

#import "ONETableLoadmoreFooter.h"
#import "ONEReadingComment.h"
#import "ONECommentCell.h"
#import "YYModel/YYModel.h"

#import "ONECommon.h"
static NSString* const CellIdentifier = @"commentCell";

@interface ONECommentsController ()

@property (strong, nonatomic) IBOutlet ONETableLoadmoreFooter *loadMoreFooter;
@property (strong, nonatomic)NSMutableArray* comments;
@property (assign, nonatomic)NSInteger commentCount;
@end

@implementation ONECommentsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self prepare];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepare{
    [self prepareTableCellSelfSizing];
    [self prepareRefreshAndLoadmore];
    
    //[self triggerRefresh];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.comments count] == 0) {
        [self triggerRefresh];
    }
}

- (void)changeTextSize{
    [self.tableView reloadData];
}

- (void)prepareTableCellSelfSizing{
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)prepareRefreshAndLoadmore{
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl setTintColor:[UIColor colorWithRed:0.8196 green:0.7333 blue:0.6314 alpha:1.0]];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
    self.tableView.tableFooterView = self.loadMoreFooter;
//    [self.loadMoreFooter.loadButton addTarget:self action:@selector(loadMore:) forControlEvents:UIControlEventTouchUpInside];
    
    [self triggerRefresh];
}

- (NSMutableArray*)comments{
    if (_comments == nil) {
        _comments = [NSMutableArray array];
    }
    return _comments;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.comments count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ONECommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Configure the cell...
    [cell setComment:self.comments[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == [self.comments count]-1 && [self.comments count] < self.commentCount) {
        [self loadMore:nil];
    }
    else if ([self.comments count] >= self.commentCount){
        [self.loadMoreFooter setInfo:@"没有更多评论"];
    }
    
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

 */

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)fetchCommentFromURL{
    
    ONEContentType type = [self.articleDescription articleType];
    NSString* articleID = [self.articleDescription articleID];
    NSString* commentID = @"0";
    
    [[ONEHTTPManager sharedManager]fetchCommentWithReadingType:type articleID:articleID commentID:commentID completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"%@",error);
            
            return ;
        }
        
        [self.comments removeAllObjects];
        
        NSDictionary* dataJson = [responseObject objectForKey:@"data"];
        self.commentCount = [[dataJson objectForKey:@"count"]integerValue];
        NSArray* commentsJson = [dataJson objectForKey:@"data"];
        for (NSDictionary* commentJson in commentsJson) {
            ONEReadingComment* comment = [ONEReadingComment yy_modelWithJSON:commentJson];
            [self.comments addObject:comment];
        }
        [self.tableView reloadData];
        
        [self endRefresh];
    }];
}


- (void)fetchMoreCommentFromURL{
    
    ONEContentType type = [self.articleDescription articleType];
    NSString* articleID = [self.articleDescription articleID];
    NSString* commentID = [self lastCommentID];
    
    [[ONEHTTPManager sharedManager]fetchCommentWithReadingType:type articleID:articleID commentID:commentID completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
       
        if (error) {
            NSLog(@"%@",error);
    
            return ;
        }
        
        NSDictionary* dataJson = [responseObject objectForKey:@"data"];
        self.commentCount = [[dataJson objectForKey:@"count"]integerValue];
        NSArray* commentsJson = [dataJson objectForKey:@"data"];
        for (NSDictionary* commentJson in commentsJson) {
            ONEReadingComment* comment = [ONEReadingComment yy_modelWithJSON:commentJson];
            [self.comments addObject:comment];
        }
        [self.tableView reloadData];
        
        [self endLoadmore];
    }];
}

- (void)triggerRefresh{
    if (![self.refreshControl isRefreshing]) {
        [self.refreshControl beginRefreshing];
    }
    [self refresh];
}

- (void)refresh{
    [self fetchCommentFromURL];
}

- (void)endRefresh{
    [self.refreshControl endRefreshing];
}

- (void)loadMore:(id)sender{
    if ([self.loadMoreFooter isAnimating]) {
        return;
    }
    [self.loadMoreFooter beginAnimation];
    [self fetchMoreCommentFromURL];

}

- (void)endLoadmore{
    
    [self.loadMoreFooter endAnimation];
}


- (NSString*)lastCommentID{
    
    if ([self.comments count] == 0) {
        return @"0";
    }
    
    ONEReadingComment* lastComment = [self.comments lastObject];
    return lastComment.comment_id;
}


@end
