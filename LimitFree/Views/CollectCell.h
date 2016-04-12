//
//  CollectCell.h
//  LimitFree
//
//  Created by Apple on 16/4/7.
//  Copyright © 2016年 Dordly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *collectImageView;
@property (weak, nonatomic) IBOutlet UILabel *collectLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end
