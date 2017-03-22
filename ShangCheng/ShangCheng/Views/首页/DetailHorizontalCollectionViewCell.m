//
//  DetailHorizontalCollectionViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2016/10/28.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "DetailHorizontalCollectionViewCell.h"
#import "UIImageView+ImageViewCategory.h"
@implementation DetailHorizontalCollectionViewCell
- (void)updateDetailHorizontalCollectionViewCellWithUpModel:(ProductModel *)upModel withDownModel:(ProductModel *)downModel {
    //上面的产品
    [self.upProductImageView setWebImageURLWithImageUrlStr:upModel.productImageUrlstr withErrorImage:[UIImage imageNamed:@"productImage"]];
    if (upModel.isSaleProduct == YES) {
        self.upSaleImageView.hidden = NO;
    }else {
        self.upSaleImageView.hidden = YES;
    }
    self.upProductTitleLabel.text = upModel.productTitle;
    self.upProductFormatLabel.text = upModel.productFormatStr;
    self.upProductPriceLabel.text = upModel.productPrice;

    //下面的产品
    [self.downSaleImageView setWebImageURLWithImageUrlStr:downModel.productImageUrlstr withErrorImage:[UIImage imageNamed:@"productImage"]];
    if (downModel.isSaleProduct == YES) {
        self.downSaleImageView.hidden = NO;
    }else {
        self.downSaleImageView.hidden = YES;
    }
    self.downProductTitleLabel.text = downModel.productTitle;
    self.downProductFormatLabel.text = downModel.productFormatStr;
    self.downProductPriceLabel.text = downModel.productPrice;

}


@end
