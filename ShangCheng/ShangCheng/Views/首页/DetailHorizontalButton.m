//
//  DetailHorizontalButton.m
//  ShangCheng
//
//  Created by TongLi on 2016/10/28.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "DetailHorizontalButton.h"

@implementation DetailHorizontalButton
- (void)updateDetailHorizontalButton:(ProductModel *)tempProduct {
    self.label1.text = tempProduct.productTitle;
    self.label2.text = tempProduct.productCompany;
    self.priceLabel.text = tempProduct.productPrice;
    
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    NSLog(@"++%@",NSStringFromCGRect(rect));
    
    
    self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, rect.size.height-20, rect.size.height-20)];
    self.leftImageView.backgroundColor = [UIColor yellowColor];
    [self addSubview:self.leftImageView];
    
    
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftImageView.frame)+10, rect.size.height-25, rect.size.width-CGRectGetMaxX(self.leftImageView.frame)-20, 15)];
    self.priceLabel.backgroundColor = [UIColor cyanColor];
    self.priceLabel.textColor = [UIColor redColor];
    [self addSubview:self.priceLabel];
    
    
    self.label2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftImageView.frame)+10, rect.size.height-45,  rect.size.width-CGRectGetMaxX(self.leftImageView.frame)-20, 15)];
    self.label2.backgroundColor = [UIColor yellowColor];
    [self addSubview:self.label2];

    
    self.label1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftImageView.frame)+10, 10, rect.size.width-CGRectGetMaxX(self.leftImageView.frame)-20, rect.size.height-60)];
    self.label1.backgroundColor = [UIColor blueColor];
    [self addSubview:self.label1];
    
    
}


@end
