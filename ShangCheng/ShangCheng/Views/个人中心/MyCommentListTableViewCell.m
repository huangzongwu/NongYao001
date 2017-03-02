//
//  MyCommentListTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/2/4.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MyCommentListTableViewCell.h"
#import "UIImageView+ImageViewCategory.h"
@implementation MyCommentListTableViewCell
- (void)updateMyCommentCellWithCommentModel:(MyCommentListModel *)tempModel {
    
    [self.productImageView setWebImageURLWithImageUrlStr:tempModel.productImageUrl withErrorImage:[UIImage imageNamed:@"productImage"]];
    self.productNameLabel.text = tempModel.productTitleStr;
    self.productFormatLabel.text = tempModel.productFormatStr;
    self.companyLabel.text = tempModel.productCompanyStr;
    self.commentDetailLabel.text = tempModel.detailCommentStr;
    self.commentTimeLabel.text = tempModel.commentTimeStr;
    
    //星级
    switch (tempModel.starCount) {
        case 1:
        {
            self.oneStarImageView.hidden = NO;
            self.twoStarImageView.hidden = YES;
            self.threeStarImageView.hidden = YES;
            self.fourStarImageView.hidden = YES;
            self.fiveStarImageView.hidden = YES;
        }
            break;
        case 2:
        {
            self.oneStarImageView.hidden = NO;
            self.twoStarImageView.hidden = NO;
            self.threeStarImageView.hidden = YES;
            self.fourStarImageView.hidden = YES;
            self.fiveStarImageView.hidden = YES;
        }
            break;
        case 3:
        {
            self.oneStarImageView.hidden = NO;
            self.twoStarImageView.hidden = NO;
            self.threeStarImageView.hidden = NO;
            self.fourStarImageView.hidden = YES;
            self.fiveStarImageView.hidden = YES;
        }
            break;
        case 4:
        {
            self.oneStarImageView.hidden = NO;
            self.twoStarImageView.hidden = NO;
            self.threeStarImageView.hidden = NO;
            self.fourStarImageView.hidden = NO;
            self.fiveStarImageView.hidden = YES;
        }
            break;
        case 5:
        {
            self.oneStarImageView.hidden = NO;
            self.twoStarImageView.hidden = NO;
            self.threeStarImageView.hidden = NO;
            self.fourStarImageView.hidden = NO;
            self.fiveStarImageView.hidden = NO;
        }
            break;
        default:
            break;
    }
    
    
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
