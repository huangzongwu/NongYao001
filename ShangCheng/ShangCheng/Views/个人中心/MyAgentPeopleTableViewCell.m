//
//  MyAgentPeopleTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/2/15.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MyAgentPeopleTableViewCell.h"

@implementation MyAgentPeopleTableViewCell
- (void)updateMyAgentPeopleCellWithAgentModel:(MyAgentPeopleModel *)tempModel {
    self.peopleNameAndPhoneLabel.text = tempModel.u_truename;
    self.peopleAddressLabel.text = [NSString stringWithFormat:@"%@ %@ %@",tempModel.capitalname,tempModel.cityname,tempModel.countyname];
    self.peopleTimeLabel.text = @"未知";
    
    
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
