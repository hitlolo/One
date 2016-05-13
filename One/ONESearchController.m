//
//  ONESearchController.m
//  One
//
//  Created by Lolo on 16/5/12.
//  Copyright © 2016年 Lolo. All rights reserved.
//

#import "ONESearchController.h"

@interface ONESearchController ()<UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation ONESearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepare];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];
}

- (void)prepare{
    self.searchBar.delegate = self;
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
