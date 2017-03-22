//
//  ProductListCollectionViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/1/9.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "ProductListCollectionViewCell.h"
#import "UIImageView+ImageViewCategory.h"
@implementation ProductListCollectionViewCell

- (void)updateProductListCellWithProductModel:(SearchListModel *)tempModel {
    
    [self.productListImageView setWebImageURLWithImageUrlStr:tempModel.p_icon withErrorImage:[UIImage imageNamed:@"productImage"]];
    self.productListNameLabel.text = tempModel.p_name;
    self.productListCompanyLabel.text = tempModel.f_name;
    self.productListFormatLabel.text = tempModel.p_standard;
    self.productListPriceLabel.text = [NSString stringWithFormat:@"￥%@", tempModel.p_price ];
}

@end
