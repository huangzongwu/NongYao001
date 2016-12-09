//
//  DetailVerticalCollectionViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2016/10/28.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
@interface DetailVerticalCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCompanyLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;

- (void)updateDetailVerticalCollectionViewCell:(ProductModel *)tempProductModel;
@end
