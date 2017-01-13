//
//  LogisticsTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/1/5.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogisticsModel.h"
@interface LogisticsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *logisticsAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *logisticsTimeLabel;

- (void)updateLogisticsCellWithLogisticsModel:(LogisticsModel *)logisticsModel;
@end
