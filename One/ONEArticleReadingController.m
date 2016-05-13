//
//  ONEArticleReadingController.m
//  One
//
//  Created by Lolo on 16/5/1.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "ONEArticleReadingController.h"
#import "ONEReadingIndexCell.h"
#import "ONELoadingView.h"

#import "ONEEssayReadingController.h"
#import "ONESerialReadingController.h"

#import "ONEEssay.h"
#import "ONESerial.h"
#import "ONEQuestion.h"

#import "ONEEssayDescription.h"
#import "ONESerialDescription.h"
#import "ONEQuestionDescription.h"

#import "ONECommentsController.h"

static NSString* const CellIdentifier = @"cellIdentifier";

@interface ONEArticleReadingController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet ONELoadingView *loadingView;

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIWebView *articleWebView;
@property (strong, nonatomic) IBOutlet UITableView *relatedTable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstraint;


//data
@property (strong, nonatomic) id<ONEArticle> article;
@property (strong, nonatomic) NSMutableArray* relatedArticles;

@property (assign, nonatomic) NSInteger currentPageIndex;
@property (assign, nonatomic) CGFloat pageWidth;
@end

@implementation ONEArticleReadingController

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
    //[self.navigationController setToolbarHidden:NO animated:NO];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setToolbarHidden:YES animated:NO];
    //[super viewWillDisappear:animated];
    
}

- (void)dealloc{
    [self.relatedTable removeObserver:self forKeyPath:@"contentSize"];
    self.articleWebView = nil;
}

- (void)prepare{
    
    [self beginLoading];
    
    [self prepareWebView];
    [self prepareRelatedTableview];
    
    
    
    [self fetchArticleFromURL];
    [self fetchRelatedArticleFromURL];
}

- (void)changeTextSize{
    //[self beginLoading];
    //[self.webView reload];
    //[self.webView loadHTMLString:[self toHTML] baseURL:[[NSBundle mainBundle] bundleURL]];
}

- (void)prepareWebView{
    self.articleWebView.paginationMode = UIWebPaginationModeLeftToRight;
    //self.webView.pageLength = self.view.bounds.size.width;
    //self.webView.paginationBreakingMode = UIWebPaginationBreakingModePage;
    self.articleWebView.delegate = self;
    self.pageWidth = self.view.width;
    
   
    UISwipeGestureRecognizer* nextPageGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipePage:)];
    nextPageGesture.delegate = self;
    nextPageGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.articleWebView addGestureRecognizer:nextPageGesture];
    
    UISwipeGestureRecognizer* lastPageGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipePage:)];
    lastPageGesture.delegate = self;
    lastPageGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.articleWebView addGestureRecognizer:lastPageGesture];
    

}

- (void)prepareRelatedTableview{
    
    
    //    self.relatedTable.tableHeaderView = related;
    
    [self.relatedTable addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    self.relatedTable.tintColor = one_tintColor;
    self.relatedTable.delegate = self;
    self.relatedTable.dataSource = self;
    self.relatedTable.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.relatedTable.estimatedRowHeight = 80;
    self.relatedTable.rowHeight = UITableViewAutomaticDimension;
    UINib* nib = [UINib nibWithNibName:@"ONEReadingIndexCell" bundle:[NSBundle mainBundle]];
    [self.relatedTable registerNib:nib forCellReuseIdentifier:CellIdentifier];
    [self.relatedTable setScrollEnabled:NO];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    CGSize new = [[change objectForKey:NSKeyValueChangeNewKey]CGSizeValue];
    
    // self.tableHeightConstraint.constant = self.relatedTable.contentSize.height;
    if ([self.relatedArticles count] == 0) {
        self.tableHeightConstraint.constant = 0;
    }
    else{
        self.tableHeightConstraint.constant = new.height;
    }
}


#pragma mark - Page Navigation



- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    UISwipeGestureRecognizer* swipeGesture = (UISwipeGestureRecognizer*)gestureRecognizer;
    if (swipeGesture.direction == UISwipeGestureRecognizerDirectionRight && self.currentPageIndex == 0) {
        return NO;
    }
    else{
        return YES;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO;
}

- (void)swipePage:(UISwipeGestureRecognizer*)swipeGesture{
    
    if (swipeGesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self nextPage];
    }
    if (swipeGesture.direction == UISwipeGestureRecognizerDirectionRight){
        [self lastPage];
    }
}

