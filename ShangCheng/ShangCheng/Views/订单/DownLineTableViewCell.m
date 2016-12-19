//
//  DownLineTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/18.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "DownLineTableViewCell.h"

@implementation DownLineTableViewCell

- (void)updateBankUIWithBankDic:(NSMutableDictionary *)bankDic {
    self.bankNameLabel.text = [bankDic objectForKey:@"bankName"];
    self.bankCarNumberLabel.text = [bankDic objectForKey:@"bankNumber"];
    
    if ([[bankDic objectForKey:@"isSelect"] isEqualToString:@"YES"]) {
        self.selectMarkImageView.backgroundColor = [UIColor redColor];
    }else {
        self.selectMarkImageView.backgroundColor = [UIColor lightGrayColor];

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
