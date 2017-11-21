//
//  BannerCellOneCollectionViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/11/13.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "BannerCellOneCollectionViewCell.h"

@implementation BannerCellOneCollectionViewCell

- (IBAction)searchButtonAction:(UIButton *)sender {
    if (self.searchTextField != nil && self.searchTextField.text.length > 0) {
        self.searchBlock(self.searchTextField.text);

    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
