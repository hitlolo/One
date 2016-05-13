//
//  ONESerialReadingController.h
//  One
//
//  Created by Lolo on 16/4/30.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ONEArticleDescription;
@interface ONESerialReadingController : UIViewController

@property(nonatomic,strong)id<ONEArticleDescription> articleDescription;
@end
