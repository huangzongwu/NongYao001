//
//  MineAddressTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/1/18.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MineAddressTableViewCell.h"

@implementation MineAddressTableViewCell
- (void)updateMineAddressCellWithModel:(ReceiveAddressModel *)addressModel {
    
    if (addressModel.receiveMobile.length > 0) {
        self.nameAndPhoneLabel.text = [NSString stringWithFormat:@"%@  %@",addressModel.receiverName,addressModel.receiveMobile];
    }else if (addressModel.receiveTel.length > 0) {
        self.nameAndPhoneLabel.text = [NSString stringWithFormat:@"%@  %@",addressModel.receiverName,addressModel.receiveTel];
    }else {
        self.nameAndPhoneLabel.text = [NSString stringWithFormat:@"%@  未知电话",addressModel.receiverName];
    }
    
    self.detailAddressLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",addressModel.capitalname,addressModel.cityname,addressModel.countyname,addressModel.receiveAddress];
    
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
