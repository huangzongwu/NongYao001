//
//  OrderListOneTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2016/12/8.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupOrderModel.h"
@interface OrderListOneTableViewCell : UITableViewCell
//订单号
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
//订单状态
@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;
//产品图片
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
//产品名
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
//产品规格
@property (weak, nonatomic) IBOutlet UILabel *productFormatLabel;
//产品公司
@property (weak, nonatomic) IBOutlet UILabel *productCompany;
//内容为： 共几件商品，实付款
@property (weak, nonatomic) IBOutlet UILabel *productCountLabel;
//订单价格
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLabel;

- (void)updateOrderLIstOneCellWithModel:(SupOrderModel *)model;

@end
