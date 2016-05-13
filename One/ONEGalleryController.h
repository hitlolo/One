//
//  ONEGalleryController.h
//  One
//
//  Created by Lolo on 16/4/15.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ONEGalleryController : UIViewController

- (void)triggerRefreshImmediately;
@end


//for child to find me
@interface UIViewController(ONEGalleryController)
- (ONEGalleryController*)galleryPageController;
@end