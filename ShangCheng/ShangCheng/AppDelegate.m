//
//  AppDelegate.m
//  ShangCheng
//
//  Created by TongLi on 2016/10/25.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "AppDelegate.h"
#import "Manager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSLog(@"%f -- %f",kScreenW,kScreenH);
    
    
    
    Manager *manager = [Manager shareInstance];
    //从本地读取个人信息，然后尝试自动登录一下
    BOOL result = [manager readMemberInfoModelFromLocation];
    if (result == YES) {
        //有个人信息。尝试一下登陆
//        MemberInfoModel *model = [Manager shareInstance].memberInfoModel;
        NSLog(@"%@--%@",manager.memberInfoModel.u_mobile,manager.memberInfoModel.userPassword);
        
        [[Manager shareInstance] loginActionWithUserID:manager.memberInfoModel.u_mobile withPassword:manager.memberInfoModel.userPassword withLoginSuccessResult:^(id successResult) {
            NSLog(@"免登陆成功");
        } withLoginFailResult:^(NSString *failResultStr) {
            NSLog(@"免登陆失败--%@",failResultStr);
        }];
        
    }
    //向微信注册
    [WXApi registerApp:@"wxad3c689bdfacc02c"];
    
    
    return YES;
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"异步result = %@",resultDic);
            
        }];
    }else if([url.host isEqualToString:@"pay"]) {
        //微信支付
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    Manager *manager = [Manager shareInstance];
    //支付宝
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            //支付后了。去后台验证
            if (resultDic != nil) {
                
                NSData *jsonData = [[resultDic objectForKey:@"result"] dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                
                NSString *tempPayId = [[dic objectForKey:@"alipay_trade_app_pay_response"] objectForKey:@"out_trade_no"];
                NSLog(@"%@",tempPayId);
                
                //如果支付成功，就可以进行验证签名了
                [manager afterPayOrderPaymentVerifyWithPayId:tempPayId withPaymentVerifySuccess:^(id successResult) {
                    NSLog(@"%@",successResult);
                    
#warning 支付成功后，返回到哪个界面

                } withPaymentVerifyFail:^(NSString *failResultStr) {
                    NSLog(@"%@",failResultStr);
                }];
                
            }
            
            
        }];
    }else if ([url.host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:self];

    }
    
    
    return YES;
}

//微信支付的回调
-(void) onResp:(BaseResp*)resp {
    //支付返回结果，实际支付结果需要去微信服务器端查询
    NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
    
    switch (resp.errCode) {
        case WXSuccess:
            strMsg = @"支付结果：成功！";
            NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
            break;
            
        default:
            strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
            NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
            break;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
