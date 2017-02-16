//
//  MineAddressViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/1/18.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MineAddressViewController.h"
#import "MineAddressTableViewCell.h"
#import "MineAddressFootTableViewCell.h"
#import "AddReceiveAddressViewController.h"
@interface MineAddressViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *addressListTableView;

@end

@implementation MineAddressViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    Manager *manager = [Manager shareInstance];
    
    //如果没有收货地址，那么就请求
    if (manager.receiveAddressArr == nil || manager.receiveAddressArr.count == 0) {
        [manager receiveAddressListWithUserIdOrReceiveId:manager.memberInfoModel.u_id withAddressListSuccess:^(id successResult) {
            [self.addressListTableView reloadData];
        } withAddressListFail:^(NSString *failResultStr) {
            NSLog(@"失败");
        }];
    }
    
}


#pragma mark - tableView delegate -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [Manager shareInstance].receiveAddressArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section > 0) {
        return 10;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 47;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    MineAddressFootTableViewCell *footViewCell = [tableView dequeueReusableCellWithIdentifier:@"mineAddressFootCell"];
    Manager *manager =  [Manager shareInstance];
    ReceiveAddressModel *tempAddressModel = manager.receiveAddressArr[section];
    
    footViewCell.defaultAddressButton.indexForButton = [NSIndexPath indexPathForRow:0 inSection:section];
    footViewCell.editAddressButton.indexForButton = [NSIndexPath indexPathForRow:0 inSection:section];
    footViewCell.deleteAddressButton.indexForButton = [NSIndexPath indexPathForRow:0 inSection:section];


    [footViewCell updateMineAddressFootCellWithModel:tempAddressModel];
    
    return footViewCell;
}
//默认地址选择按钮
- (IBAction)defaltButtonAction:(IndexButton *)sender {
    Manager *manager =  [Manager shareInstance];
    ReceiveAddressModel *tempAddressModel = manager.receiveAddressArr[sender.indexForButton.section];

    [manager defaultReceiveAddressWithAddressModel:tempAddressModel withDefaultSuccess:^(id successResult) {
        
        [self.addressListTableView reloadData];
        
    } withDefaultFail:^(NSString *failResultStr) {
        
    }];
    
}
//编辑按钮
- (IBAction)editButtonAction:(IndexButton *)sender {
    Manager *manager =  [Manager shareInstance];
    ReceiveAddressModel *tempAddressModel = manager.receiveAddressArr[sender.indexForButton.section];
    [self performSegueWithIdentifier:@"mineAddressToDetailReceiveVC" sender:tempAddressModel];
}

//删除按钮
- (IBAction)deleteButtonAction:(IndexButton *)sender {
    Manager *manager =  [Manager shareInstance];
    ReceiveAddressModel *tempAddressModel = manager.receiveAddressArr[sender.indexForButton.section];
    [manager deleteReceiveAddressWithAddressModel:tempAddressModel withDeleteAddressSuccess:^(id successResult) {

        [self.addressListTableView reloadData];
//        [self.addressListTableView deleteSections:[NSIndexSet indexSetWithIndex:sender.indexForButton.section] withRowAnimation:UITableViewRowAnimationLeft];
        
    } withDeleteAddressFail:^(NSString *failResultStr) {
        
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mineAddressCell" forIndexPath:indexPath];

    Manager *manager =  [Manager shareInstance];
    ReceiveAddressModel *tempAddressModel = manager.receiveAddressArr[indexPath.section];
    
    [cell updateMineAddressCellWithModel:tempAddressModel];
    
    return cell;
    
}

#pragma mark - 添加收货地址 -
- (IBAction)addAddressButtonAction:(UIButton *)sender {
    [self performSegueWithIdentifier:@"mineAddressToDetailReceiveVC" sender:nil];
    
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
    
    Manager *manager = [Manager shareInstance];
    if ([segue.identifier isEqualToString:@"mineAddressToDetailReceiveVC"]) {
        AddReceiveAddressViewController *addReceiveAddressVC = [segue destinationViewController];
        if (sender != nil && [sender isKindOfClass:[ReceiveAddressModel class]]) {
            
            addReceiveAddressVC.tempReceiveAddressModel = sender;
        }
        
        addReceiveAddressVC.refreshAddressListBlock = ^(NSString *motifyOrAddModelStr){
            //重新刷新列表
            [manager receiveAddressListWithUserIdOrReceiveId:manager.memberInfoModel.u_id withAddressListSuccess:^(id successResult) {
                
                //将修改或者添加的地址作为默认地址，进行标记
                for (ReceiveAddressModel *tempModel in manager.receiveAddressArr) {
                    if ([tempModel.receiverID isEqualToString:motifyOrAddModelStr]) {
                        tempModel.isSelect = YES;
                    }
                }
                //刷新列表
                [self.addressListTableView reloadData];
                
            } withAddressListFail:^(NSString *failResultStr) {
                NSLog(@"刷新失败");
            }];
        };
        
        
    }

    
}


@end
