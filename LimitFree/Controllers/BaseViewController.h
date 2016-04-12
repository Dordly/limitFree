//
//  BaseViewController.h
//  LimitFree
//
//  Created by Apple on 16/3/29.
//  Copyright © 2016年 Dordly. All rights reserved.
//

//基类:是所有视图控制器的父类，而父类是

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

//1、设置标题
-(void)addTitleViewWithTitle:(NSString *)title;

//2、设置左右按钮
-(void)addBarButtonItem:(NSString *)name Image:(UIImage *)image Target:(id)target action:(SEL)action isLeft:(BOOL)isLeft;

@end
