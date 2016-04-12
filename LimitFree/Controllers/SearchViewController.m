//
//  SearchViewController.m
//  LimitFree
//
//  Created by Apple on 16/3/30.
//  Copyright © 2016年 Dordly. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//重写定制方法
-(void)customNavigationItem
{
    //添加title
    [self addTitleViewWithTitle:self.title];
    
    [self addBarButtonItem:@"返回" Image:[UIImage imageNamed:@"buttonbar_back"] Target:self action:@selector(onBackAction) isLeft:YES];
}

//MARK:实现返回事件
-(void)onBackAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
