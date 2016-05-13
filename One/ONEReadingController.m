//
//  ONEReadingController.m
//  One
//
//  Created by Lolo on 16/4/23.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "ONEReadingController.h"
#import "ONELoadingView.h"
#import "ONERootController.h"
#import "ONEEssayDescription.h"
#import "ONESerialDescription.h"
#import "ONEQuestionDescription.h"

#import "ONEReadingIndexController.h"
#import "ONEMonthPickerController.h"
#import "ONEReadingListController.h"
static NSString* const StoryboardName = @"Reading";
static NSString* const StoryboardReadingIndexIdentifier = @"readIndexController";



@interface ONEReadingController ()<UIPopoverPresentationControllerDelegate,ONEMonthPickerDelegate>
@property (strong, nonatomic) IBOutlet UISegmentedControl *readingSegment;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *oneBarButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *calenderBarButton;


@property (strong, nonatomic) ONEReadingIndexController* essayIndexController;
@property (strong, nonatomic) ONEReadingIndexController* serialIndexController;
@property (strong, nonatomic) ONEReadingIndexController* questionIndexController;


//@property (strong, nonatomic) ONEEssayIndexController* essayController;
//@property (strong, nonatomic) ONESerialIndexController* serialController;
//@property (strong, nonatomic) ONEQuestionIndexController* questionController;

@property (weak, nonatomic) ONEReadingIndexController* currentController;


@property (strong, nonatomic) NSMutableArray* essays;
@property (strong, nonatomic) NSMutableArray* serials;
@property (strong, nonatomic) NSMutableArray* questions;


@end

@implementation ONEReadingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepare];
    [self.currentController triggerRefresh];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepare{
    
    [self prepareControllers];
    //[self prepareData];

}

- (void)prepareControllers{
    
    [self addChildViewController:self.essayIndexController];
    [self.view addSubview:self.essayIndexController.view];
    [self.essayIndexController didMoveToParentViewController:self];

    self.currentController = self.essayIndexController;
    
    
    [self addChildViewController:self.serialIndexController];
    [self addChildViewController:self.questionIndexController];

}



- (void)changeTextSize{
    
    [self.currentController.tableView reloadData];

}

#pragma mark - Getters

- (ONEReadingIndexController*)essayIndexController{
    if (_essayIndexController == nil) {
        _essayIndexController = [self.storyboard instantiateViewControllerWithIdentifier:StoryboardReadingIndexIdentifier];
        _essayIndexController.articles = self.essays;
        _essayIndexController.articleType = Essay;
    }
    return _essayIndexController;
}

- (ONEReadingIndexController*)serialIndexController{
    if (_serialIndexController == nil) {
        _serialIndexController = [self.storyboard instantiateViewControllerWithIdentifier:StoryboardReadingIndexIdentifier];
        _serialIndexController.articles = self.serials;
        _serialIndexController.articleType = Serial;
    }
    return _serialIndexController;
}

- (ONEReadingIndexController*)questionIndexController{
    if (_questionIndexController == nil) {
        _questionIndexController = [self.storyboard instantiateViewControllerWithIdentifier:StoryboardReadingIndexIdentifier];
        _questionIndexController.articles = self.questions;
        _questionIndexController.articleType = Question;
    }
    return _questionIndexController;
}


- (NSMutableArray*)essays{
    if (_essays == nil) {
        _essays = [NSMutableArray array];
    }
    return _essays;
}

- (NSMutableArray*)serials{
    if (_serials == nil) {
        _serials = [NSMutableArray array];
    }
    return _serials;
}

- (NSMutableArray*)questions{
    if (_questions == nil) {
        _questions = [NSMutableArray array];
    }
    return _questions;
}


#pragma mark - Bar button Actions

- (IBAction)oneClicked:(id)sender {
    [self.slideController toggleLeftSlide:self];
}


