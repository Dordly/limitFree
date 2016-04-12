//
//  AFHTTPSessionManager+LimitFree.h
//  LimitFree
//
//  Created by Apple on 16/3/31.
//  Copyright © 2016年 Dordly. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface AFHTTPSessionManager (LimitFree)

+(instancetype)limitFreeManager;

@end
