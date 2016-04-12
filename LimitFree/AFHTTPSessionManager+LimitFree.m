//
//  AFHTTPSessionManager+LimitFree.m
//  LimitFree
//
//  Created by Apple on 16/3/31.
//  Copyright © 2016年 Dordly. All rights reserved.
//

#import "AFHTTPSessionManager+LimitFree.h"

@implementation AFHTTPSessionManager (LimitFree)

+(instancetype)limitFreeManager
{
    AFHTTPSessionManager * httpManager = [AFHTTPSessionManager manager];
    
    httpManager.responseSerializer.acceptableContentTypes = [httpManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    return httpManager;
}

@end
