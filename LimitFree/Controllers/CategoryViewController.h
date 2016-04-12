//
//  CategoryViewController.h
//  LimitFree
//
//  Created by Apple on 16/3/31.
//  Copyright © 2016年 Dordly. All rights reserved.
//

#import "BaseViewController.h"

//回调，不是反向传值
typedef void(^CategoryBlock)(NSString * categoryID);

@interface CategoryViewController : BaseViewController

//分类的类型，限免等
@property (nonatomic, copy)NSString * categoryType;

@property (nonatomic, copy)CategoryBlock block;
@end
