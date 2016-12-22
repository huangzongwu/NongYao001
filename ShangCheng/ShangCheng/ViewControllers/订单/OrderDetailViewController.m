//
//  OrderDetailViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/20.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailOneTableViewCell.h"
#import "OrderDetailTwoTableViewCell.h"
#import "OrderDetailFootOneTableViewCell.h"
#import "OrderDetailFootTwoTableViewCell.h"

@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
//头部View的控件
//父订单编号
@property (weak, nonatomic) IBOutlet UILabel *supOrderCodeLabel;
//父订单状态
@property (weak, nonatomic) IBOutlet UILabel *supOrderStatusLabel;
//收货人
@property (weak, nonatomic) IBOutlet UILabel *consignorLabel;
//收货人手机
@property (weak, nonatomic) IBOutlet UILabel *consignorMobileLabel;
//收货地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self updateHeaderView];
    
    
}

//刷新头部视图的信息：父订单号 状态 收货人信息等
- (void)updateHeaderView {
    //父订单号
    self.supOrderCodeLabel.text = self.tempSupOrderModel.p_code;
    //父订单状态
    self.supOrderStatusLabel.text = self.tempSupOrderModel.statusvalue;
    //收货人
    self.consignorLabel.text = self.tempSupOrderModel.p_truename;
    //收货人手机
    if (self.tempSupOrderModel.p_mobile.length > 0) {
        self.consignorMobileLabel.text = self.tempSupOrderModel.p_mobile;
    }else if (self.tempSupOrderModel.p_telephone.length > 0) {
        self.consignorMobileLabel.text = self.tempSupOrderModel.p_telephone;
    }
    //收货地址
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",self.tempSupOrderModel.capitalname,self.tempSupOrderModel.cityname,self.tempSupOrderModel.countyname,self.tempSupOrderModel.p_address];
}

#pragma mark - TableView delegate -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //子订单个数 + 1；  那个+1就是商品总额优惠金额支付时间等底部的cell
    return self.tempSupOrderModel.subOrderArr.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < self.tempSupOrderModel.subOrderArr.count) {
        return 1;
    }else {
        return 6;
    }
    
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.tempSupOrderModel.subOrderArr.count) {
        return 125;
        
    }else {
        return 40;
    }
}

//footView高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section < self.tempSupOrderModel.subOrderArr.count) {
        
        //待付款和待确认的没有footView
        SonOrderModel *tempSonOrderModel = self.tempSupOrderModel.subOrderArr[section];
        if ([tempSonOrderModel.o_status isEqualToString:@"0"] || [tempSonOrderModel.o_status isEqualToString:@"1A"] || [tempSonOrderModel.o_status isEqualToString:@"1B"]) {
            return 0;
        }else {
            return 40;
        }
        
    }else{
        return 60;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    //返回值就是区页脚。那么我们就让他返回footViewCell
    if (section < self.tempSupOrderModel.subOrderArr.count) {
        OrderDetailFootOneTableViewCell *footViewCellOne = [tableView dequeueReusableCellWithIdentifier:@"footViewOne"];
        
        
        
        return footViewCellOne;

    }else {
        OrderDetailFootOneTableViewCell *footViewCellTwo = [tableView dequeueReusableCellWithIdentifier:@"footViewTwo"];
        
        
        return footViewCellTwo;

    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section < self.tempSupOrderModel.subOrderArr.count) {
        OrderDetailOneTableViewCell *oneCell = [tableView dequeueReusableCellWithIdentifier:@"orderDetailOneCell" forIndexPath:indexPath];
        [oneCell updateOrderDetailOneCellWithSonOrder:self.tempSupOrderModel.subOrderArr[indexPath.section]];
        
        return oneCell;
        
    }else{
        OrderDetailOneTableViewCell *twoCell = [tableView dequeueReusableCellWithIdentifier:@"orderDetailTwoCell" forIndexPath:indexPath];
        return twoCell;
    }
    
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
