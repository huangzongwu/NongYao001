//
//  MineViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/1.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "MineViewController.h"
#import "MineHeaderCollectionReusableView.h"
#import "MineCollectionViewCellOne.h"
#import "MineCollectionViewCellTwo.h"
#import "MineCollectionViewCellThree.h"
#import "MineCollectionViewCellFour.h"
#import "Manager.h"
#import "MyTradeRecordViewController.h"
@interface MineViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *mineCollectionView;

@property (nonatomic,strong)NSMutableArray *mineDataSource;


@end

@implementation MineViewController
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //通知，登陆成功
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logedInAction:) name:@"logedIn" object:nil];
        //通知，退出登录
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logOffAction:) name:@"logOff" object:nil];

        
    }
    return self;
}
//登录成功后的通知
- (void)logedInAction:(NSNotification *) sender {
    //判断是不是代理，然后就更新UI，
    Manager *manager = [Manager shareInstance];
    [self updateDatasourceWithUserType:manager.memberInfoModel.u_type withIsReloadData:YES];
    
    //如果是代理。请求代理数据
    [self updateMyAgentDataWithUserType:manager.memberInfoModel.u_type];
    [self updateMyWalletWithIsLogin:YES];
    
}
//退出登录后的通知
- (void)logOffAction:(NSNotification *) sender {
    [self updateDatasourceWithUserType:@"2" withIsReloadData:YES];//退出登陆了，就默认显示普通用户模式
    [self updateMyWalletWithIsLogin:NO];
    
}


- (void)updateDatasourceWithUserType:(NSString *)userType withIsReloadData:(BOOL)isReloadData {
    NSString *jsonPath = [[NSBundle mainBundle]pathForResource:@"mineDataSource" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    //解析得到返回结果
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    NSInteger userTypeNum = [userType integerValue];
    
    
    switch (userTypeNum) {
        case 1:
            //代理商
            self.mineDataSource = [jsonDic objectForKey:@"delegateUser"];
            break;
        case 2:
            //普通用户
            self.mineDataSource = [jsonDic objectForKey:@"ordinaryUser"];
            break;
        default:
            //其他用户，暂时显示普通用户模式
            self.mineDataSource = [jsonDic objectForKey:@"ordinaryUser"];

            break;
    }
    if (isReloadData == YES) {
        [self.mineCollectionView reloadData];

    }

    
}

//网络请求代理数据
- (void)updateMyAgentDataWithUserType:(NSString *)userType {
    Manager *manager = [Manager shareInstance];
    //如果是代理。请求代理数据
    if ([userType integerValue] == 1) {
        [manager httpMyAgentBaseDataWithUserId:manager.memberInfoModel.u_id withMyAgentSuccess:^(id successResult) {
            
            if (manager.myAgentDic != nil) {
                
                [self.mineCollectionView reloadSections:[NSIndexSet indexSetWithIndex:3]];
            }
            
            
        } withMyagentFail:^(NSString *failResultStr) {
            
        }];
        
    }

}
//我的钱包
- (void)updateMyWalletWithIsLogin:(BOOL)isLogin {
    Manager *manager = [Manager shareInstance];
   
    if (isLogin == YES) {
        [manager httpMyWalletWithUserId:manager.memberInfoModel.u_id withMyWalletSuccess:^(id successResult) {
            
            [self.mineCollectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
            
        } withMyWalletFail:^(NSString *failResultStr) {
            
        }];

    }else {
        manager.myWalletDic = nil;
        [self.mineCollectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Manager *manager = [Manager shareInstance];
    
    //判断状态，现在是否登陆了，用户显示是代理商还是普通用户
    if ([manager isLoggedInStatus] == YES) {
        //已经登录
        [self updateDatasourceWithUserType:manager.memberInfoModel.u_type withIsReloadData:NO];

        //如果是代理。请求代理数据
        [self updateMyAgentDataWithUserType:manager.memberInfoModel.u_type];
        
        //请求余额 可提现 优惠卷个数
        [self updateMyWalletWithIsLogin:YES];

        
    }else {
        //未登录
        [self updateDatasourceWithUserType:@"2" withIsReloadData:NO];//未登录，默认显示普通用户
        [self updateMyWalletWithIsLogin:NO];
    }

    
    
}
#pragma mark - 头部的一些事件 -
//点击头像，如果没有登录，就登录，如果登录了就切换头像
- (IBAction)headerImageTap:(UITapGestureRecognizer *)sender {
    
    Manager *manager = [Manager shareInstance];
    if ([manager isLoggedInStatus] == YES) {
        //已经登录
    }else {
        //未登录,跳转到登录界面
        UINavigationController *loginNav = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
        [self presentViewController:loginNav animated:YES completion:nil];
    }
    
    
}


- (IBAction)memberManagerAction:(UIButton *)sender {
    [self performSegueWithIdentifier:@"mineToMemberManager" sender:nil];

}


#pragma mark - collectionView Delegate - 
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.mineDataSource.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   
    
    return [[self.mineDataSource objectAtIndex:section] count];
}

//分区头部大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 1 || section == 2 || section == 3) {
        //如果有这个分区有内容，才有这个分区头。否则就不要分区头
        if ([[self.mineDataSource objectAtIndex:section] count] > 0) {
            return CGSizeMake(kScreenW, 40);

        }else{
            return CGSizeMake(kScreenW, 0);

        }
    }else {
        return CGSizeMake(kScreenW, 0);
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if ([[self.mineDataSource objectAtIndex:section] count]==0) {
        return CGSizeMake(kScreenW, 0);
    }
    return CGSizeMake(kScreenW, 11);
}

//item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            return CGSizeMake(kScreenW, 100);
            break;
        case 1:
        case 2:
            return CGSizeMake(kScreenW/[[self.mineDataSource objectAtIndex:indexPath.section] count], 68);
            break;
        case 3:
            return CGSizeMake(kScreenW/3, 68);
            break;
        case 4:
            return CGSizeMake((kScreenW-3)/4, kScreenW/4);
        default:
            return CGSizeMake(kScreenW, 0);
            break;
    }
    
}
//头部设置
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MineHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"mineHeader" forIndexPath:indexPath];
        
        switch (indexPath.section) {
            case 1:
                [headerView updateHeaderCellWithTitleStr:@"我的订单" withButtonTitle:@"查看全部订单"];
                break;
            case 2:
                [headerView updateHeaderCellWithTitleStr:@"我的钱包" withButtonTitle:@"查看"];

                break;
            case 3:
                [headerView updateHeaderCellWithTitleStr:@"我的代理" withButtonTitle:@"查看"];
                
                break;
            default:
                break;
        }
        
        headerView.headerCellButton.indexForButton = indexPath;
        
        
        
        return headerView;
    }else {
        UICollectionReusableView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"mineFoot" forIndexPath:indexPath];
        return footView;
    }
    
