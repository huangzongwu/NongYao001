//
//  LeadViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/5/22.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "LeadViewController.h"
#import "Manager.h"

@interface LeadViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIPageControl *bottomPageView;

@end

@implementation LeadViewController

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    NSLog(@"当前显示的是第%ld张图片",index + 1);
    //当scrollView滑动停止的时候，根据偏移量计算得到的图片的index，可以赋值给pageControl的currentPage属性，让scrollView和pageControl产生关联
    self.bottomPageView.currentPage = index;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)nextButtonAction:(UIButton *)sender {
    //进入应用了，就要把plist标记的首次进入应用修改一下状态
    
    Manager *manager = [Manager shareInstance];
    [manager setFirstJoinAppWithStatus:@"NO"];
    
    
    [self performSegueWithIdentifier:@"leadToTabbarVC" sender:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
