//
//  ReceiveAddressTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/29.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "ReceiveAddressTableViewCell.h"

@implementation ReceiveAddressTableViewCell
- (void)updateReceiveAddressCell:(ReceiveAddressModel *)receiveAddressModel withIndex:(NSIndexPath *)cellIndex{

    NSString *phoneStr = @"";
    if (receiveAddressModel.receiveMobile != nil && receiveAddressModel.receiveMobile.length == 11) {
        phoneStr = receiveAddressModel.receiveMobile;
    }else if (receiveAddressModel.receiveTel != nil && receiveAddressModel.receiveTel.length == 11) {
        phoneStr = receiveAddressModel.receiveTel;
    }
    
    self.receiverAndMobileLabel.text = [NSString stringWithFormat:@"%@  %@",receiveAddressModel.receiverName,phoneStr];
    
    self.receiveAddressLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",receiveAddressModel.capitalname,receiveAddressModel.cityname,receiveAddressModel.countyname,receiveAddressModel.receiveAddress];
    
    //如果是默认地址，前面就有对勾，如果不是默认地址，就没有对勾
    if (receiveAddressModel.defaultAddress == YES) {
        self.selectImageWidthLayout.constant = 32;
    }else {
        self.selectImageWidthLayout.constant = 0;
    }
    
    
    //给button附上index
    self.rightNextButton.indexForButton = cellIndex;
    
}
//右边进入编辑状态的按钮
- (IBAction)rightNextButtonAction:(IndexButton *)sender {
    
    NSLog(@"%ld",sender.indexForButton.section);
    self.rightNextBlock(sender.indexForButton);
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
