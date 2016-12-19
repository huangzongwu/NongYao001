//
//  PayTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/13.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "PayTableViewCell.h"

@implementation PayTableViewCell
- (void)updatePayCellWithJsonDic:(NSDictionary *)jsonDic {
//    [jsonDic objectForKey:@"payImg"];
    self.payCellTitleLabel.text = [jsonDic objectForKey:@"payTitle"];
    if ([[jsonDic objectForKey:@"isSelectPay"] isEqualToString:@"1"]) {
        //选择了这个支付方式
        self.selectMarkImageView.backgroundColor = [UIColor redColor];
    }else {
        self.selectMarkImageView.backgroundColor = [UIColor whiteColor];
    }
    
    
    
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
