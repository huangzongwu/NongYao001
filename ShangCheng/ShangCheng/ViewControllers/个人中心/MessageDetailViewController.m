//
//  MessageDetailViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/5/5.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "UIImageView+ImageViewCategory.h"

@interface MessageDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *messageTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *messageImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageDetailContentLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentViewHeightLayout;


@end

@implementation MessageDetailViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    
    self.messageTitleLabel.text = self.messageModel.i_title;
    self.messageTimeLabel.text = self.messageModel.i_time_create;

    if (self.messageModel.i_icon_path!= nil && self.messageModel.i_icon_path.length > 0) {
        self.imageHeightLayout.constant = 150;
        self.messageImageView.hidden = NO;
        [self.messageImageView setWebImageURLWithImageUrlStr:self.messageModel.i_icon_path withErrorImage:[UIImage imageNamed:@"icon_pic_cp"] withIsCenter:YES];
    }else{
        self.imageHeightLayout.constant = 0;
        self.messageImageView.hidden = YES;
    }
    
    self.messageDetailContentLabel.text = self.messageModel.i_introduce;

    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.scrollContentViewHeightLayout.constant = CGRectGetMaxY(self.messageDetailContentLabel.frame)+10;
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
