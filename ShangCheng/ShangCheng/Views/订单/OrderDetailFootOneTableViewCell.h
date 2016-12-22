//
//  OrderDetailFootOneTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2016/12/20.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexButton.h"
#import "SonOrderModel.h"
@interface OrderDetailFootOneTableViewCell : UITableViewCell
//总价
@property (weak, nonatomic) IBOutlet UILabel *orderTotalPriceLabel;
//右边第一个button
@property (weak, nonatomic) IBOutlet IndexButton *buttonOne;
//右边第二个button
@property (weak, nonatomic) IBOutlet IndexButton *buttonTwo;
//右边第三个button
@property (weak, nonatomic) IBOutlet IndexButton *buttonThree;

- (void)updateOrderDetailFootOneCell:(SonOrderModel *)tempSonOrderModel;

@end