- (void)lastPage{
    if (self.currentPageIndex > 0 ) {
        CGPoint nextOffset = self.articleWebView.scrollView.contentOffset;
        
        NSInteger offset = (NSInteger)nextOffset.x % (NSInteger)self.pageWidth;
        nextOffset.x -= self.pageWidth;
        if (offset != 0) {
            offset = (self.pageWidth - offset);
        }
        nextOffset.x += offset ;
        
        [self.articleWebView.scrollView setContentOffset:nextOffset animated:YES];
        self.currentPageIndex = nextOffset.x / self.pageWidth;
        [self updatePageIndex:nextOffset.x];
    }
}

- (void)nextPage{
    if (self.currentPageIndex < self.articleWebView.pageCount - 1) {
        CGPoint nextOffset = self.articleWebView.scrollView.contentOffset;
        nextOffset.x += self.pageWidth;
        NSInteger offset = (NSInteger)nextOffset.x % (NSInteger)self.pageWidth;
        
        nextOffset.x -= offset;
        [self.articleWebView.scrollView setContentOffset:nextOffset animated:YES];
        [self updatePageIndex:nextOffset.x];
    }
}

- (void)gotoFirstPage{
    CGPoint nextOffset = self.articleWebView.scrollView.contentOffset;
    nextOffset.x = 0;
    [self.articleWebView.scrollView setContentOffset:nextOffset animated:YES];
    [self updatePageIndex:nextOffset.x];
    
}

- (void)updatePageIndex:(CGFloat)offset{
    self.currentPageIndex = offset / self.pageWidth;
    [self.delegate articleDidChangeToPageIndex:self.currentPageIndex pageCount:self.articleWebView.pageCount];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Load Data

- (void)beginLoading{
    
    [self.view addSubview:self.loadingView];
    [self.view bringSubviewToFront:self.loadingView];
    self.loadingView.center = self.view.center;
    [self.contentView setHidden:YES];
    
    [self.loadingView startAnimating];
}

- (void)endLoading{
    
    [self.loadingView stopAnimating];
    [self.loadingView removeFromSuperview];
    [self.contentView setHidden:NO];
}

- (void)fetchArticleFromURL{
    
    ONEContentType type = [self.articleDescription articleType];
    NSString* contentID = [self.articleDescription articleID];
    [[ONEHTTPManager sharedManager]fetchArticleWithType:type articleID:contentID completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        
        NSDictionary* dataJson = [responseObject objectForKey:@"data"];
        if (type == Essay) {
             self.article = [ONEEssay yy_modelWithJSON:dataJson];
        }
        else if (type == Serial){
            self.article = [ONESerial yy_modelWithJSON:dataJson];

        }
        else if (type == Question){
            self.article = [ONEQuestion yy_modelWithJSON:dataJson];
        }
    
        [self setContent];
    }];
}


- (void)setContent{
    
    [self.articleWebView loadHTMLString:[self.article articleToHTML] baseURL:[[NSBundle mainBundle] bundleURL]];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self endLoading];
    [self updatePageIndex:0];
    [self.delegate articleDidFinishLoad:self.article];
}

#pragma mark - Related Table for Essays

