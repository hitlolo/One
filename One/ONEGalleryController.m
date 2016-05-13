//
//  ONEGalleryController.m
//  One
//
//  Created by Lolo on 16/4/15.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "ONEGalleryController.h"
#import "ONEGalleryPageController.h"
#import "ONEPageController.h"
#import "ONEDBManager.h"
#import "ONEPainting.h"
#import "ONELoadingView.h"

#import "ONERootController.h"

#import "ONEMonthPickerController.h"
#import "ONEGalleryCollectionController.h"


static NSString* const StoryboardName = @"Gallery";
static NSString* const StoryboardPageIdentifier = @"gallerypage";
static NSString* const StoryboardCollectionIdentifier =@"galleryboard";

@interface ONEGalleryController ()
<UIPageViewControllerDelegate,
UIPageViewControllerDataSource,
UIPopoverPresentationControllerDelegate,
ONEMonthPickerDelegate>

@property(nonatomic,strong)ONEPageController* pageController;
@property(nonatomic,strong)NSMutableArray* paintings;
@property(nonatomic,assign,getter=isRewindPrepared)BOOL rewindable;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *oneBarButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *rewindBarButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *calenderBarButton;

@property (strong, nonatomic) UISearchController* searchController;

@end

@implementation ONEGalleryController

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

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self.paintings count] == 0) {
        [self prepareRealTimeData];
    }
}

- (NSMutableArray*)paintings{
    if (_paintings == nil) {
        _paintings = [NSMutableArray array];
    }
    return _paintings;
}


- (void)prepare{
    
    [self preparePageController];
    
    
//    [self preparePageOfflineData];
//    [self prepareRealTimeData];
    
    self.navigationController.extendedLayoutIncludesOpaqueBars = YES;
}


- (void)preparePageController{
    
    NSDictionary* options = @{UIPageViewControllerOptionInterPageSpacingKey:[NSNumber numberWithFloat:10.0]};
    self.pageController = [[ONEPageController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    self.pageController.dataSource = self;
    self.pageController.delegate = self;
    
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController didMoveToParentViewController:self];
    
    
    //prepare refresh and loadmore action
    [self.pageController.refreshControl addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventValueChanged];
    [self.pageController.loadmoreControl addTarget:self action:@selector(loadmoreAction:) forControlEvents:UIControlEventValueChanged];
    
}


- (void)preparePageOfflineData{
    //database
    //@"0" means beginning
    NSArray* temPaintings = [[ONEDBManager sharedManager]getPaintingsForGelleryFromID:@"0"];
    self.paintings = [[NSMutableArray alloc]initWithArray:temPaintings];
    
    [self reloadDataAtIndex:0];

}

- (void)prepareRealTimeData{
    [self triggerRefreshImmediately];
}



#pragma mark - page controller datasource & delegate

- (UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
   
    ONEGalleryPageController* page = (ONEGalleryPageController*)viewController;
    NSInteger index = page.index;
    if ([self.paintings count] <= index + 1) {
        return nil;
    }

    return [self createPageForIndex:index + 1];
}

- (UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    ONEGalleryPageController* page = (ONEGalleryPageController*)viewController;
    NSInteger index = page.index;
    if (index == 0) {
        return nil;
    }
    
    return [self createPageForIndex:index - 1];
}


- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    
    ONEGalleryPageController* page = (ONEGalleryPageController*)[pendingViewControllers lastObject];
    self.pageController.currentPageIndex = page.index;
    
}


- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    if (!completed) {
        ONEGalleryPageController* page = (ONEGalleryPageController*)[previousViewControllers lastObject];
        self.pageController.currentPageIndex = page.index;
    }
    else if (completed){
        
        if (self.isRewindPrepared && self.pageController.currentPageIndex == 0) {
            [self unprepareRewindBarbutton];
        }
        else if (!self.isRewindPrepared && self.pageController.currentPageIndex != 0) {
            [self prepareRewindBarbutton];
        }
        else{
            return;
        }
    }
}

- (ONEGalleryPageController*)createPageForIndex:(NSInteger)index{
    
    UIStoryboard* storyboard = nil;
    ONEGalleryPageController* viewController = nil;
    ONEPainting* painting = nil;
    
    if (self.storyboard) {
        storyboard = self.storyboard;
    }else{
        storyboard = [UIStoryboard storyboardWithName:StoryboardName bundle:[NSBundle mainBundle]];
    }
    
    if ([self.paintings count] == 0) {
        painting = nil;
    }
    if ([self.paintings count] <= index) {
        painting = nil;
    }
    else{
        painting = self.paintings[index];
    }
    viewController = [storyboard instantiateViewControllerWithIdentifier:StoryboardPageIdentifier];
    ((ONEGalleryPageController*)viewController).painting = painting;
    ((ONEGalleryPageController*)viewController).index = index;
    
    return viewController;
}



#pragma mark - Refresh & LoadMore Actions


- (void)triggerRefreshImmediately{
    [self.pageController beginRefresh];
}

// control's action methods
- (void)refreshAction:(HITPageRefreshControl*)sender{
    [self refreshRealtimeDataFromHTTP];
}


