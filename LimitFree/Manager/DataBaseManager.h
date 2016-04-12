//
//  DataBaseManager.h
//  LimitFree
//
//  Created by Apple on 16/4/8.
//  Copyright © 2016年 Dordly. All rights reserved.
//

/**
 *  数据库管理类，单例
 *  DAO 封装数据库---Data Access Object数据访问对象
 */
#import <Foundation/Foundation.h>

@interface DataBaseManager : NSObject

+(instancetype)sharedManager;

//创建数据库表
-(BOOL)createTableFromClass:(Class)objcClass;

//在数据库表中添加一条记录
-(BOOL)insertTableWithObject:(id)object;

//判断数据是否已存在
-(BOOL)isExistWithObject:(id)object;

//删除数据库表中的记录
-(BOOL)deleteTableRecordWithObject:(id)object;

//获取表中所有的记录
-(NSArray *)getAllObjectFromClass:(Class)objcClass;

@end
