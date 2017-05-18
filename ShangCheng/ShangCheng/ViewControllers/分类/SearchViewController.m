//
//  SearchViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/3/3.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "SearchViewController.h"
#import "ProductListViewController.h"
#import "PestsListViewController.h"
#import "SearchBarTextField.h"

@interface SearchViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)SearchBarTextField *searchBarTextField;
@end

@implementation SearchViewController
//取消
- (IBAction)rightBarButtonAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

//    [self performSegueWithIdentifier:@"searchToListVC" sender:nil];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //加载 搜索框
    self.searchBarTextField = [[[NSBundle mainBundle] loadNibNamed:@"SearchBarTextField" owner:self options:nil] firstObject];
    self.searchBarTextField.searchTextField.delegate = self;
    self.navigationItem.titleView = self.searchBarTextField;
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.text.length > 0) {
        [textField resignFirstResponder];

        if (self.productOrPests == Product) {
            [self performSegueWithIdentifier:@"searchToListVC" sender:@[@"SearchProduct",textField.text]];

        }
        if (self.productOrPests == Pests) {
            [self performSegueWithIdentifier:@"searchToPestsListVC" sender:@[@"SearchPests",textField.text]];

        }
        

        
    }

    return YES;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.searchBarTextField.searchTextField resignFirstResponder];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"searchToListVC"]) {
        ProductListViewController *productListVC = [segue destinationViewController];
        
        //搜索产品
        if ([[sender objectAtIndex:0] isEqualToString:@"SearchProduct"]) {
            productListVC.tempKeyword = [sender objectAtIndex:1];
            productListVC.productSearchOrType = SearchProduct;
        }
        //分类产品
        if([[sender objectAtIndex:0] isEqualToString:@"TypeProduct"]){
            productListVC.tempCode = [sender objectAtIndex:1];
            productListVC.productSearchOrType = TypeProduct;
        }
        
    }
    
    if ([segue.identifier isEqualToString:@"searchToPestsListVC"]) {
        PestsListViewController *pestsListVC = [segue destinationViewController];

        //搜索病虫害
        if([[sender objectAtIndex:0] isEqualToString:@"SearchPests"]){
            pestsListVC.tempKeyword = [sender objectAtIndex:1];
            pestsListVC.pestsIsSearchOrType = SearchPests;
            pestsListVC.showTitleStr = [NSString stringWithFormat:@"%@病虫害",[sender objectAtIndex:1]];
        }

        //分类病虫害
        if([[sender objectAtIndex:0] isEqualToString:@"TypePests"]){
            pestsListVC.tempCode = [sender objectAtIndex:1];
            pestsListVC.pestsIsSearchOrType = TypePests;
            pestsListVC.showTitleStr = [NSString stringWithFormat:@"%@病虫害",[sender objectAtIndex:2] ];

        }

    }
}


@end
