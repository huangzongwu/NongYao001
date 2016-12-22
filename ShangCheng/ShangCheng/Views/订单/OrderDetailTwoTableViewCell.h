//
//  OrderDetailTwoTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2016/12/20.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailTwoTableViewCell : UITableViewCell
//左边的titleLabel
@property (weak, nonatomic) IBOutlet UILabel *titleLeftLabel;
//中间的Label，可能会隐藏
@property (weak, nonatomic) IBOutlet UILabel *middleMarkLabel;
//
@property (weak, nonatomic) IBOutlet UILabel *rightPriceLabel;


@end
