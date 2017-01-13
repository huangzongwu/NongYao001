//
//  LogisticsTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/1/5.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "LogisticsTableViewCell.h"

@implementation LogisticsTableViewCell

- (void)updateLogisticsCellWithLogisticsModel:(LogisticsModel *)logisticsModel {
    self.logisticsAddressLabel.text = logisticsModel.t_char_para1;
    self.logisticsTimeLabel.text = logisticsModel.t_time_create;
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
