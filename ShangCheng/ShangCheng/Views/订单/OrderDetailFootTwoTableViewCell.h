//
//  OrderDetailFootTwoTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2016/12/20.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailFootTwoTableViewCell : UITableViewCell
//需付款
@property (weak, nonatomic) IBOutlet UILabel *needPayPriceLabel;
//下单时间
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;

@end
