//
//  OrderListFootTwoTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2016/12/8.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexButton.h"
typedef void(^FootTwoButtonBlock)(NSIndexPath * buttonIndex);

@interface OrderListFootTwoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet IndexButton *orderDetailInfoButton;
@property (nonatomic,copy)FootTwoButtonBlock footTwoButtonBlock;

@end
