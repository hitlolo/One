//
//  HLTreeView.h
//  One
//
//  Created by Lolo on 16/4/18.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLRefreshView.h"
@interface HLTreeView : UIImageView<HLRefreshView>

@property(nonatomic, assign)CGFloat progress;

@end
