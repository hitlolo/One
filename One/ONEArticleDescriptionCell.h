//
//  ONEEssayDescrptionCell.h
//  One
//
//  Created by Lolo on 16/4/23.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ONEArticleDescription;
@interface ONEArticleDescriptionCell : UITableViewCell

- (void)setArticle:(id<ONEArticleDescription>)article;

@end
