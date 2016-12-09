//
//  MaxSaleHotCollectionReusableView.h
//  ShangCheng
//
//  Created by TongLi on 2016/10/28.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
@interface MaxSaleHotCollectionReusableView : UICollectionReusableView<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (nonatomic,strong) SDCycleScrollView *cycle;

@end
