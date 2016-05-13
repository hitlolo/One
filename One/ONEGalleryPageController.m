//
//  ONEGalleryPageController.m
//  One
//
//  Created by Lolo on 16/4/8.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "ONEGalleryPageController.h"

#import "ONEPainting.h"
#import "ONELoadingView.h"
#import "ONEGalleryController.h"


@interface ONEGalleryPageController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIImageView *paintingImage;
@property (strong, nonatomic) IBOutlet UILabel *volumeLabel;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UITextView *mottoText;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *monthLabel;
@property (strong, nonatomic) IBOutlet UIButton *praiseButton;

@property (strong, nonatomic)UITapGestureRecognizer* refreshTap;
@property (strong, nonatomic)UITapGestureRecognizer* reloadImageTap;

@end

@implementation ONEGalleryPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self prepareRefreshAction];
    [self prepareReloadImageAction];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self beginLoadPainting];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeTextSize{
    
    self.volumeLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.authorLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.mottoText.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
}

#pragma mark - Prepare

- (void)prepareRefreshAction{
    
    self.refreshTap = [UITapGestureRecognizer new];
    self.refreshTap.numberOfTapsRequired = 1;
    [self.refreshTap addTarget:self action:@selector(triggerRefresh:)];
    [self.contentView addGestureRecognizer:self.refreshTap];
  
}

- (void)triggerRefresh:(UITapGestureRecognizer*)oneTap{
    [self.galleryPageController triggerRefreshImmediately];
}

- (void)prepareReloadImageAction{
    self.reloadImageTap = [UITapGestureRecognizer new];
    self.reloadImageTap.numberOfTapsRequired = 1;
    [self.reloadImageTap addTarget:self action:@selector(triggerReloadImage:)];
    [self.paintingImage addGestureRecognizer:self.reloadImageTap];
}

- (void)triggerReloadImage:(UITapGestureRecognizer*)oneTap{
    [self loadPaintingImage];
}


#pragma mark - load & show data

- (void)beginLoadPainting{

    if (self.painting == nil){
        [self.refreshTap setEnabled:YES];
        return;
    }
    
    self.navigationItem.title = self.painting.hp_title;
    
    [self.refreshTap setEnabled:NO];

    self.volumeLabel.text = self.painting.hp_title;
    self.authorLabel.text = self.painting.hp_author;
    self.dateLabel.text = [ONEDateHelper getMonthYear:self.painting.hp_makettime];
    self.monthLabel.text = [ONEDateHelper getDay:self.painting.hp_makettime];
    
    
    [self.praiseButton setTitle:[NSString stringWithFormat:@"%d",self.painting.praisenum] forState:UIControlStateNormal];
    
    [self loadMotto];
    [self loadPaintingImage];
}

- (void)loadPaintingImage{
    
    
    [self.reloadImageTap setEnabled:NO];
    
    NSURL* url = [NSURL URLWithString:self.painting.hp_img_url];
    
    __weak typeof(self)weakSelf = self;
    
    [self.paintingImage sd_setImageWithURL:url placeholderImage:one_placeHolder_image options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error) {
            [weakSelf.reloadImageTap setEnabled:NO];
        }
        
        else if (error){
            [weakSelf.reloadImageTap setEnabled:YES];

        }
    }];
}

- (void)loadMotto{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    
    NSDictionary *attribute;
    
    attribute = @{
                  NSParagraphStyleAttributeName : paragraphStyle,
                  NSForegroundColorAttributeName :[UIColor whiteColor],
                  NSFontAttributeName : [UIFont systemFontOfSize:15]
                  };
    self.mottoText.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 0);
    self.mottoText.attributedText = [[NSAttributedString alloc] initWithString:self.painting.hp_content attributes:attribute];
}


@end
