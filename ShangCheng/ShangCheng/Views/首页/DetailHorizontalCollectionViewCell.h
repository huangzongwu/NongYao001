//
//  DetailHorizontalCollectionViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2016/10/28.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
#import "DetailHorizontalButton.h"
@interface DetailHorizontalCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet DetailHorizontalButton *upButton;
@property (weak, nonatomic) IBOutlet DetailHorizontalButton *downButton;
- (void)updateDetailHorizontalCollectionViewCellWithUpModel:(ProductModel *)upModel withDownModel:(ProductModel *)downModel;



@end
