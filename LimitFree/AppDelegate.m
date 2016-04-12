//
//  AppDelegate.m
//  LimitFree
//
//  Created by Apple on 16/3/29.
//  Copyright © 2016年 Dordly. All rights reserved.
//

#import "AppDelegate.h"
//导入友盟头文件
#import <UMSocial.h>
//导入新浪SSO登录头文件
#import <UMSocialSinaSSOHandler.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //注册App Key
    [UMSocialData setAppKey:UMSocialAppKey];
    
    //设置新浪APPKey
    [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:@"http://chaosky.me"];
    
    NSLog(@"boundle path = %@",[NSBundle mainBundle].bundlePath);
    
    //本地通知，请求用户权限
     //ios8本地推送通知，添加一个授权方法
    if([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
    {
        //请求授权
        //UIUserNotificationSettings--用于设置通知类型
        /**
         *  UIUserNotificationTypeAlert--震动(弹出框)
         *  UIUserNotificationTypeBadge--图标/角标(应用程序)
         *  UIUserNotificationTypeSound--声音
         */
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    //创建本地通知
    UILocalNotification * localNotof = [[UILocalNotification alloc]init];
    
    //设置通知显示的内容
    localNotof.alertBody = @"亲，该吃药了哦，脑子不好，得补补！！！";
    
    //设置通知的声音，音频文件播放时长应小于30秒
    localNotof.soundName = @"CAT2.WAV";
    
    //设置通知的标题
    localNotof.alertTitle = @"Koko";
    
    //设置通知启动时间
    localNotof.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    
    //设置重复次数(每分钟)
    localNotof.repeatInterval = NSCalendarUnitMinute;
    
    //设置userInfo，将userInfo作为唯一的标志
    localNotof.userInfo = @{@"ID":@"01"};
    
    //设置应用程序的角标
    localNotof.applicationIconBadgeNumber = 10;
    
    //将本地通知添加到系统队列中
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotof];
    
    //取消通知
    //取消所有的通知
//    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    
    //当进入应用程序的时候，取消角标(将角标清0)
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
#pragma mark ~~~远程推送
    //请求用户权限，注册远程推送
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        UIUserNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        //注册远程推送
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        //ios8之前的版本注册推送
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
    
    return YES;
}

//MARK:接收本地通知
//在应用程序任何状态都可以接收通知
//1.如果应用程序在前台，则直接回调该方法来接收通知
//2.如果在后台/退出，通知会以弹出框和在通知栏中来显示/提醒用户，若要接收该通知，那么需要点击该通知，才会回调该方法
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:notification.alertTitle message:notification.alertBody delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
    
    //取消单个通知
    [[UIApplication sharedApplication]cancelLocalNotification:notification];
    
}

#pragma mark ~~~注册远程推送通知的回调方法
//MARK:当注册远程推送通知成功的回调方法
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"device token = %@",deviceToken);
//    NSString * tokenStr = [[NSString alloc] initWithData:deviceToken encoding:NSUTF16StringEncoding];
//    
//    NSLog(@"tokenStr = %@",[deviceToken description]);
    
    //将deviceToken发送给服务器
    NSString * deviceTokenStr = [deviceToken description];
    
    //替换数据中的尖括号
    deviceTokenStr = [deviceTokenStr substringWithRange:NSMakeRange(1, deviceTokenStr.length-2)];
    //再替换空格为-
    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    
    //最后发送Device Token给自己的服务器
    NSLog(@"device token = %@",deviceTokenStr);
    
}

//MARK:注册远程推送失败的回调方法
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"register remote notification error = %@",error.localizedDescription);
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if(result == FALSE)
    {
        //调用其他SDK
    }
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    //当应用程序从后台切换到前台，角标置0
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
