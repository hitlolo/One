//
//  ONECollectionFlowlayout.m
//  One
//
//  Created by Lolo on 16/4/22.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "ONECollectionFlowlayout.h"

//@interface ONECollectionViewFlowLayoutInvalidationContext : UICollectionViewFlowLayoutInvalidationContext
//
//@end
//
//@implementation ONECollectionViewFlowLayoutInvalidationContext
//
//- (instancetype)init{
//    self = [super init];
//    if (self) {
//        self.invalidateFlowLayoutDelegateMetrics = YES;
//        self.invalidateFlowLayoutAttributes = YES;
//    }
//    return self;
//}
//
//@end


@implementation ONECollectionFlowlayout

//+ (Class)invalidationContextClass{
//    return [ONECollectionViewFlowLayoutInvalidationContext class];
//}

- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

@end
