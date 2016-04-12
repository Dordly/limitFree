//
//  bigPictureViewController.h
//  LimitFree
//
//  Created by Apple on 16/4/6.
//  Copyright © 2016年 Dordly. All rights reserved.
//

#import "BaseViewController.h"

@interface bigPictureViewController : BaseViewController

//图片数组
@property (nonatomic, strong) NSArray * photosArray;

//当前选中的图片的位置
@property (nonatomic, assign)NSInteger currentIndex;

@end
