//
//  ProductListViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/1/9.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "ProductListViewController.h"
#import "Manager.h"
@interface ProductListViewController ()

@end

@implementation ProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //网络请求
    Manager *manager = [Manager shareInstance];
    if (self.tempFuzzySearchModel != nil) {
        [manager httpFuzzySearchProductInfoWithFuzzyModel:self.tempFuzzySearchModel withPageIndex:1 withSearchSuccess:^(id successResult) {
            
        } withSearchFail:^(NSString *failResultStr) {
            
        }];

    }
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
