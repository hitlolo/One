//
//  ONESerialContentListTable.m
//  One
//
//  Created by Lolo on 16/5/2.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "ONESerialContentListTableController.h"
#import "ONESerialContentListTransition.h"
#import "ONESerialList.h"
static NSString* const cellIdentifier = @"listCell";
@interface ONESerialContentListTableController ()
@property(nonatomic,strong)id<UIViewControllerTransitioningDelegate> transition;

@end

@implementation ONESerialContentListTableController


- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.transition = [[ONESerialContentListTransitionDelegate alloc]init];
        self.transitioningDelegate = self.transition;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.tableView.rowHeight = 50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.serialContentList.list count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    ONESerialListItem* item = self.serialContentList.list[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"第%@话",item.number];
    // Configure the cell...
    
    return cell;
}

- (CGSize)preferredContentSize{
    CGSize size = CGSizeZero;
    size.width = [[UIScreen mainScreen]bounds].size.width / 4;
    size.height = [[UIScreen mainScreen]bounds].size.height;
    return size;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
    label.backgroundColor = [UIColor colorWithRed:0.0328 green:0.0047 blue:0.0063 alpha:0.5];
    label.textColor = one_tintColor;
    label.text = @"目录";
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ONESerialListItem* item = self.serialContentList.list[indexPath.row];
    [self.delegate serialContentListTable:self didSelectedItem:item];
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

@end
