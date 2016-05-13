//
//  ONEGalleryPageController.h
//  One
//
//  Created by Lolo on 16/4/8.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ONEBaseController.h"

@class ONEPainting;
@interface ONEGalleryPageController : ONEBaseController

@property(nonatomic,weak)ONEPainting *painting;
@property(nonatomic,assign)NSInteger index;

@end
