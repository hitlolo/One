//
//  ONESerialReadingController.m
//  One
//
//  Created by Lolo on 16/4/30.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "ONESerialReadingController.h"
#import "ONEArticleReadingController.h"
#import "ONECommentsController.h"
#import "ONESerialContentListTableController.h"
#import "ONESerialList.h"


@interface ONESerialReadingController ()<ONEArticlePageDelegate,UIPopoverPresentationControllerDelegate,ONESerialContentListDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *pageBarButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *commentBarButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *contentListBarButton;

@property (strong, nonatomic) ONEArticleReadingController* readingController;

@property (strong, nonatomic) ONESerialList* serialContentList;
@end

@implementation ONESerialReadingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self prepare];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:NO];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setToolbarHidden:YES animated:NO];
    [super viewWillDisappear:animated];
    
}


- (void)prepare{
    [self.contentListBarButton setEnabled:NO];
    [self fetchSerialContentsFromURL];
    
}

#pragma mark - ONEArticlePageDelegate

- (void)articleDidChangeToPageIndex:(NSInteger)index pageCount:(NSInteger)count{
    [self.pageBarButton setTitle:[NSString stringWithFormat:@"%d/%d页",index+1,count]];
}

- (void)articleDidFinishLoad:(id<ONEArticle>)article{
    self.commentBarButton.title = [article articleCommentNumber];
}

#pragma mark - Bar buttons

- (IBAction)pageIndexBarButtonClicked:(id)sender {
    [self.readingController gotoFirstPage];
}

- (IBAction)cententListBarButtonClicked:(id)sender {

    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Reading" bundle:[NSBundle mainBundle]];
    ONESerialContentListTableController* contentListController = [storyboard instantiateViewControllerWithIdentifier:@"serialContentListController"];
    contentListController.modalPresentationStyle = UIModalPresentationCustom;
    contentListController.serialContentList = self.serialContentList;
    contentListController.delegate = self;
    [self presentViewController:contentListController animated:YES completion:nil];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

// MARK: Serial Content List delegate
- (void)serialContentListTable:(ONESerialContentListTableController *)contentTable didSelectedItem:(ONESerialListItem *)item{

    NSDictionary* dic = @{@"id":item.item_id,
                          @"serial_id":item.serial_id,
                          @"title":[self.articleDescription articleTitle]
                          };
    Class class = [self.articleDescription class];
    id<ONEArticleDescription> serialDescription = [class yy_modelWithDictionary:dic];
    
    [contentTable dismissViewControllerAnimated:YES completion:^{
        
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Reading" bundle:[NSBundle mainBundle]];
        ONESerialReadingController* nextReading = [storyboard instantiateViewControllerWithIdentifier:@"serialReadingController"];
        nextReading.articleDescription = serialDescription;
        [self.navigationController pushViewController:nextReading animated:YES];

    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString: @"commentSegue"]) {
        ONECommentsController* to = segue.destinationViewController;
        to.articleDescription = self.articleDescription;
        
    }
    else if ([segue.identifier isEqualToString:@"readingSegue"]){
        
        self.readingController = segue.destinationViewController;
        self.readingController.articleDescription = self.articleDescription;
        self.readingController.delegate = self;
        
    }

    
}

#pragma mark - fetch contents data

- (void)fetchSerialContentsFromURL{
    
    NSString* serialID = [self.articleDescription serialId];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[ONEHTTPManager sharedManager]fetchSerialContentListWithSerialID:serialID completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (!error) {
                NSDictionary* dic = [responseObject objectForKey:@"data"];
                self.serialContentList = [ONESerialList yy_modelWithDictionary:dic];
                [self.contentListBarButton setEnabled:YES];

            }
        }];
    });
}




@end
