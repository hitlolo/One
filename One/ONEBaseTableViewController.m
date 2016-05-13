//
//  ONEBaseTableViewController.m
//  One
//
//  Created by Lolo on 16/4/28.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "ONEBaseTableViewController.h"

@implementation ONEBaseTableViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTextSize) name:UIContentSizeCategoryDidChangeNotification object:nil];
    // Do any additional setup after loading the view.
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)changeTextSize{
    
}

@end
