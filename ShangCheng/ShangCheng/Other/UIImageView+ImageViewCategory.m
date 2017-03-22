//
//  UIImageView+ImageViewCategory.m
//  ShangCheng
//
//  Created by TongLi on 2017/2/20.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "UIImageView+ImageViewCategory.h"
#import "UIImageView+WebCache.h"
@implementation UIImageView (ImageViewCategory)
- (void)setWebImageURLWithImageUrlStr:(NSString *)imageUrlStr withErrorImage:(UIImage *)errorImage {
    Manager *manager = [Manager shareInstance];
    NSURL *imageUrl = [NSURL URLWithString:imageUrlStr];//quan'b
    
//    NSURL *imageUrl = [manager webImageURlWith:imageUrlStr];
    
    [self sd_setImageWithURL:imageUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error != nil) {
            self.image = errorImage;
        }
    }];
}

@end
