//
//  HLAnimationView.h
//  HLRefreshView
//
//  Created by Lolo on 15/12/6.
//  Copyright © 2015年 Lolo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLRefreshView.h"
#import "HLArrowShapeLayer.H"

@interface HLArrowView : UIView<HLRefreshView>

@property(nonatomic, assign)CGFloat progress;
@property(nonatomic, assign)ShapeType shapeType;
@end
