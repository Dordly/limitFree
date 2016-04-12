//
//  APPListModel.m
//  LimitFree
//
//  Created by Apple on 16/3/30.
//  Copyright © 2016年 Dordly. All rights reserved.
//

#import "APPListModel.h"

@implementation APPListModel

+(NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"applications" : [ApplicationsModel class]};
}
@end

@implementation ApplicationsModel

+(NSDictionary *)modelCustomPropertyMapper
{
    return @{@"desc":@"description"};
}

@end


