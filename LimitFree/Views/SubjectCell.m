//
//  SubjectCell.m
//  LimitFree
//
//  Created by Apple on 16/3/31.
//  Copyright © 2016年 Dordly. All rights reserved.
//

#import "SubjectCell.h"
#include "AppDetailViewController.h"

@implementation SubjectCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

//重写set方法
-(void)setModel:(SubjectModel *)model
{
    _model = model;
    
    self.SubjectNameLabel.text = _model.title;
    
    [self.SubjectImageView sd_setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:[UIImage imageNamed:@"topic_TopicImage_Default"]];
    
    self.SubjectImageView.layer.masksToBounds = YES;
    self.SubjectImageView.layer.cornerRadius = 10;
    
    [self.descImageView sd_setImageWithURL:[NSURL URLWithString:_model.desc_img] placeholderImage:[UIImage imageNamed:@"topic_Header"]];
    
    self.descImageView.layer.masksToBounds = YES;
    self.descImageView.layer.cornerRadius = 10;
    
    self.descTextView.text = _model.desc;
    
    //移除AppsView中的所有的子视图
    if(self.appsView.subviews.count > 0)
    {
        //removeFromSuperview--让数组中的元素循环使用
        [self.appsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    //上下相同
//    for(UIView * view in self.appsView.subviews)
//    {
//        [view removeFromSuperview];
//    }
    
     __weak typeof(self) weakself = self;
    
    //记录上一个视图的变量
     __block UIView * preView = self.appsView;
    
    //循环遍历添加SubjectAppView
    //参数1:model的数据
    [_model.applications enumerateObjectsUsingBlock:^(ApplicationsModel * appModel, NSUInteger idx, BOOL * _Nonnull stop)
     {
         //给其建立约束
         //创建视图
         SubjectAppView * appView = [[SubjectAppView alloc]init];
         
         //给模型数据赋值
         appView.model = appModel;
         
         //将其添加到weakself.appsView
         [weakself.appsView addSubview:appView];
         
         [appView mas_makeConstraints:^(MASConstraintMaker *make) {
            
             //创建宽度
             make.width.equalTo(weakself.appsView.mas_width);
             //高度
             make.height.equalTo(weakself.appsView).multipliedBy(0.25);
             //左边
             make.left.equalTo(weakself.appsView.mas_left);
             
             //判断是否是第一个视图
             if(idx == 0)
             {
                 make.top.equalTo(preView.mas_top);
             }
             else
             {
             make.top.equalTo(preView.mas_bottom);
             }
             
         }];
         //当视图创建完成后
         preView = appView;
         
        //appView.model =_model.applications[idx];
         
         //给SubjectAPPView添加手势
         UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:weakself action:@selector(onSubjectAppViewTap:)];
         
         [appView addGestureRecognizer:tapGesture];
     }];
}

-(void)onSubjectAppViewTap:(UITapGestureRecognizer *)sender
{
    NSInteger tapIndex = [self.appsView.subviews indexOfObject:sender.view];
    
    ApplicationsModel * appmodel = self.model.applications[tapIndex];
    
    if(self.block)
    {
        //传AppcationId
        self.block(appmodel.applicationId);
    }
    
    
}

@end
