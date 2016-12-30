//
//  ReceiveAddressViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/29.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "ReceiveAddressViewController.h"
#import "ReceiveAddressTableViewCell.h"
#import "AddReceiveAddressViewController.h"
#import "ReceiveAddressModel.h"
@interface ReceiveAddressViewController ()<UITableViewDataSource,UITableViewDelegate>


@end

@implementation ReceiveAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - tableView delegate -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.receiveAddressArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReceiveAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"receiveCell" forIndexPath:indexPath];
    ReceiveAddressModel *tempModel = self.receiveAddressArr[indexPath.section];
    
    [cell updateReceiveAddressCell:tempModel withIndex:indexPath];
    //按钮点击block
    cell.rightNextBlock = ^(NSIndexPath *rightNextBlock) {
        ReceiveAddressModel *selectModel = self.receiveAddressArr[rightNextBlock.section];
        //编辑地址
        [self performSegueWithIdentifier:@"receiveListToDetailReceiveVC" sender:selectModel];
        
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //选中了这个地址
    ReceiveAddressModel *tempModel = self.receiveAddressArr[indexPath.section];
    if (self.selectModelBlock != nil) {
        self.selectModelBlock(tempModel);
        //返回
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//新增地址
- (IBAction)addReceiveAddressAction:(UIButton *)sender {
    [self performSegueWithIdentifier:@"receiveListToDetailReceiveVC" sender:nil];


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
    if ([segue.identifier isEqualToString:@"receiveListToDetailReceiveVC"]) {
        AddReceiveAddressViewController *addReceiveAddressVC = [segue destinationViewController];
        if (sender != nil && [sender isKindOfClass:[ReceiveAddressModel class]]) {
            addReceiveAddressVC.tempReceiveAddressModel = sender;

        }
    }

}


@end
