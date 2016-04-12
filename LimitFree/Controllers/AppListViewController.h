//
//  AppListViewController.h
//  LimitFree
//
//  Created by Apple on 16/3/29.
//  Copyright © 2016年 Dordly. All rights reserved.
//

#import "BaseViewController.h"

@interface AppListViewController : BaseViewController

//请求数据地址的接口
@property (nonatomic, copy)NSString * requestURL;

//分类ID
@property (nonatomic, copy)NSString * cateforyID;

//定义类型（限免，免费……）
@property (nonatomic, copy) NSString * categoryType;

//7.定义搜索文本
@property (nonatomic ,strong)NSString * searchText;

//定制UINavigationItem
-(void)customNavigationItem;

@end
