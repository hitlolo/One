//
//  ONEEssayReadingController.m
//  One
//
//  Created by Lolo on 16/4/29.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "ONEEssayReadingController.h"
#import "ONECommentsController.h"
#import "ONEReadingIndexCell.h"
#import "ONEArticleReadingController.h"

static NSString* const CellIdentifier = @"cellIdentifier";

@interface ONEEssayReadingController ()<ONEArticlePageDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *playBarButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *commentBarButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *pageBarButton;

@property (strong, nonatomic) ONEArticleReadingController* readingController;

@end

@implementation ONEEssayReadingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
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

- (void)articleDidChangeToPageIndex:(NSInteger)index pageCount:(NSInteger)count{
    [self.pageBarButton setTitle:[NSString stringWithFormat:@"%d/%d页",index+1,count]];
}

- (void)articleDidFinishLoad:(id<ONEArticle>)article{
    self.commentBarButton.title = [article articleCommentNumber];
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

- (IBAction)pageIndexBarButtonClicked:(id)sender {
    [self.readingController gotoFirstPage];
}

@end
