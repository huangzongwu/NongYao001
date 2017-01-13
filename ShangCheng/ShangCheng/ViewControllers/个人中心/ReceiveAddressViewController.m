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
@property (weak, nonatomic) IBOutlet UITableView *receiveAddressTableView;


@end

@implementation ReceiveAddressViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    if (self.selectModelBlock != nil) {
        self.selectModelBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 让cell自适应高度
    self.receiveAddressTableView.rowHeight = UITableViewAutomaticDimension;
    //设置估算高度
    self.receiveAddressTableView.estimatedRowHeight = 44;
}

#pragma mark - tableView delegate -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   
    return [Manager shareInstance].receiveAddressArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 12.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Manager *manager = [Manager shareInstance];
    ReceiveAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"receiveCell" forIndexPath:indexPath];
    ReceiveAddressModel *tempModel = manager.receiveAddressArr[indexPath.section];
    
    [cell updateReceiveAddressCell:tempModel withIndex:indexPath];
    //按钮点击block
    cell.rightNextBlock = ^(NSIndexPath *rightNextBlock) {
        ReceiveAddressModel *selectModel = manager.receiveAddressArr[rightNextBlock.section];
        //编辑地址
        [self performSegueWithIdentifier:@"receiveListToDetailReceiveVC" sender:selectModel];

        
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Manager *manager = [Manager shareInstance];
    //选中了这个地址,现将所有的选择状态都变为no
    for (ReceiveAddressModel *tempModel in manager.receiveAddressArr) {
        tempModel.isSelect = NO;
    }
    //将选中的那个状态变为YES
    ReceiveAddressModel *selectModel = manager.receiveAddressArr[indexPath.section];
    selectModel.isSelect = YES;
    
    if (self.selectModelBlock != nil) {
        self.selectModelBlock();
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
    Manager *manager = [Manager shareInstance];
    if ([segue.identifier isEqualToString:@"receiveListToDetailReceiveVC"]) {
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
                [self.receiveAddressTableView reloadData];
                
            } withAddressListFail:^(NSString *failResultStr) {
                NSLog(@"刷新失败");
            }];
        };

        
    }
}


@end
