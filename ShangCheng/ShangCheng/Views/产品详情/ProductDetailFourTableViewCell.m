//
//  ProductDetailFourTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/3/16.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "ProductDetailFourTableViewCell.h"
#import "UIImageView+ImageViewCategory.h"
@implementation ProductDetailFourTableViewCell

- (void)updateProductDetailFourCellWithModel:(ProductTradeRecordModel *)model {
    [self.headerImageView setWebImageURLWithImageUrlStr:model.u_icon withErrorImage:[UIImage imageNamed:@"test"]];
    self.nameLabel.text = model.truename;
    self.mobileLabel.text = model.mobile;
    self.buyCountLabel.text = [NSString stringWithFormat:@"购买数量：%@", model.o_num ];
    self.timeLabel.text = model.p_time_pay;
    
    
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
