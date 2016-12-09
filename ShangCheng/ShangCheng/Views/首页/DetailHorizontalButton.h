//
//  DetailHorizontalButton.h
//  ShangCheng
//
//  Created by TongLi on 2016/10/28.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
@interface DetailHorizontalButton : UIButton

@property (nonatomic,strong)UIImageView *leftImageView;
@property (nonatomic,strong)UILabel *label1;
@property (nonatomic,strong)UILabel *label2;
@property (nonatomic,strong)UILabel *priceLabel;

- (void)updateDetailHorizontalButton:(ProductModel *)tempProduct;


@end
