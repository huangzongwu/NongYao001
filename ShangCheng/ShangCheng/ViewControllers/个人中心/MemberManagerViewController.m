//
//  MemberManagerViewController.m
//  ShangCheng
//
//  Created by TongLi on 2017/2/10.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "MemberManagerViewController.h"
#import "SetNickNameViewController.h"
#import "SelectAddressView.h"
#import "Manager.h"
@interface MemberManagerViewController ()


@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;

@property (nonatomic,strong) SelectAddressView *selectAddressView;

@end

@implementation MemberManagerViewController
- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //加载地区pickview
    self.selectAddressView = [[[NSBundle mainBundle] loadNibNamed:@"SelectAddressView" owner:self options:nil] firstObject];
    self.selectAddressView.frame = self.view.frame;
    //首先先隐藏
    self.selectAddressView.hidden = YES;
    [self.view addSubview:self.selectAddressView];

    
    Manager *manager = [Manager shareInstance];
    self.nickNameLabel.text = manager.memberInfoModel.u_truename;
    self.phoneNumberLabel.text = manager.memberInfoModel.u_mobile;
    self.areaLabel.text = [NSString stringWithFormat:@"%@ %@ %@",manager.memberInfoModel.capitalname,manager.memberInfoModel.cityname,manager.memberInfoModel.countyname];
    
}


//头像
- (IBAction)setHeaderTap:(UITapGestureRecognizer *)sender {
    
}

//昵称
- (IBAction)nickNameViewTao:(UITapGestureRecognizer *)sender {

    [self performSegueWithIdentifier:@"toSetNicknameVC" sender:nil];

}
//地区
- (IBAction)setAreaTap:(UITapGestureRecognizer *)sender {
    
    //得到地区数据，然后显示
    Manager *manager = [Manager shareInstance];
    if (manager.areaArr.count > 0 ) {
        //说明有数据
        NSLog(@"地区成功1");
        //显示pickView
        [self showAddressPickView];
        
    }else {
        //没有数据，就从本地获取或者网络请求
        [manager httpAreaTreeWithSuccessAreaInfo:^(id successResult) {
            NSLog(@"地区成功2");
            //刷新pickView
            [self showAddressPickView];
            
        } withFailAreaInfo:^(NSString *failResultStr) {
            NSLog(@"地区请求失败");
        }];
    }

}

//显示pickView
- (void)showAddressPickView {
    Manager *manager = [Manager shareInstance];
    
    [self.selectAddressView showPickerViewEnterSelectAreaWithAreaInfo:^(NSString *areaId, NSString *shengStr, NSString *shiStr, NSString *quStr) {
        
        NSLog(@"地区id%@",areaId);

        if (![manager.memberInfoModel.countycode isEqualToString:areaId]) {
            //如果两个选择了新的地址，就要网络请求修改地址
            
            //可以提交
            [manager httpMotifyMemberInfoWithUserID:manager.memberInfoModel.u_id withUsername:manager.memberInfoModel.u_truename withEmail:manager.memberInfoModel.u_email withMobile:manager.memberInfoModel.u_mobile withQQ:manager.memberInfoModel.u_qq withAreaId:areaId WithMotifyMemberSuccess:^(id successResult) {
                
                //修改成功，更新模型
                manager.memberInfoModel.capitalname = shengStr;
                manager.memberInfoModel.cityname = shiStr;
                manager.memberInfoModel.countyname = quStr;
                manager.memberInfoModel.countycode = areaId;
               
                //更新UI
                self.areaLabel.text = [NSString stringWithFormat:@"%@ %@ %@",shengStr,shiStr,quStr];

                
            } withMotifyMemberFail:^(NSString *failResultStr) {
                
            }];

            
        }
        

    }];
    
}
//密码设置
- (IBAction)passwordViewTap:(UITapGestureRecognizer *)sender {
    
    [self performSegueWithIdentifier:@"toMotifyPasswordVC" sender:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toSetNicknameVC"]) {
        SetNickNameViewController *setNickNameVC = [segue destinationViewController];
        setNickNameVC.freshNewNameBlock = ^(){
            self.nickNameLabel.text = [Manager shareInstance].memberInfoModel.u_truename;
        };
        
    }
}


@end
