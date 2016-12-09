//
//  MineCollectionViewCellTwo.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/2.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "MineCollectionViewCellTwo.h"

@implementation MineCollectionViewCellTwo

- (void)updateCellWithHeaderImage:(NSString *)headerImageUrl withInfoStr:(NSString *)infoStr {
    self.headerImageView.image = [UIImage imageNamed:headerImageUrl];
    self.infoLabel.text = infoStr;
    
}

@end
