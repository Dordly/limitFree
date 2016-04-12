//
//  CategoryTableViewCell.h
//  LimitFree
//
//  Created by Apple on 16/3/31.
//  Copyright © 2016年 Dordly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassificationModel.h"

@interface CategoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *categoryNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryCountLabel;


@end
