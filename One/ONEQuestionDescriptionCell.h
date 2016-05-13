//
//  ONEQuestionDescriptionCell.h
//  One
//
//  Created by Lolo on 16/5/1.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ONEArticleDescription;
@interface ONEQuestionDescriptionCell : UITableViewCell
- (void)setArticle:(id<ONEArticleDescription>)article;
@end
