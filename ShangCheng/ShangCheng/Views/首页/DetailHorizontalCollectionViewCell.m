//
//  DetailHorizontalCollectionViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2016/10/28.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "DetailHorizontalCollectionViewCell.h"

@implementation DetailHorizontalCollectionViewCell
- (void)updateDetailHorizontalCollectionViewCellWithUpModel:(ProductModel *)upModel withDownModel:(ProductModel *)downModel {
    
    [self.upButton updateDetailHorizontalButton:upModel];
    [self.downButton updateDetailHorizontalButton:downModel];
    
}
//上面button的点击事件
- (IBAction)upButtonAction:(DetailHorizontalButton *)sender {
    
    
}
//下面按钮的点击事件
- (IBAction)downButtonAction:(DetailHorizontalButton *)sender {
    
    
}

@end
