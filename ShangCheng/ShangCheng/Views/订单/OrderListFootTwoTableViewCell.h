//
//  OrderListFootTwoTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2016/12/8.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupOrderModel.h"
#import "IndexButton.h"
typedef void(^FootTwoButtonBlock)(NSIndexPath * buttonIndex);

@interface OrderListFootTwoTableViewCell : UITableViewCell

//内容为： 共几件商品，实付款:订单价格
@property (weak, nonatomic) IBOutlet UILabel *orderCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderPriceLabel;


@property (weak, nonatomic) IBOutlet IndexButton *orderDetailInfoButton;
@property (nonatomic,copy)FootTwoButtonBlock footTwoButtonBlock;

- (void)updateOrderListFootTwoCellWithModel:(SupOrderModel *)model ;

@end
