//
//  LeftProductClassTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/1/8.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "LeftProductClassTableViewCell.h"

@implementation LeftProductClassTableViewCell
- (void)updateLeftCellWithTitle:(NSString *)titleStr {
    self.leftCellLabel.text = titleStr;
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
