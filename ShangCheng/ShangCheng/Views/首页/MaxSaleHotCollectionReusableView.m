//
//  MaxSaleHotCollectionReusableView.m
//  ShangCheng
//
//  Created by TongLi on 2016/10/28.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "MaxSaleHotCollectionReusableView.h"

@implementation MaxSaleHotCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.cycle = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(90, 0, self.bounds.size.width - 90, self.bounds.size.height) delegate:self placeholderImage:nil];
    self.cycle.onlyDisplayText = YES;
    self.cycle.delegate = self;
    self.cycle.userInteractionEnabled = NO;
    self.cycle.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.cycle.titlesGroup = @[@"广告1",@"广告2",@"广告3"];
    [self addSubview:self.cycle];
        
}

@end
