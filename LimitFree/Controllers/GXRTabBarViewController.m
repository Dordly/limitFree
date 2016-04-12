//
//  GXRTabBarViewController.m
//  LimitFree
//
//  Created by Apple on 16/3/29.
//  Copyright © 2016年 Dordly. All rights reserved.
//

#import "GXRTabBarViewController.h"
#import "AppListViewController.h"

@interface GXRTabBarViewController ()

@end

@implementation GXRTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createViewControllers];
    
    [self customTabBar];
}
#pragma mark~~~创建子视图控制器
-(void)createViewControllers
{
    //通过plist文件来创建
    
    //1.读取plist文件内容
    NSString * plistPath=[[NSBundle mainBundle] pathForResource:@"Controllers" ofType:@"plist"];
    
    //2.创建数组来读取数据
    NSArray * plistArray=[NSArray arrayWithContentsOfFile:plistPath];
    
    //3.循环遍历数组，创建视图控制器
    NSMutableArray * ViewControllers=[NSMutableArray array];
    
    //6.定义请求地址的数组
    NSArray * requestURLs=@[kLimitUrl,kReduceUrl,kFreeUrl,kSubjectUrl,kHotUrl];
    
    //8.定义存储类型
    NSArray * categoryType = @[kLimitType,kReduceType,kFreeType,kSubjectType,kHotType];
    
    //5.循环遍历
    for (NSDictionary * plistDict in plistArray)
    {
        //通过className创建一个类
        NSString * className=plistDict[@"className"];
        
        //设置title
        NSString * title=plistDict[@"title"];
        
        NSString * iconName=plistDict[@"iconName"];
        
        //本地化字符串
        //参数1：要实现本地化的key
        //参数2：本地化文件的名称
        title = NSLocalizedStringFromTable(title, @"LimitFree", nil);
        
        //通过类名来获取类
        Class class=NSClassFromString(className);
        
        //通过类来创建对象
        AppListViewController * vc=[[class alloc]init];
        
        vc.title=title;
        
        NSInteger index = [plistArray indexOfObject:plistDict];
        
        //7.给请求的地址数组赋值
        vc.requestURL = requestURLs[index];
        
        //9.给请求的数据类型赋值        
        vc.categoryType=categoryType[index];
        
        //将视图控制器放到NavigationController中
        UINavigationController * naviVC=[[UINavigationController alloc]initWithRootViewController:vc];
        
        //创建UITabBarItem
        UIImage * normalImage = [UIImage imageNamed:iconName];
        
        //选中后的图片
        UIImage * selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_press",iconName]];
        
        selectedImage=[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UITabBarItem * tabBarItem=[[UITabBarItem alloc]initWithTitle:title image:normalImage selectedImage:selectedImage];
        
        //设置
        naviVC.tabBarItem = tabBarItem;
        
        //定制UINavigationBar
        //1.获取UINavigationBar
        UINavigationBar * navigationBar=naviVC.navigationBar;
        
        //2.设置背景图片,
        /*
         UIBarMetricsDefault
         UIBarMetricsCompact
         UIBarMetricsDefaultPrompt
         UIBarMetricsCompactPrompt
         UIBarMetricsLandscapePhone
         UIBarMetricsLandscapePhonePrompt
         */
        [navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar"] forBarMetrics:UIBarMetricsDefault];
        
        
        //将NavigationController放到数组中
        [ViewControllers addObject:naviVC];
       
    }
    
    //设置当前的viewControllers=ViewControllers
    self.viewControllers=ViewControllers;
    
}
//MARK:定制UITabBar
-(void)customTabBar
{
    //获取UITabBar
    UITabBar * tabBar=self.tabBar;
    
    //设置背景图片
    [tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar_bg"]];
    
    //获取所有视图控制器
   NSArray * viewControllers=self.viewControllers;
    
    //循环遍历
    //参数1:对象
    
    [viewControllers enumerateObjectsUsingBlock:^(UINavigationController * navi, NSUInteger idx, BOOL * stop) {
        
        //重构-对某个方法/类进行重新构建/实现

        
    }];
    
}
@end
