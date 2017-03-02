//
//  TodaySaleTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/3/1.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "TodaySaleTableViewCell.h"
#import "UIImageView+ImageViewCategory.h"
@implementation TodaySaleTableViewCell
- (void)updateTodaySaleCellWithModel:(TodaySaleModel *)tempModel {
    
    self.todayTitleLabel.text = tempModel.type;
    [self.todayImageView setWebImageURLWithImageUrlStr:tempModel.a_image1 withErrorImage:[UIImage imageNamed:@"todayTest.png"]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
