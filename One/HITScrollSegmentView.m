//
//  HITScrollSegmentView.m
//  HITScrollListController
//
//  Created by Lolo on 16/5/12.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "HITScrollSegmentView.h"
#import "HITScrollSegmentItem.h"
#import "HITReadColumnProvider.h"

@interface HITScrollSegmentView ()

@property(nonatomic,strong)UIScrollView* segmentScroll;
@property(nonatomic,strong)UIStackView* segmentStack;
@property(nonatomic,strong)UIButton* expandButton;
@property(nonatomic,assign)BOOL constriantsReady;
@property(nonatomic,assign)NSInteger highLightedIndex;
@end

@implementation HITScrollSegmentView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self prepare];
        [self updateConstraints];
    }
    return self;
}


- (void)prepare{
    //self.backgroundColor = [UIColor colorWithRed:0.992 green:0.996 blue:0.9496 alpha:1.0];
    _titleDefaultColor = [UIColor darkGrayColor];
    _titleHighlightedColor = [UIColor colorWithRed:0.8196 green:0.7333 blue:0.6314 alpha:1.0];
    _constriantsReady = NO;
    
    _highLightedIndex = -1;
    
    
    _segmentScroll = [UIScrollView new];
    _segmentScroll.showsHorizontalScrollIndicator = NO;
    _segmentScroll.showsVerticalScrollIndicator = NO;
    [self addSubview:_segmentScroll];
    
    _segmentStack = [UIStackView new];
    _segmentStack.axis = UILayoutConstraintAxisHorizontal;
    _segmentStack.alignment = UIStackViewAlignmentCenter;
    _segmentStack.distribution = UIStackViewDistributionFillEqually;
    _segmentStack.spacing = 20.0f;
    _segmentStack.layoutMarginsRelativeArrangement = YES;
    _segmentStack.layoutMargins = UIEdgeInsetsMake(8 , 8, 8, 8);
    
    [_segmentScroll addSubview:_segmentStack];
    
    _expandButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_expandButton addTarget:self action:@selector(expandButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_expandButton setImage:[UIImage imageNamed:@"nav_share_btn_normal"] forState:UIControlStateNormal];
    
    [self addSubview:_expandButton];
    
    
    
//    _segmentScroll.translatesAutoresizingMaskIntoConstraints = NO;
//    [_segmentScroll.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
//    [_segmentScroll.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
//    [_segmentScroll.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
//    [_segmentScroll.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-50].active = YES;
//    [_segmentScroll.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
//    
//    _segmentStack.translatesAutoresizingMaskIntoConstraints = NO;
//    [_segmentStack.topAnchor constraintEqualToAnchor:_segmentScroll.topAnchor].active = YES;
//    [_segmentStack.bottomAnchor constraintEqualToAnchor:_segmentScroll.bottomAnchor].active = YES;
//    [_segmentStack.leadingAnchor constraintEqualToAnchor:_segmentScroll.leadingAnchor].active = YES;
//    [_segmentStack.trailingAnchor constraintLessThanOrEqualToAnchor:_segmentScroll.trailingAnchor].active = YES;
//    [_segmentStack.centerYAnchor constraintEqualToAnchor:_segmentScroll.centerYAnchor].active = YES;
//    //[_segmentStack.widthAnchor constraintGreaterThanOrEqualToAnchor:self.widthAnchor multiplier:1.0].active = YES;
//    
//    _expandButton.translatesAutoresizingMaskIntoConstraints = NO;
//    [_expandButton.widthAnchor constraintEqualToConstant:50.0].active = YES;
//    [_expandButton.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;
//    [_expandButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
//    [_expandButton.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
//    _constriantsReady = YES;

}


