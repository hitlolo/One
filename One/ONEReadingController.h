//
//  ONEReadingController.h
//  One
//
//  Created by Lolo on 16/4/23.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ONEBaseController.h"


@interface ONEReadingController : ONEBaseController

- (void)refreshWithCompletion:(void (^)())completion;
@end
