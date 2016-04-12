//
//  SubjectCell.h
//  LimitFree
//
//  Created by Apple on 16/3/31.
//  Copyright © 2016年 Dordly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubjectModel.h"
#import "SubjectAppView.h"

//点击SubjectAPPView的回调方法
typedef void(^SubjectAppViewBlock) (NSString * applicationId);

@interface SubjectCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *SubjectNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *SubjectImageView;

@property (weak, nonatomic) IBOutlet UIImageView *descImageView;

@property (weak, nonatomic) IBOutlet UITextView *descTextView;

@property (weak, nonatomic) IBOutlet SubjectAppView *appsView;

//关联数据模型
@property (nonatomic, strong) SubjectModel * model;

//点击APPView的回调
@property (nonatomic, copy)SubjectAppViewBlock block;

@end
