//
//  MainCollectionReusableView.m
//  ShangCheng
//
//  Created by TongLi on 2016/10/28.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "MainCollectionReusableView.h"

@implementation MainCollectionReusableView

- (void)updateMainHomeCell:(NSString *)sectionTitleStr withSection:(NSInteger )sectionIndex {

    self.sectionTitleLabe.text = sectionTitleStr;
    self.moreButtonForMainCell.indexForButton = [NSIndexPath indexPathForItem:0 inSection:sectionIndex];
    
}

- (IBAction)moreButtonForMainCell:(IndexButton *)sender {
    NSLog(@"%ld",sender.indexForButton.section);
    self.morebuttonIndexBlock(sender.indexForButton.section);
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
