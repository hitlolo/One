//
//  ONEReadingIndexController.m
//  One
//
//  Created by Lolo on 16/4/30.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "ONEReadingIndexController.h"
#import "ONEReadingController.h"
#import "ONEArticleDescriptionCell.h"
#import "ONEQuestionDescriptionCell.h"

#import "ONEEssayReadingController.h"
#import "ONESerialReadingController.h"
#import "ONEQuestionReadingController.h"

static NSString* const articleCellIdentifier = @"articleindexCell";
static NSString* const questionCellIdentifier = @"questionIndexCell";
@interface ONEReadingIndexController ()

@end

@implementation ONEReadingIndexController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self prepare];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self.tableView reloadData];
    
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepare{
    
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.clearsSelectionOnViewWillAppear = YES;
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.tintColor = one_tintColor;
    [self.refreshControl addTarget:self action:@selector(triggerRefresh) forControlEvents:UIControlEventValueChanged];
    
    
}


- (void)triggerRefresh{
    if (![self.refreshControl isRefreshing]) {
        [self.refreshControl beginRefreshing];
    }
    __weak typeof(self)weakSelf = self;
    ONEReadingController* readingController = (ONEReadingController*)self.parentViewController;
    [readingController refreshWithCompletion:^{
        [weakSelf endRefresh];
    }];
    
}

- (void)endRefresh{
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.articles count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.articleType == Essay || self.articleType == Serial) {
        ONEArticleDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:articleCellIdentifier forIndexPath:indexPath];
        
        id<ONEArticleDescription> article = self.articles[indexPath.row];
        [cell setArticle:article];
        // Configure the cell...
        
        return cell;
    }
    if (self.articleType == Question){
        
        ONEQuestionDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:questionCellIdentifier forIndexPath:indexPath];
        
        id<ONEArticleDescription> article = self.articles[indexPath.row];
        [cell setArticle:article];
        // Configure the cell...
        
        return cell;
    }
    
    
    
    return nil;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.articleType == Essay) {
        [self pushEssayAtIndexPath:indexPath];
    }
    else if (self.articleType == Serial){
        [self pushSerialAtIndexPath:indexPath];
    }
    else{
        [self pushQuestionAtIndexPath:indexPath];
    }
   
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
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

- (void)pushEssayAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Reading" bundle:[NSBundle mainBundle]];
    ONEEssayReadingController* nextReading = [storyboard instantiateViewControllerWithIdentifier:@"essayReadingController"];
    nextReading.articleDescription = self.articles[indexPath.row];
    [self.navigationController pushViewController:nextReading animated:YES];
}

- (void)pushSerialAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Reading" bundle:[NSBundle mainBundle]];
    ONESerialReadingController* nextReading = [storyboard instantiateViewControllerWithIdentifier:@"serialReadingController"];
    nextReading.articleDescription = self.articles[indexPath.row];
    [self.navigationController pushViewController:nextReading animated:YES];
}

- (void)pushQuestionAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Reading" bundle:[NSBundle mainBundle]];
    ONEQuestionReadingController* nextReading = [storyboard instantiateViewControllerWithIdentifier:@"questionReadingController"];
    nextReading.articleDescription = self.articles[indexPath.row];
    [self.navigationController pushViewController:nextReading animated:YES];
}

@end
