//
//  SubjectModel.m
//  LimitFree
//
//  Created by Apple on 16/3/31.
//  Copyright © 2016年 Dordly. All rights reserved.
//

#import "SubjectModel.h"
#import "APPListModel.h"

@implementation SubjectModel

+(NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"applications":[ApplicationsModel class]};
}

@end
