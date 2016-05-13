//
//  ONECommentsController.h
//  One
//
//  Created by Lolo on 16/4/26.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ONEBaseTableViewController.h"

@protocol ONEArticleDescription;
@interface ONECommentsController : ONEBaseTableViewController

@property(nonatomic,strong)id<ONEArticleDescription> articleDescription;

@end
