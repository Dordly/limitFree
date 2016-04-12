//
//  SubjectAppView.m
//  LimitFree
//
//  Created by Apple on 16/3/31.
//  Copyright © 2016年 Dordly. All rights reserved.
//

#import "SubjectAppView.h"
#import "StartView.h"

@implementation SubjectAppView
{
    //APP icon
    UIImageView * _appImageView;
    
    UILabel * _appNameLabel;
    
    UILabel * _appRateLabel;
    
    UILabel * _appDownloadLabel;
    
    StartView * _starView;
    
}

//创建视图
-(void)createViews
{
    _appImageView = [[UIImageView alloc]init];
    
    _appImageView.layer.cornerRadius = 10;
    _appImageView.layer.masksToBounds = YES;
    [self addSubview:_appImageView];
    _appImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _appNameLabel = [[UILabel alloc]init];

    _appNameLabel.font = [UIFont boldSystemFontOfSize:15];
    [self addSubview:_appNameLabel];
    _appNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    _appRateLabel = [[UILabel alloc]init];
    [self addSubview:_appRateLabel];
    _appRateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    _appDownloadLabel = [[UILabel alloc]init];
    [self addSubview:_appDownloadLabel];
    _appDownloadLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    _starView = [[StartView alloc]init];
    [self addSubview:_starView];
    _starView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //建立约束
    [_appImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        //上左下对齐
        make.top.left.bottom.equalTo(self);
        //宽=高
        make.width.equalTo(_appImageView.mas_height);
   
    }];
    
    [_appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        //顶部对齐
        make.top.equalTo(_appImageView.mas_top);
        //间距
        make.left.equalTo(_appImageView.mas_right).offset(5);
        
        //右边约束
        make.right.equalTo(self).offset(-5);
        
    }];
    
    [_appRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //左对齐
        make.left.equalTo(_appNameLabel.mas_left);
        
        //间距
        make.top.equalTo(_appNameLabel.mas_bottom).offset(5);
        //中心对齐
        make.centerY.equalTo(_appImageView.mas_centerY);
    }];
    
    [_appDownloadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //中心对齐
        make.centerY.equalTo(_appImageView.mas_centerY);
        //右对齐
        make.right.equalTo(self).offset(-5);
        
    }];
    
    [_starView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //左对齐
        make.left.equalTo(_appNameLabel.mas_left);
        //底部对齐
        make.bottom.equalTo(_appImageView.mas_bottom);
        //尺寸
        //宽度
        make.width.equalTo(@65);
        //高度
        make.height.equalTo(@20);
    }];
}

//重写初始化方法
-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self createViews];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [self createViews];
    }
    return self;
}

//重写set方法
-(void)setModel:(ApplicationsModel *)model
{
    _model = model;
    
    [_appImageView sd_setImageWithURL:[NSURL URLWithString:_model.iconUrl] placeholderImage:[UIImage imageNamed:@"appproduct_appdefault"]];
    
    _appNameLabel.text = _model.name;
    
    _starView.starvalue = [_model.starOverall floatValue];
    
    _appRateLabel.attributedText = [self attrbutedString:_model.ratingOverall withImage:[UIImage imageNamed:@"topic_Comment"]];
    
    _appDownloadLabel.attributedText = [self attrbutedString:_model.downloads withImage:[UIImage imageNamed:@"topic_Download"]];
  
}

//将其封装,通过富文本方式显示图片，图文混排
//CoreText,TextKit图文混排
-(NSAttributedString *)attrbutedString:(NSString *)text withImage:(UIImage *)image
{
    //创建一个可变属性的空的NSMutableAttributedString--富文本
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc]init];
    
    //将UIImage转换成为Attachement
    NSTextAttachment * attachment = [[NSTextAttachment alloc]init];
    
    //设置图片
    attachment.image = image;
    
    //将Attachement转变成为富文本
    NSAttributedString * attachementAttr = [NSAttributedString attributedStringWithAttachment:attachment];
    
    //将Text也转变成为富文本
    NSAttributedString * textAttr = [[NSAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}];
    //追加图片/拼接第一部分
    [attrString appendAttributedString:attachementAttr];
    
    //追加文本/拼接最后一部分
    [attrString appendAttributedString:textAttr];
    
    //最后返回
    return [attrString copy];
    
}
@end
