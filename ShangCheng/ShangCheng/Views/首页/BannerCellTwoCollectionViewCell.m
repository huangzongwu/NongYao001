//
//  BannerCellTwoCollectionViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/11/20.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "BannerCellTwoCollectionViewCell.h"
#import "UIImageView+ImageViewCategory.h"

@implementation BannerCellTwoCollectionViewCell
- (void)updateBannerShopTwoCellWithActivityModel:(ActivityProductModel *)activityModel {
    
    [self.productImageView setWebImageURLWithImageUrlStr:activityModel.p_icon withErrorImage:[UIImage imageNamed:@"icon_pic_cp"] withIsCenter:YES];
    
    self.productNameLabel.text = activityModel.p_title;
    self.productFactoryLabel.text = activityModel.p_factory_name;
    self.productStandardLabel.text = activityModel.s_standard;
    
    
    self.salePriceLabel.text = [NSString stringWithFormat:@"活动价:%@", activityModel.s_price];
    self.backPriceLabel.text = [NSString stringWithFormat:@"￥%@",activityModel.s_price_backup];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
