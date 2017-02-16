//
//  MyFavoriteListTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/2/5.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MyFavoriteListTableViewCell.h"

@implementation MyFavoriteListTableViewCell
- (void)updateMyFavoriteListCell:(MyFavoriteListModel *)myFavotiteProductModel {
    
//    self.productImageView
    
    self.productTitleLabel.text = myFavotiteProductModel.favoriteProductTitleStr;
    self.productCompanyLabel.text = myFavotiteProductModel.favoriteProductCompanyStr;
    self.productFormatLabel.text = myFavotiteProductModel.favoriteProductFormatStr;
    self.productPriceLabel.text = [NSString stringWithFormat:@"￥%@", myFavotiteProductModel.favoriteProductPriceStr];
    
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
