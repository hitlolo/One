//
//  ONEReadingListController.m
//  One
//
//  Created by Lolo on 16/5/1.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "ONEReadingListController.h"
#import "ONEEssayDescription.h"
#import "ONESerialDescription.h"
#import "ONEQuestionDescription.h"

#import "ONEEssayReadingController.h"
#import "ONESerialReadingController.h"
#import "ONEQuestionReadingController.h"
#import "ONEReadingIndexCell.h"
static NSString* const CellIdentifier = @"cellIdentifier";
@interface ONEReadingListController ()
@property(nonatomic,strong)NSMutableArray* articleDescriptions;
@end

@implementation ONEReadingListController

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
    self.navigationItem.title = self.selectedDate;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self.articleDescriptions count] == 0) {
        [self triggerRefresh];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepare{
    
    [self setHidesBottomBarWhenPushed:YES];
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.clearsSelectionOnViewWillAppear = YES;
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.tintColor = one_tintColor;
    [self.refreshControl addTarget:self action:@selector(triggerRefresh) forControlEvents:UIControlEventValueChanged];
    UINib* nib = [UINib nibWithNibName:@"ONEReadingIndexCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    
}

- (void)triggerRefresh{
    if (![self.refreshControl isRefreshing]) {
        [self.refreshControl beginRefreshing];
    }
    [self fetchArticleList];
    
}

- (void)endRefresh{
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}


- (NSMutableArray*)articleDescriptions{
    if (_articleDescriptions == nil) {
        _articleDescriptions = [NSMutableArray array];
    }
    return _articleDescriptions;
}

- (void)fetchArticleList{
    [[ONEHTTPManager sharedManager]fetchArticleByMonthWithType:self.articleType selectedMonth:self.selectedDate completionHadnler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error");
            
            return;
        }
        [self.articleDescriptions removeAllObjects];
        Class class = [self getArticleTypeClass];
        NSArray* data = [responseObject objectForKey:@"data"];
        
        
        for (id articleJson in data) {
            id<ONEArticleDescription> article = [class yy_modelWithJSON:articleJson];
            [self.articleDescriptions addObject:article];
        }
        //end
        [self endRefresh];

    }];
}

- (Class)getArticleTypeClass{
    if (self.articleType == Essay) {
        return [ONEEssayDescription class];
    }
    else if (self.articleType == Serial){
        return [ONESerialDescription class];
    }
    else
        return [ONEQuestionDescription class];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.articleDescriptions count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ONEReadingIndexCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setArticle:self.articleDescriptions[indexPath.row]];
    // Configure the cell...
    
    return cell;
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
    nextReading.articleDescription = self.articleDescriptions[indexPath.row];
    [self.navigationController pushViewController:nextReading animated:YES];
}

- (void)pushSerialAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Reading" bundle:[NSBundle mainBundle]];
    ONESerialReadingController* nextReading = [storyboard instantiateViewControllerWithIdentifier:@"serialReadingController"];
    nextReading.articleDescription = self.articleDescriptions[indexPath.row];
    [self.navigationController pushViewController:nextReading animated:YES];
}

- (void)pushQuestionAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Reading" bundle:[NSBundle mainBundle]];
    ONEQuestionReadingController* nextReading = [storyboard instantiateViewControllerWithIdentifier:@"questionReadingController"];
    nextReading.articleDescription = self.articleDescriptions[indexPath.row];
    [self.navigationController pushViewController:nextReading animated:YES];
}

@end
