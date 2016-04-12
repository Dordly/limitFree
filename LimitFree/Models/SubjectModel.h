//
//  SubjectModel.h
//  LimitFree
//
//  Created by Apple on 16/3/31.
//  Copyright © 2016年 Dordly. All rights reserved.
//

#import "BaseModel.h"

@interface SubjectModel : BaseModel

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *desc_img;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray *applications;

@property (nonatomic, copy) NSString *date;

@end
