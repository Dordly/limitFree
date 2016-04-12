//
//  AppListCell.m
//  LimitFree
//
//  Created by Apple on 16/3/30.
//  Copyright © 2016年 Dordly. All rights reserved.
//

#import "AppListCell.h"

@implementation AppListCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    //处理视图
    self.iconImageView.layer.cornerRadius = 35;
    
    self.iconImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//重写模型的Setter方法
-(void)setModel:(ApplicationsModel *)model
{
    _model=model;
    
    //填充视图
    //封面
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.iconUrl] placeholderImage:[UIImage imageNamed:@"appproduct_appdefault"]];
    
    //标题
    self.titleLabel.text=_model.name;
    
    //日期
    self.expireDateLabel.text=_model.expireDatetime;
    
    //价格
    //使用富文本进行文本处理(Rich Text:富文本，Plan Text:普通文本)
    NSDictionary * dict=@{NSStrikethroughStyleAttributeName : @4,NSStrikethroughColorAttributeName:[UIColor orangeColor]};
    
    //NSAttributedString-用于富文本的处理（不可变）
    //NSMutableAttributedString（可变）
    //创建富文本字符串
    NSAttributedString * last=[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@",_model.lastPrice] attributes:dict];
    self.lastPriceLabel.attributedText=last;

    self.categoryNameLabel.text=_model.categoryName;

    NSString * str=[NSString stringWithFormat:@"分享:%@次 收藏:%@次 下载:%@次",_model.shares,_model.favorites,_model.downloads];
    self.totalMsgLabel.text=str;
    
    //星级
    self.starView.starvalue=[_model.starOverall floatValue];
    
}
@end
