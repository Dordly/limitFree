//
//  StartView.m
//  LimitFree
//
//  Created by Apple on 16/3/29.
//  Copyright © 2016年 Dordly. All rights reserved.
//

#import "StartView.h"

@implementation StartView

{
    UIImageView * _foregroudImageView; // 前景图
    UIImageView * _backgroudImageView; // 背景图
}
// 重写初始化方法(init)
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self createImageViews];
    }
    return self;
}
//当在xib或者storyboard中关联类的时候，程序从xib或者storyboard中创建对象的时候会调用此方法
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self createImageViews];
    }
    return self;
}

// 创建图片视图
- (void)createImageViews
{
    _backgroudImageView = [[UIImageView alloc]init];
    [self addSubview:_backgroudImageView];
    //自动布局
    _backgroudImageView.translatesAutoresizingMaskIntoConstraints=NO;
    [_backgroudImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.width.equalTo(@65);
        make.height.equalTo(@23);
    }];
    
    //设置背景图的属性
    _backgroudImageView.image=[UIImage imageNamed:@"StarsBackground"];
    
    //设置图片的显示模式
    _backgroudImageView.contentMode=UIViewContentModeLeft;
    
    //前景图
    _foregroudImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"StarsForeground"]];
    
    [self addSubview: _foregroudImageView];
    [_foregroudImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(_backgroudImageView);
    }];
    
    //设置图片的显示模式
    _foregroudImageView.contentMode=UIViewContentModeLeft;
    
    //裁剪
    _foregroudImageView.clipsToBounds = YES;
}


// 设置星标视图的值
-(void)setStarvalue:(CGFloat)starvalue
{
    _starvalue = starvalue;
    
    NSLog(@"%f",_starvalue);
    //判断_starvalue
    if(_starvalue>=0&&_starvalue<=5)
    {
        //重建约束
        [_foregroudImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(_backgroudImageView);
            make.top.equalTo(_backgroudImageView);
            make.width.equalTo(_backgroudImageView).multipliedBy(_starvalue/5);//前景图:背景图
            make.height.equalTo(_backgroudImageView);
        }];
    }
}

@end
