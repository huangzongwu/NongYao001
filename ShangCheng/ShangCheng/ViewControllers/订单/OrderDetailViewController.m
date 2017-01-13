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
#import "ProductDetailViewController.h"
#import "LogisticsViewController.h"
#import "CommentViewController.h"
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

//子订单TableView
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;

//底部商品总额等信息数据
@property (nonatomic,strong)NSArray *cellTwoDataSource;

//底部view的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;

@end

@implementation OrderDetailViewController
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //通知，重新获取收货地址
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAddressListAction:) name:@"" object:nil];
    }
    return self;
}

- (void)refreshAddressListAction:(NSNotification *)sender {
    //刷新
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //更新头部
    [self updateHeaderView];
//self.tempSupOrderModel.p_o_price_total
    
    NSDictionary *dic1 =@{@"商品总额":self.tempSupOrderModel.p_o_price_total};
    NSDictionary *dic2 =@{@"优惠金额":self.tempSupOrderModel.p_discount};
    NSDictionary *dic3 =@{@"数量":self.tempSupOrderModel.p_num};
    NSDictionary *dic4 =@{@"下单时间":self.tempSupOrderModel.p_time_create};

    self.cellTwoDataSource = @[dic1,dic2,dic3,dic4];
    
    if ([self.tempSupOrderModel.p_status isEqualToString:@"0"] || [self.tempSupOrderModel.p_status isEqualToString:@"1B"]) {
        self.bottomViewHeight.constant = 40;
    }else {
        self.bottomViewHeight.constant = 0;
    }
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
        return 4;
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
//        if ([tempSonOrderModel.o_status isEqualToString:@"0"] || [tempSonOrderModel.o_status isEqualToString:@"1A"] || [tempSonOrderModel.o_status isEqualToString:@"1B"]) {
//            return 1;
//        }else {
            return 40;
//        }
        
    }else{
        return 60;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    //返回值就是区页脚。那么我们就让他返回footViewCell
    if (section < self.tempSupOrderModel.subOrderArr.count) {
        OrderDetailFootOneTableViewCell *footViewCellOne = [tableView dequeueReusableCellWithIdentifier:@"footViewOne"];
        footViewCellOne.tempSonOrder = self.tempSupOrderModel.subOrderArr[section];
        [footViewCellOne updateOrderDetailFootOneCell:self.tempSupOrderModel.subOrderArr[section]];
        
        footViewCellOne.buttonActionTypeBlock = ^(IndexButton *footButton,NSInteger typeInt){
            //对子订单的操作
            SonOrderModel *tempSonOrder = self.tempSupOrderModel.subOrderArr[footButton.indexForButton.section];
            [self sonOrderActionWithTypeInt:typeInt withSonOrder:tempSonOrder];
            
        };
        
        return footViewCellOne;

    }else {
        OrderDetailFootTwoTableViewCell *footViewCellTwo = [tableView dequeueReusableCellWithIdentifier:@"footViewTwo"];
        
        [footViewCellTwo updateOrderDetailTwoFootCell:self.tempSupOrderModel];
        return footViewCellTwo;

    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section < self.tempSupOrderModel.subOrderArr.count) {
        OrderDetailOneTableViewCell *oneCell = [tableView dequeueReusableCellWithIdentifier:@"orderDetailOneCell" forIndexPath:indexPath];
        [oneCell updateOrderDetailOneCellWithSonOrder:self.tempSupOrderModel.subOrderArr[indexPath.section]];
        
        return oneCell;
        
    }else{
        OrderDetailTwoTableViewCell *twoCell = [tableView dequeueReusableCellWithIdentifier:@"orderDetailTwoCell" forIndexPath:indexPath];
        [twoCell updateOrderDetailTwoCellDataSourceDic:self.cellTwoDataSource[indexPath.row]];
        return twoCell;
    }
    
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.tempSupOrderModel.subOrderArr.count) {
        SonOrderModel *tempSonOrderModel = self.tempSupOrderModel.subOrderArr[indexPath.section];
        [self performSegueWithIdentifier:@"orderToDetailVC" sender:tempSonOrderModel.o_product_id];
        
        
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 子订单的操作 -
- (void)sonOrderActionWithTypeInt:(NSInteger)typeInt withSonOrder:(SonOrderModel *)tempSonOrder {
    Manager *manager = [Manager shareInstance];
    
    switch (typeInt) {
        case 1:
        {
            [manager cancelSonOrderWithUserId:manager.memberInfoModel.u_id withOrderID:tempSonOrder.o_id withCancelMessage:@"不喜欢" withCancelSuccessResult:^(id successResult) {
                //取消成功后
                self.tempSupOrderModel = successResult;
                //刷新UI
                [self.detailTableView reloadData];
                
                //发送通知到订单列表界面，刷新列表数据
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrderList" object:self userInfo:nil];
                
            } withCancelFailResult:^(NSString *failResultStr) {
                NSLog(@"取消失败");
            }];
        }
            break;
        case 2:
            NSLog(@"物流");
            //跳转到物流界面
            [self performSegueWithIdentifier:@"orderDetailToLogisticsVC" sender:tempSonOrder];
            break;
        case 3:
            NSLog(@"确认收货");
            break;
        case 4:
            NSLog(@"立即评价");
            [self performSegueWithIdentifier:@"orderDetailToCommentVC" sender:tempSonOrder];
            break;
        case 5:
            NSLog(@"详情");
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 底部的view上的两个按钮的功能，这两个操作是对这个父订单的操作 -
//底部  去付款
- (IBAction)paySupOrderAction:(UIButton *)sender {
    
    
}
//底部  取消订单
- (IBAction)cancelSupOrderAction:(UIButton *)sender {
    Manager *manager = [Manager shareInstance];
    
//    SupOrderModel *selectModel = modelArr[buttonIndex.section];
    [manager cancelSupOrderWithUserID:manager.memberInfoModel.u_id wiOrderID:self.tempSupOrderModel.p_id withCancelSuccessResult:^(id successResult) {
        AlertManager *alertM = [AlertManager shareIntance];
        [alertM showAlertViewWithTitle:nil withMessage:@"取消订单成功" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
            //取消订单后，刷新 当前TableView。其他的在切换的时候刷新
            self.tempSupOrderModel = successResult;
            [self.detailTableView reloadData];
            //取消后，底部按钮view消失
            self.bottomViewHeight.constant = 0;
            //block
            self.refreshOrderListBlock();
        }];
        
        
    } withCancelFailResult:^(NSString *failResultStr) {
        
    }];

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //到产品详情中
    if ([segue.identifier isEqualToString:@"orderToDetailVC"]) {
        ProductDetailViewController *productDetailVC = [segue destinationViewController];
        productDetailVC.productID = sender;
        

    }
    //物流
    if ([segue.identifier isEqualToString:@"orderDetailToLogisticsVC"]) {
        LogisticsViewController *logisticsVC = [segue destinationViewController];
        logisticsVC.tempSonOrderModel = sender;
        
    }
    
    //评价
    if ([segue.identifier isEqualToString:@"orderDetailToCommentVC"]) {
        CommentViewController *commentVC = [segue destinationViewController];
        commentVC.tempSonOrderModel = sender;
        
    }
    
}


@end
