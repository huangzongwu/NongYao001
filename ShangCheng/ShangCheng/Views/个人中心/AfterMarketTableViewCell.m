//
//  AfterMarketTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/1/11.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "AfterMarketTableViewCell.h"
#import "SonOrderModel.h"
#import "UIImageView+ImageViewCategory.h"
@implementation AfterMarketTableViewCell
- (void)updateAfterMarketCellWithOrderModel:(SupOrderModel *)tempModel {
    
    self.orderIdLabel.text = tempModel.p_code;
    self.orderStatusLabel.text = tempModel.statusvalue;
    
    SonOrderModel *sonOrderModel = tempModel.subOrderArr[0];
    [self.orderProductImageView setWebImageURLWithImageUrlStr:sonOrderModel.p_icon withErrorImage:[UIImage imageNamed:@"icon_pic_cp"] withIsCenter:YES];
    self.orderProductNameLabel.text = sonOrderModel.p_name;
//    self.orderProductCompanyLabel.text =;
    self.orderProductFormatLabel.text = sonOrderModel.productst;
    self.orderProductPriceLabel.text = [NSString stringWithFormat:@"共%ld件商品，￥%.2f",tempModel.subOrderArr.count,[tempModel.p_o_price_total floatValue] - [tempModel.p_discount floatValue]];
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
