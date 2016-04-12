//
//  BaseViewController.m
//  LimitFree
//
//  Created by Apple on 16/3/29.
//  Copyright © 2016年 Dordly. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}
-(void)addTitleViewWithTitle:(NSString *)title
{
    UILabel * titleView=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    
    self.navigationItem.titleView=titleView;
    
    //对titleView的属性进行设置(字体)
    titleView.font = [UIFont systemFontOfSize:16];
    
    //设置颜色
    titleView.textColor=[UIColor orangeColor];
    
    //设置文字居中
    titleView.textAlignment=NSTextAlignmentCenter;
    
    //设置文本信息
    titleView.text=title;
    
}

-(void)addBarButtonItem:(NSString *)name Image:(UIImage *)image Target:(id)target action:(SEL)action isLeft:(BOOL)isLeft
{
    UIButton * button=[UIButton buttonWithType:UIButtonTypeSystem];
    //创建UIBarButtonItem对象
    UIBarButtonItem * item=[[UIBarButtonItem alloc]initWithCustomView:button];
    
    //给按钮添加事件
    [button addTarget:target action:action forControlEvents:UIControlEventTouchDown];
    
    //设置button的属性
    [button setTitle:name forState:UIControlStateNormal];
    
    //设置图片
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    //设置frame
    button.frame=CGRectMake(0, 0, 44, 30);
    
    //判断是否放在左侧按钮
    if(isLeft)
    {
        self.navigationItem.leftBarButtonItem = item;
    }
    else
    {
        self.navigationItem.rightBarButtonItem=item;
    }
}
@end