- (IBAction)calenderClicked:(id)sender {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ONEMonthPickerController* monthPicker = [storyboard instantiateViewControllerWithIdentifier:@"monthpicker"];
    monthPicker.modalPresentationStyle = UIModalPresentationPopover;
    monthPicker.delegate = self;
    monthPicker.contentType = [self getContentTypeBySegment];
    
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
//    UIStoryboard*  storyboard = [UIStoryboard storyboardWithName:StoryboardName bundle:[NSBundle mainBundle]];
//    ONEGalleryCollectionController* viewController = [storyboard instantiateViewControllerWithIdentifier:StoryboardCollectionIdentifier];
//    viewController.selectedDate = monthPicker.selectedDate;
//    [self.navigationController pushViewController: viewController animated:YES];
    ONEReadingListController* articleListController = [[ONEReadingListController alloc]initWithStyle:UITableViewStylePlain];
    articleListController.articleType = [self getContentTypeBySegment];
    articleListController.selectedDate = selectedDate;
    [self.navigationController pushViewController:articleListController animated:YES];
}


- (IBAction)readingSegmentSelected:(id)sender {
    [self.readingSegment setEnabled:NO];
    UIViewController* from = self.currentController;
    UIViewController* to = [self getViewControllerBySegment:sender];
    if (to.parentViewController == nil) {
        [self addChildViewController:to];
    }
    
    CGRect fromFrame = from.view.frame;
//    CGRect toFrame = fromFrame;
//    toFrame.origin.x += self.view.width;
//    
    [to.view setFrame:fromFrame];
    [to.view setAlpha:0.1f];
    [from willMoveToParentViewController:nil];
    [self transitionFromViewController:from toViewController:to duration:0.2f options:UIViewAnimationOptionCurveEaseIn animations:^{
        
         //to.view.frame = fromFrame;
        [to.view setAlpha:1.0f];
        
    }  completion:^(BOOL finished) {
        
        if (finished) {
            self.currentController = (ONEReadingIndexController*)to;
            [to didMoveToParentViewController:self];
            [from removeFromParentViewController];
        }
        [self.readingSegment setEnabled:YES];
    }];
}

- (UIViewController*)getViewControllerBySegment:(UISegmentedControl*)segment{
    if (segment.selectedSegmentIndex == Essay) {
        return self.essayIndexController;
    }
    else if (segment.selectedSegmentIndex == Serial){
        return self.serialIndexController;
    }
    else if (segment.selectedSegmentIndex == Question){
        return self.questionIndexController;
    }
    return nil;
}

- (ONEContentType)getContentTypeBySegment{
    return self.readingSegment.selectedSegmentIndex;
}


#pragma mark - fetch data

- (void)refreshWithCompletion:(void (^)())completion{
    
    [self fecthRealtimeDataFromURLWithCompletion:completion];
}


// TODO: add fetch data fail background tap action to refresh
- (void)fecthRealtimeDataFromURLWithCompletion:(void(^)())completion{
    
   
    [[ONEHTTPManager sharedManager]fetchReadingIndexWithCompletionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"error");
            
            return;
        }
        
        [self.essays removeAllObjects];
        [self.serials removeAllObjects];
        [self.questions removeAllObjects];
        
        NSDictionary* data = [responseObject objectForKey:@"data"];
        NSArray* essaysJson = [data objectForKey:@"essay"];
        NSArray* serialsJson = [data objectForKey:@"serial"];
        NSArray* questionsJson = [data objectForKey:@"question"];
        
        for (id essay in essaysJson) {
            ONEEssayDescription* essayDescription = [ONEEssayDescription yy_modelWithJSON:essay];
            [self.essays addObject:essayDescription];
        }
        
        for (id serial in serialsJson) {
            ONESerialDescription* serialDescription = [ONESerialDescription yy_modelWithJSON:serial];
            [self.serials addObject:serialDescription];
        }
        
        for (id question in questionsJson) {
            ONEQuestionDescription* questionDescription = [ONEQuestionDescription yy_modelWithJSON:question];
            [self.questions addObject:questionDescription];
        }
        
        if (completion) {
            completion();
        }
        
    }];
    
    
    
}




@end