//    return 0;
}

- (IBAction)headerButtoonAction:(IndexButton *)sender {
    NSLog(@"%ld",sender.indexForButton.section);
    
    switch (sender.indexForButton.section) {
        case 1:
        {
            //查看全部订单
            [self switchToOrderTabbarWithOrderType:1];
            
        }
            break;
        case 2:
        {
            //跳转到我的钱包
            [self performSegueWithIdentifier:@"mineToMyWallet" sender:nil];
        }
            break;
        case 3:
        {
            //跳转到我的代理
            [self performSegueWithIdentifier:@"mineToAgentVC" sender:nil];
        }
            break;
            
        default:
            break;
    }
    
}


//设置collectionViewCell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Manager *manager = [Manager shareInstance];

    NSDictionary *infoDic = [[self.mineDataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    
    switch (indexPath.section) {
        case 0:
        {
            MineCollectionViewCellOne *cellOne = [collectionView dequeueReusableCellWithReuseIdentifier:@"MineCellOne" forIndexPath:indexPath];
            [cellOne updateMineCollectionViewCellOne];
            
            return cellOne;
        }
            break;
            
        case 1:
        {
            MineCollectionViewCellTwo *cellTwo = [collectionView dequeueReusableCellWithReuseIdentifier:@"MineCellTwo" forIndexPath:indexPath];
            [cellTwo updateCellWithHeaderImage:[infoDic objectForKey:@"icon1"] withInfoStr:[infoDic objectForKey:@"info"] withFontFloat:12 withLineViewHide:YES];
            return cellTwo;
            
        }
            break;

        case 2:
        {
            if (indexPath.row < 3) {
                //上文字，下文字
                MineCollectionViewCellThree *cellThree = [collectionView dequeueReusableCellWithReuseIdentifier:@"MineCellThree" forIndexPath:indexPath];
                NSString *detailInfo = @"--";
                switch (indexPath.row) {
                    case 0:
                        detailInfo = [manager.myWalletDic objectForKey:@"u_amount"];
                        break;
                    case 1:
                        detailInfo = [manager.myWalletDic objectForKey:@"u_amount_avail"];
                        break;
                    case 2:
                        detailInfo = [manager.myWalletDic objectForKey:@"coupon"];
                        break;
                    default:
                        break;
                }
                [cellThree updateCellWithHeaderStr:detailInfo withInfoStr:[infoDic objectForKey:@"info"]];
                return cellThree;
            }else {
                MineCollectionViewCellTwo *cellTwo = [collectionView dequeueReusableCellWithReuseIdentifier:@"MineCellTwo" forIndexPath:indexPath];
                [cellTwo updateCellWithHeaderImage:[infoDic objectForKey:@"icon1"] withInfoStr:[infoDic objectForKey:@"info"] withFontFloat:12 withLineViewHide:YES];

                return cellTwo;
            }
        }
            break;
        case 3:
        {
            MineCollectionViewCellFour *cellFour = [collectionView dequeueReusableCellWithReuseIdentifier:@"MineCellFour" forIndexPath:indexPath];
            NSString *detailInfo = @"--";
            switch (indexPath.row) {
                case 0:
                    detailInfo = [manager.myAgentDic objectForKey:@"u_amount_avail"];
                    break;
                case 1:
                    detailInfo = [manager.myAgentDic objectForKey:@"ordernum"];
                    break;
                case 2:
                    detailInfo = [manager.myAgentDic objectForKey:@"peonum"];
                    break;
     
                default:
                    break;
            }
            
            [cellFour updateCellWithInfoStr1:[infoDic objectForKey:@"info"] withInfoStr2:detailInfo];
            return cellFour;
            
        }
            break;
            
        case 4:
        {
            MineCollectionViewCellTwo *cellTwo = [collectionView dequeueReusableCellWithReuseIdentifier:@"MineCellTwo" forIndexPath:indexPath];
            [cellTwo updateCellWithHeaderImage:[infoDic objectForKey:@"icon1"] withInfoStr:[infoDic objectForKey:@"info"] withFontFloat:15 withLineViewHide:NO];
            return cellTwo;
            
        }
            break;

        default:
            return 0;
            break;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld -- %ld",indexPath.section,indexPath.row);
    Manager *manager = [Manager shareInstance];
    BOOL isCanPush = NO;//假设都不可跳转
    //只有关于我们 意见反馈 设置 可以直接跳转
    if (indexPath.section == 4 && indexPath.row > 4) {
        isCanPush = YES;
    }else {
        //其余的都要登陆了才可以跳转
        if ([manager isLoggedInStatus] == YES) {
            isCanPush = YES;

        }
    }
    
    
    
    if (isCanPush == YES) {
        NSString *pushID = [[self.mineDataSource[indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"pushId"];
        if (indexPath.section == 1 && indexPath.row < 3) {
            //直接跳转到订单
            [self switchToOrderTabbarWithOrderType:indexPath.row+2];
        }else {
            //如果有pushId的话，才跳转
            if (pushID.length > 0) {
                
                [self performSegueWithIdentifier:pushID sender:indexPath];
                
            }
        }
    }else {
        NSLog(@"没有登录");
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 切换到订单页面 -
- (void)switchToOrderTabbarWithOrderType:(NSInteger )orderType {
    /*
     orderType 订单的类型
     1-全部  2-待付款  3-进行中  4-已完成
     */
    //发送通知到订单界面，切换订单类型
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mineToOrderListVC" object:self userInfo:@{@"orderType":[NSString stringWithFormat:@"%ld",orderType]}];
    [self.tabBarController setSelectedIndex:3];
    
}

#pragma mark - Navigation



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"mineVCToTradeRecordVC"]) {
        //提现记录 或者 交易记录
        MyTradeRecordViewController *myRecordVC = [segue destinationViewController];
        
        NSIndexPath *tempIndex = (NSIndexPath *)sender;
        if (tempIndex.row == 3) {
            myRecordVC.isCashStr = @"1";
        }
        if (tempIndex.row == 4) {
            myRecordVC.isCashStr = @"0";
        }
    }
}


@end
