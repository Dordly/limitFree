//
//  ClassificationModel.h
//  LimitFree
//
//  Created by Apple on 16/3/30.
//  Copyright © 2016年 Dordly. All rights reserved.
//

#import "BaseModel.h"

@interface ClassificationModel : BaseModel

@property (nonatomic, copy) NSString *categoryCname;

@property (nonatomic, copy) NSString *categoryCount;

@property (nonatomic, copy) NSString *picUrl;

@property (nonatomic, copy) NSString *down;

@property (nonatomic, copy) NSString *same;

@property (nonatomic, copy) NSString *limited;

@property (nonatomic, copy) NSString *categoryId;

@property (nonatomic, copy) NSString *up;

@property (nonatomic, copy) NSString *free;

@property (nonatomic, copy) NSString *categoryName;

@end

