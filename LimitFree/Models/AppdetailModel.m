//
//  AppdetailModel.m
//  LimitFree
//
//  Created by Apple on 16/4/1.
//  Copyright © 2016年 Dordly. All rights reserved.
//

#import "AppdetailModel.h"

@implementation AppdetailModel
+(NSDictionary *)modelCustomPropertyMapper
{
    return @{@"desc":@"description"};
}

+(NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"photos":[PhotosModel class]};
}
@end
@implementation PhotosModel

@end