- (void)loadmoreAction:(HITPageRefreshControl*)sender{
    
    ONEPainting* lastPainting = [self.paintings lastObject];
    NSInteger lastIndex = [self.paintings indexOfObject:lastPainting];
    
    [[ONEHTTPManager sharedManager]fetchPaintingsFromLastOne:lastPainting.hpcontent_id completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            
            NSArray* objects = [responseObject objectForKey:@"data"];
            for (id item in objects) {
                ONEPainting* painting = [ONEPainting yy_modelWithJSON:item];
                [self.paintings addObject:painting];
            }
            
            [self reloadDataAtIndex:lastIndex];
            [self.pageController.loadmoreControl endRefresh];
            
        }
        else if (error) {
            NSLog(@"%@",error);
            [self.pageController.loadmoreControl endRefresh];
        }
        
    }];
    
    
}


- (void)refreshRealtimeDataFromHTTP{
    
    NSString* lastOne = @"0";
    //http
    [[ONEHTTPManager sharedManager]fetchPaintingsFromLastOne:lastOne completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            [self.paintings removeAllObjects];
            NSArray* objects = [responseObject objectForKey:@"data"];
            for (id item in objects) {
                ONEPainting* painting = [ONEPainting yy_modelWithJSON:item];
                [self.paintings addObject:painting];
            }
            
            [self reloadDataAtIndex:0];
            [self.pageController.refreshControl endRefresh];
            
        }
        
        if (error) {
            NSLog(@"%@",error);
            [self.pageController.refreshControl endRefresh];
        }
        
    }];
    
}


- (void)reloadDataAtIndex:(NSInteger)index{
    
    ONEGalleryPageController* firstPage = [self createPageForIndex:index];
    [self.pageController setViewControllers:@[firstPage] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.pageController.currentPageIndex = index;
    self.pageController.pageCount = [self.paintings count];
}


#pragma mark - Navigation bar Items

- (void)prepareRewindBarbutton{
    [self.navigationItem setLeftBarButtonItem:self.rewindBarButton animated:YES];
    self.rewindable = YES;
}

- (void)unprepareRewindBarbutton{
    [self.navigationItem setLeftBarButtonItem:self.oneBarButton animated:YES];
    self.rewindable = NO;
}


- (IBAction)homeClicked:(id)sender {
    
    [self.slideController toggleLeftSlide:self];
}


- (IBAction)searchClicked:(id)sender {
    [self.searchController.searchBar setHidden:NO];
    [self.searchController.searchBar becomeFirstResponder];
    [self.searchController setActive:YES];
}

- (IBAction)rewindClicked:(id)sender {
    [self rewindToFirstPage];
}

- (void)rewindToFirstPage{
    
    ONEGalleryPageController* firstPage = [self createPageForIndex:0];
    __weak typeof(self)weakSelf = self;
    [self.pageController setViewControllers:@[firstPage] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
        if (finished) {
            weakSelf.pageController.currentPageIndex = 0;
            [weakSelf unprepareRewindBarbutton];
        
        }
    }];
    
}



- (IBAction)calenderClicked:(id)sender {
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ONEMonthPickerController* monthPicker = [storyboard instantiateViewControllerWithIdentifier:@"monthpicker"];
    monthPicker.modalPresentationStyle = UIModalPresentationPopover;
    monthPicker.delegate = self;
    monthPicker.contentType = Essay;
    
    // Get the popover presentation controller and configure it.
    UIPopoverPresentationController *presentationController = [monthPicker popoverPresentationController];
    
    presentationController.backgroundColor = one_tintColor;
    presentationController.delegate = self;
    presentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    presentationController.barButtonItem = self.calenderBarButton;
    
    [self.navigationController presentViewController:monthPicker animated: YES completion: nil];
    
    //presentationController.passthroughViews = nil;
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

- (void)prepareForPopoverPresentation:(UIPopoverPresentationController *)popoverPresentationController{
    //    for (UIBarButtonItem* item in self.navigationItem.leftBarButtonItems) {
    //        [item setEnabled:NO];
    //    }
}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    
    //    for (UIBarButtonItem* item in self.navigationItem.leftBarButtonItems) {
    //        [item setEnabled:YES];
    //    }
}

// MARK: month picker delegate
- (void)monthPickerController:(ONEMonthPickerController *)monthPicker didSelectedDate:(NSString *)selectedDate{
    UIStoryboard*  storyboard = [UIStoryboard storyboardWithName:StoryboardName bundle:[NSBundle mainBundle]];
    ONEGalleryCollectionController* viewController = [storyboard instantiateViewControllerWithIdentifier:StoryboardCollectionIdentifier];
    viewController.selectedDate = selectedDate;
    [self.navigationController pushViewController: viewController animated:YES];
}


@end



#pragma mark - Category

@implementation UIViewController (ONEGalleryController)

- (ONEGalleryController*)galleryPageController{
    UIViewController *parent = self;
    Class slideClass = [ONEGalleryController class];
    while ( parent != nil  ) {
        if( [parent isKindOfClass:slideClass] ){
            break;
        }
        parent = [parent parentViewController];
    }
    return (id)parent;
}

@end
