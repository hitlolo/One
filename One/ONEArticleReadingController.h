//
//  ONEArticleReadingController.h
//  One
//
//  Created by Lolo on 16/5/1.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ONEBaseController.h"

@protocol ONEArticlePageDelegate <NSObject>
- (void)articleDidChangeToPageIndex:(NSInteger)index pageCount:(NSInteger)count;
- (void)articleDidFinishLoad:(id<ONEArticle>)article;
@end

@protocol ONEArticleDescription;
@interface ONEArticleReadingController : ONEBaseController

@property(nonatomic,strong)id<ONEArticleDescription> articleDescription;
@property(nonatomic,weak)id<ONEArticlePageDelegate> delegate;

- (void)gotoFirstPage;
@end
