//
//  ONEGalleryCollectionController.m
//  One
//
//  Created by Lolo on 16/4/22.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "ONEGalleryCollectionController.h"
#import "ONEGalleryPageController.h"
#import "ONEGalleryCell.h"
#import "ONEPainting.h"
#import "ONELoadingView.h"


@interface ONEGalleryCollectionController ()

@property (strong, nonatomic) IBOutlet ONELoadingView *loadingView;
@property (strong, nonatomic) NSMutableArray* paintings;


@end

@implementation ONEGalleryCollectionController

static NSString * const reuseIdentifier = @"paintingcell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepare];
    // Uncomment the following line to preserve selection between presentations
    
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];

    [(UICollectionViewFlowLayout*)self.collectionViewLayout setEstimatedItemSize:CGSizeMake(140, 200)];
    
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTextSize) name:UIContentSizeCategoryDidChangeNotification object:nil];
    // Do any additional setup after loading the view.
}


- (void)dealloc{
    //[[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepare{
    self.navigationItem.title = self.selectedDate;
    self.clearsSelectionOnViewWillAppear = NO;

    [self beginLoading];
    [self prepareData];
}

- (void)prepareData{
    [self fetchRealtimeDataFromURL];
}

- (void)beginLoading{
    [self.view addSubview:self.loadingView];
    [self.loadingView setCenter:self.view.center];
    [self.loadingView startAnimating];
}

- (void)endLoading{
    [self.loadingView stopAnimating];
    [self.loadingView removeFromSuperview];
}


- (NSMutableArray*)paintings{
    if (_paintings == nil) {
        _paintings = [NSMutableArray array];
    }
    return _paintings;
}

- (void)fetchRealtimeDataFromURL{
    [[ONEHTTPManager sharedManager]fetchPaintingsByMonth:self.selectedDate completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            [self.paintings removeAllObjects];
            NSArray* objects = [responseObject objectForKey:@"data"];
            
            for (id item in objects) {
                ONEPainting* painting = [ONEPainting yy_modelWithJSON:item];
                [self.paintings addObject:painting];
            }
            
            [self.collectionView reloadData];
            [self endLoading];
        }
        
        if (error) {
            NSLog(@"%@",error);
            [self endLoading];
        }
        

    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self.paintings count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ONEGalleryCell *cell = (ONEGalleryCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    ONEPainting* painting = self.paintings[indexPath.row];
    [cell setPainting:painting];
    // Configure the cell
    return cell;
}

#pragma mark <UICollectionViewDelegate>


// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}



// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self pushPaintingDetail:indexPath];
}


/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/


- (void)pushPaintingDetail:(NSIndexPath*)indexPath{
    
    UIStoryboard*  storyboard = [UIStoryboard storyboardWithName:@"Gallery" bundle:[NSBundle mainBundle]];
    ONEGalleryPageController* viewController = [storyboard instantiateViewControllerWithIdentifier:@"gallerypage"];
    viewController.painting = self.paintings[indexPath.row];
    [self.navigationController pushViewController: viewController animated:YES];
}

- (void)changeTextSize{
    //[self.collectionView invalidateIntrinsicContentSize];
          //
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    [(UICollectionViewFlowLayout*)self.collectionViewLayout invalidateLayout];
    [self.collectionView reloadData];
    //[(UICollectionViewFlowLayout*)self.collectionViewLayout invalidateLayout];

  
}

@end
