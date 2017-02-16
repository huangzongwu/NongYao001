//
//  CommentViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/1/6.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "CommentViewController.h"
#import "Manager.h"
@interface CommentViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCompanyLabel;
@property (weak, nonatomic) IBOutlet UILabel *productFormatLabel;

@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;
@property (weak, nonatomic) IBOutlet UIButton *buttonFour;
@property (weak, nonatomic) IBOutlet UIButton *buttonFive;

//选择的星星数量
@property (nonatomic,assign) NSInteger selectStarCount;

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

//是否匿名评价
@property (nonatomic,assign)BOOL isNickNameComment;
@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //更新头部视图
    [self updateHeaderProductView];
    //默认是匿名评价
    self.isNickNameComment = YES;
    
}
#pragma mark - 刷新头部产品的UI -
- (void)updateHeaderProductView {
    self.productTitleLabel.text = self.tempSonOrderModel.p_name;
    self.productFormatLabel.text = [NSString stringWithFormat:@"规格:%@  数量:%@",self.tempSonOrderModel.productst,self.tempSonOrderModel.o_num];
}

#pragma mark - 选择星星数量 -
- (IBAction)buttonOneAction:(UIButton *)sender {
    self.selectStarCount = 1;
    [self updateStarButtonUI];
}
- (IBAction)buttonTwoAction:(UIButton *)sender {
    self.selectStarCount = 2;
    [self updateStarButtonUI];
}
- (IBAction)buttonThreeAction:(UIButton *)sender {
    self.selectStarCount = 3;
    [self updateStarButtonUI];
}
- (IBAction)buttonFourAction:(UIButton *)sender {
    self.selectStarCount = 4;
    [self updateStarButtonUI];
}
- (IBAction)buttonFiveAction:(UIButton *)sender {
    self.selectStarCount = 5;
    [self updateStarButtonUI];
}

- (void)updateStarButtonUI {
    switch (self.selectStarCount) {
        case 1:
        {
            self.buttonOne.backgroundColor = [UIColor redColor];
            self.buttonTwo.backgroundColor = [UIColor lightGrayColor];
            self.buttonThree.backgroundColor = [UIColor lightGrayColor];
            self.buttonFour.backgroundColor = [UIColor lightGrayColor];
            self.buttonFive.backgroundColor = [UIColor lightGrayColor];
        }
            break;
        case 2:
        {
            self.buttonOne.backgroundColor = [UIColor redColor];
            self.buttonTwo.backgroundColor = [UIColor redColor];
            self.buttonThree.backgroundColor = [UIColor lightGrayColor];
            self.buttonFour.backgroundColor = [UIColor lightGrayColor];
            self.buttonFive.backgroundColor = [UIColor lightGrayColor];
        }
            break;
        case 3:
        {
            self.buttonOne.backgroundColor = [UIColor redColor];
            self.buttonTwo.backgroundColor = [UIColor redColor];
            self.buttonThree.backgroundColor = [UIColor redColor];
            self.buttonFour.backgroundColor = [UIColor lightGrayColor];
            self.buttonFive.backgroundColor = [UIColor lightGrayColor];
        }
            break;
        case 4:
        {
            self.buttonOne.backgroundColor = [UIColor redColor];
            self.buttonTwo.backgroundColor = [UIColor redColor];
            self.buttonThree.backgroundColor = [UIColor redColor];
            self.buttonFour.backgroundColor = [UIColor redColor];
            self.buttonFive.backgroundColor = [UIColor lightGrayColor];
        }
            break;
        case 5:
        {
            self.buttonOne.backgroundColor = [UIColor redColor];
            self.buttonTwo.backgroundColor = [UIColor redColor];
            self.buttonThree.backgroundColor = [UIColor redColor];
            self.buttonFour.backgroundColor = [UIColor redColor];
            self.buttonFive.backgroundColor = [UIColor redColor];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 底部View -
//匿名评价
- (IBAction)nickNameCommentButton:(UIButton *)sender {
    self.isNickNameComment = !self.isNickNameComment;
    
    if (self.isNickNameComment == YES) {
        sender.backgroundColor = [UIColor redColor];
    }else {
        sender.backgroundColor = [UIColor lightGrayColor];
    }
    
}
#warning 匿名评价
//提交订单
- (IBAction)commitCommentButton:(UIButton *)sender {
    if (self.selectStarCount > 0 && self.commentTextView.text != nil && self.commentTextView.text.length > 0) {
        
        //提交评价
        Manager *manager = [Manager shareInstance];
        [manager orderCommentWithUserid:manager.memberInfoModel.u_id withOrderId:self.tempSonOrderModel.o_id withStarLevel:[NSString stringWithFormat:@"%ld",self.selectStarCount] withContent:self.commentTextView.text withCommentSuccessBlock:^(id successResult) {
            //评论成功
            [self.navigationController popViewControllerAnimated:YES];
            
        } withCommentFailBlock:^(NSString *failResultStr) {
            
        }];
        
    }else {
        NSLog(@"信息不完整");
    }
    
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
