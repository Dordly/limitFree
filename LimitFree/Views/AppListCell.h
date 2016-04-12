//
//  AppListCell.h
//  LimitFree
//
//  Created by Apple on 16/3/30.
//  Copyright © 2016年 Dordly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APPListModel.h"
#import "StartView.h"
//自注释

@interface AppListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *expireDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastPriceLabel;
@property (weak, nonatomic) IBOutlet StartView *starView;
@property (weak, nonatomic) IBOutlet UILabel *categoryNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMsgLabel;

@property (nonatomic, strong)ApplicationsModel * model;
@end
