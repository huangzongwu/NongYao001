//
//  DetailVerticalCollectionViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2016/10/28.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "DetailVerticalCollectionViewCell.h"

@implementation DetailVerticalCollectionViewCell
- (void)updateDetailVerticalCollectionViewCell:(ProductModel *)tempProductModel {

    self.productTitleLabel.text = tempProductModel.productTitle;
    self.productCompanyLabel.text = tempProductModel.productCompany;
    self.productPriceLabel.text = tempProductModel.productPrice;
    
    
}

@end