- (void)fetchRelatedArticleFromURL{
    
    ONEContentType type = [self.articleDescription articleType];
    NSString* contentID = [self.articleDescription articleID];
    
    [[ONEHTTPManager sharedManager]fetchRelatedArticleWithReadingType:type articleID:contentID completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        
        NSArray* data = [responseObject objectForKey:@"data"];
        
       
        Class class = [self.articleDescription class];
        
        for (NSDictionary* dataJson in data) {
            id<ONEArticleDescription> articleDescription = [class yy_modelWithJSON:dataJson];
            [self.relatedArticles addObject:articleDescription];
        }
//        NSLog(@"%@",self.relatedArticles);
        
//        if (type == Essay) {
//           
//            for (NSDictionary* dataJson in data) {
//                id<ONEArticleDescription> articleDescription = [ONEEssayDescription yy_modelWithJSON:dataJson];
//                [self.relatedArticles addObject:articleDescription];
//            }
//            
//
//        }
//        else if (type == Serial){
//            for (NSDictionary* dataJson in data) {
//                id<ONEArticleDescription> articleDescription = [ONESerialDescription yy_modelWithJSON:dataJson];
//                [self.relatedArticles addObject:articleDescription];
//                NSLog(@"%@",articleDescription);
//
//            }
//            
//        }
//        else if (type == Question){
//            for (NSDictionary* dataJson in data) {
//                id<ONEArticleDescription> articleDescription = [ONEQuestionDescription yy_modelWithJSON:dataJson];
//                [self.relatedArticles addObject:articleDescription];
//            }
//        }
//
//        NSLog(@"%@",self.relatedArticles);
        [self reloadRelatedTable];
        
    }];
}

- (NSMutableArray*)relatedArticles{
    if (_relatedArticles == nil) {
        _relatedArticles = [NSMutableArray array];
    }
    return _relatedArticles;
}

- (void)reloadRelatedTable{
    
    if ([self.relatedArticles count] == 0) {
        self.tableHeightConstraint.constant = 0;
        return;
    }
    
    [self.relatedTable reloadData];
    //self.tableHeightConstraint.constant = self.relatedTable.contentSize.height;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.relatedArticles count];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ONEReadingIndexCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    id<ONEArticleDescription> articleDescription = self.relatedArticles[indexPath.row];
    [cell setArticle:articleDescription];
    
   
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    id<ONEArticleDescription> articleDescription = self.relatedArticles[indexPath.row];
//    CGFloat height = [ONEReadingIndexCell cellHeightForTableView:tableView data:[articleDescription articleTitle]];
//    return height;
//}

//- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return @"相关推荐:";
//}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel* related = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
    related.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    related.textColor = one_tintColor;
    related.text = @"相关推荐:";
    //related.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.101008234797297];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
    [view setBackgroundColor:[UIColor colorWithRed:0.7556 green:0.7556 blue:0.7556 alpha:0.10]];
    [view addSubview:related];
    related.translatesAutoresizingMaskIntoConstraints = NO;
    //    view.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint constraintWithItem:related attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0].active = YES;
    [NSLayoutConstraint constraintWithItem:related attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeading multiplier:1 constant:8].active = YES;
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ONEContentType type = [self.articleDescription articleType];
    if (type == Essay) {
        [self pushEssayAtIndexPath:indexPath];
    }
    else if (type == Serial){
        [self pushSerialAtIndexPath:indexPath];
    }
    else{
        [self pushQuestionAtIndexPath:indexPath];
    }
}


- (void)pushEssayAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Reading" bundle:[NSBundle mainBundle]];
    ONEEssayReadingController* nextReading = [storyboard instantiateViewControllerWithIdentifier:@"essayReadingController"];
    nextReading.articleDescription = self.relatedArticles[indexPath.row];
    [self.navigationController pushViewController:nextReading animated:YES];
}

- (void)pushSerialAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Reading" bundle:[NSBundle mainBundle]];
    ONESerialReadingController* nextReading = [storyboard instantiateViewControllerWithIdentifier:@"serialReadingController"];
    nextReading.articleDescription = self.relatedArticles[indexPath.row];
    [self.navigationController pushViewController:nextReading animated:YES];
}

- (void)pushQuestionAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Reading" bundle:[NSBundle mainBundle]];
    ONESerialReadingController* nextReading = [storyboard instantiateViewControllerWithIdentifier:@"questionReadingController"];
    nextReading.articleDescription = self.relatedArticles[indexPath.row];
    [self.navigationController pushViewController:nextReading animated:YES];

}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