- (void)updateConstraints{
    
    if (!_constriantsReady) {
        
        _segmentScroll.translatesAutoresizingMaskIntoConstraints = NO;
        [_segmentScroll.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
        [_segmentScroll.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
        [_segmentScroll.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
        [_segmentScroll.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-50].active = YES;
        [_segmentScroll.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
        
        _segmentStack.translatesAutoresizingMaskIntoConstraints = NO;
        [_segmentStack.topAnchor constraintEqualToAnchor:_segmentScroll.topAnchor].active = YES;
        [_segmentStack.bottomAnchor constraintEqualToAnchor:_segmentScroll.bottomAnchor].active = YES;
        [_segmentStack.leadingAnchor constraintEqualToAnchor:_segmentScroll.leadingAnchor constant:8].active = YES;
        [_segmentStack.trailingAnchor constraintEqualToAnchor:_segmentScroll.trailingAnchor constant:-8].active = YES;
        [_segmentStack.centerYAnchor constraintEqualToAnchor:_segmentScroll.centerYAnchor].active = YES;
        //[_segmentStack.widthAnchor constraintGreaterThanOrEqualToAnchor:self.widthAnchor multiplier:1.0].active = YES;
        
        _expandButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_expandButton.widthAnchor constraintEqualToConstant:50.0].active = YES;
        [_expandButton.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;
        [_expandButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
        [_expandButton.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
        _constriantsReady = YES;

    }
    [super updateConstraints];

}


- (void)setHighLightedIndex:(NSInteger)index{
    
    NSArray* segmentItems = [_segmentStack arrangedSubviews];
    
    HITScrollSegmentItem* newItem = [segmentItems objectAtIndex:index];
    HITScrollSegmentItem* oldItem = nil;
    
    CGPoint scale = [newItem scaleFactor];

    if (_highLightedIndex != -1 && _highLightedIndex <= [segmentItems count] - 1) {
        oldItem = [segmentItems objectAtIndex:_highLightedIndex];
    }
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        oldItem.textColor = _titleDefaultColor;
        newItem.textColor = _titleHighlightedColor;
        oldItem.transform = CGAffineTransformMakeScale(1.0, 1.0);
        newItem.transform = CGAffineTransformMakeScale(scale.x, scale.y);
    } completion:^(BOOL finished) {
//        newItem.font = [newItem highlightedFont];
//        oldItem.font = [oldItem defaultFont];
        [oldItem setHighlighted:NO];
        [newItem setHighlighted:YES];
//        oldItem.transform = CGAffineTransformMakeScale(1.0, 1.0);
//        newItem.transform = CGAffineTransformMakeScale(1.0, 1.0);
        if (finished) {
            CGPoint center = [_segmentScroll convertPoint:newItem.center toView:_segmentScroll];
            CGPoint offset = [_segmentScroll contentOffset];
            CGSize size = [_segmentScroll contentSize];
            if (center.x > _segmentScroll.center.x && (size.width - center.x > _segmentScroll.center.x)) {
                offset.x = center.x - _segmentScroll.center.x;
                [_segmentScroll setContentOffset:offset animated:YES];
            }
            else if (center.x < _segmentScroll.center.x){
                offset.x = 0;
                [_segmentScroll setContentOffset:offset animated:YES];
            }
            else if ((size.width - center.x < _segmentScroll.center.x) && _segmentStack.bounds.size.width > _segmentScroll.bounds.size.width){
                offset.x = size.width - _segmentScroll.bounds.size.width;
                [_segmentScroll setContentOffset:offset animated:YES];
            }
        }
        
    }];
    
    
    _highLightedIndex = index;
 
}

- (void)highLightSegmentAtIndex:(NSInteger)index{
    
    NSArray* segmentItems = [_segmentStack arrangedSubviews];
    if (index > [segmentItems count] - 1 || index < 0 ) {
        return;
    }
    [self setHighLightedIndex:index];
    
}


- (void)reloadData{

    NSArray* oldSegmentItem = [self.segmentStack arrangedSubviews];
    [oldSegmentItem enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.segmentStack removeArrangedSubview:obj];
        [obj removeFromSuperview];
        obj = nil;
    }];
    
    [self loadSegments];
}

- (void)loadSegments{

    if (self.segmentDatasource) {
        NSArray* segmentTitles = [self.segmentDatasource segmentTitlesForScrollSegmentView];
        [segmentTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            id<HITReadColumn> column = obj;
            NSString* title = [column title];
            HITScrollSegmentItem* segmentItem = [self createSegmentItem:title atIndex:idx];
            [self.segmentStack addArrangedSubview:segmentItem];
        }];
    }
    
}

- (HITScrollSegmentItem*)createSegmentItem:(NSString*)title atIndex:(NSInteger)index{
    HITScrollSegmentItem* item = [HITScrollSegmentItem new];
    item.text = title;
    item.textColor = _titleDefaultColor;
    item.highlightedTextColor = _titleHighlightedColor;
    item.index = index;
    
    UITapGestureRecognizer* tap = [UITapGestureRecognizer new];
    tap.numberOfTapsRequired = 1;
    [tap addTarget:self action:@selector(segmentSelected:)];
    
    [item addGestureRecognizer:tap];
    [item setUserInteractionEnabled:YES];
    return item;
}

- (void)segmentSelected:(UITapGestureRecognizer*)tap{
    
    HITScrollSegmentItem* item = (HITScrollSegmentItem*)tap.view;
    if (self.segmentDelegate) {
        [self.segmentDelegate segmentItemDidSelected:item.index];
    }
}

- (void)expandButtonClicked:(UIButton*)sender{
    if (self.segmentDelegate) {
        [self.segmentDelegate segmentEditDidSelected:sender];
    }
}

@end
