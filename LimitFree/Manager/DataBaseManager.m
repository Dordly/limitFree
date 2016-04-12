//
//  DataBaseManager.m
//  LimitFree
//
//  Created by Apple on 16/4/8.
//  Copyright © 2016年 Dordly. All rights reserved.
//

#import "DataBaseManager.h"
#import <FMDB.h>

//导入运行时的头文件
#import <objc/runtime.h>

@implementation DataBaseManager
{
    //定义成员变量(SQLite管理对象)
    FMDatabase * _fmdb;
}

//重写
-(instancetype)init
{
    //让其他类不能调用init方法
    //第一种:直接让程序崩溃
    //断言-用于判断一个条件是否满足，如果不满足，则程序崩溃，打印断言内容---就是让程序崩溃
    /**
     *  FALSE ,描述语言
     */
    NSAssert(FALSE, @"DataBaseManager不能调用init方法来创建对象，请使用单例方法来获取");
    
    //第二种:抛出异常，由上一级捕获异常，处理异常
    //创建异常
//    NSException * exception = [NSException exceptionWithName:@"init exception" reason:@"DataBaseManager不能调用init方法来创建对象，请使用单例方法来获取" userInfo:nil];
    //抛出异常
//    @throw exception;
    
    return nil;
}

+(instancetype)sharedManager
{
    static DataBaseManager * manager;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken,^{
        
        if(!manager)
        {
            manager = [[DataBaseManager alloc]initPrivate];
        }
    });
    
    return manager;
}

//用私有方法来创建对象
-(instancetype)initPrivate
{
    self = [super init];
    if(self)
    {
        //do something
        [self createDB];
        
//        NSArray * list = [self getPropertiesFromClass:[NSObject class]];
        
//        NSLog(@"%@",list);
        
    }
    return self;
}
//MARK:关闭数据库操作
-(void)dealloc
{
    [_fmdb close];
}
#pragma mark ~~~数据库的相关操作
//MARK:创建数据库
-(void)createDB
{
    /**
     参数1：找的目录名称
     参数2：在哪儿找---用户目录
     参数3：是否展开~（当前目录）
     */
    NSArray * documentsArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //在其中取出一个路径
    NSString * documentsPath =documentsArray.lastObject;
    
    //打印地址
    NSLog(@"documents path = %@",documentsPath);
    
    //创建对象
    NSString * dbPath = [documentsPath stringByAppendingPathComponent:@"LimitFree.db"];
    
    //创建管理对象
    _fmdb = [[FMDatabase alloc]initWithPath:dbPath];
    
    //打开数据库
    if([_fmdb open])
    {
        //创建数据库表
        
    }
}

//MARK:添加数据
-(BOOL)insertTableWithObject:(id)object
{
    //判断是否已存在
    if([self isExistWithObject:object])
    {
        return NO;
    }
    
    //获取对象的class
    Class objcClass = [object class];
    
    //创建表
    [self createTableFromClass:objcClass];
    
    //获取类名
    NSString * tableName = NSStringFromClass(objcClass);
    
    //获取属性列表
    NSArray * propertiesArray = [self getPropertiesFromClass:objcClass];
    
    //拼接
    NSString * propertStr = [propertiesArray componentsJoinedByString:@", "];
    
    //获取值--通过运行时-KVC
    NSArray * valuesArray = [self getValuesFromObject:object];

    //创建问号
    NSMutableArray * placeHolderArray = [NSMutableArray array];
    
    for (NSString * prop in propertiesArray)
    {
        [placeHolderArray addObject:@"?"];
        
    }
    NSString * placeHolderStr = [placeHolderArray componentsJoinedByString:@", "];
    
    NSString * insertSql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)",tableName,propertStr,placeHolderStr];
    
    NSLog(@"insertSql = %@",insertSql);
    
    //执行insert语句
    BOOL isSuccess = [_fmdb executeUpdate:insertSql withArgumentsInArray:valuesArray];
    
    return isSuccess;

}

//MARK:判断数据是否已存在
-(BOOL)isExistWithObject:(id)object
{
    //获取class
    Class objcClass = [object class];
    
    //获取表名
    NSString * tableName = NSStringFromClass( objcClass);
    
    //获取属性列表
    NSArray * propArray = [self getPropertiesFromClass:objcClass];
    
    //获取值列表
    NSArray * valueArray = [self getValuesFromObject:object];
    
    //拼接Where子查询语句
    NSString * whereStr = [propArray componentsJoinedByString:@" =? AND "];
    
    whereStr = [whereStr stringByAppendingString:@" =?"];
    
    //查找对象,全属性判断
    NSString * selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@",tableName,whereStr];
    
    NSLog(@"selectSql = %@",selectSql);
    
    //执行查找语句
   FMResultSet * resultSet = [_fmdb executeQuery:selectSql withArgumentsInArray:valueArray];
    
    //循环遍历结果集
    while ([resultSet next])
    {
        //当存在结果的时候，表示在数据库中存在
        return YES;
    }
    
    return NO;
}

#pragma mark ~~~实现删除方法
//删除数据库表中的记录
-(BOOL)deleteTableRecordWithObject:(id)object
{
    //判断是否存在
    if(![self isExistWithObject:object])
    {
        return NO;
    }
    
    //获取表名
    Class objcClass = [object class];
    NSString * tableName = NSStringFromClass(objcClass);

    //获取属性列表
    NSArray * propArray = [self getPropertiesFromClass:objcClass];
    
    //获取值列表
    NSArray * valueArray = [self getValuesFromObject:object];
    
    //拼接Where子查询语句
    NSString * whereStr = [propArray componentsJoinedByString:@" =? AND "];
    
    whereStr = [whereStr stringByAppendingString:@" =?"];
    
    //拼接删除表中记录
    NSString * deleteSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@",tableName,whereStr];
    NSLog(@"deleteSql = %@",deleteSql);
    
    //执行删除语句
    BOOL isSuccess = [_fmdb executeQuery:deleteSql withArgumentsInArray:valueArray];

    return isSuccess;
    
}
#pragma mark ~~~查找所有数据
-(NSArray *)getAllObjectFromClass:(Class)objcClass
{
    //获取表名
    NSString * tableName = NSStringFromClass(objcClass);
    
    //拼接
    NSString * selectAllSql = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
    
    //执行SQL语句返回结果集
    FMResultSet * resultSet =[_fmdb executeQuery:selectAllSql];
    
    //遍历结果集，创建对象
    NSMutableArray * objectsArray = [NSMutableArray array];
    
    //获取属性列表
    NSArray * propArray = [self getPropertiesFromClass:objcClass];
    
    while ([resultSet next])
    {
        //创建对象,通过class创建对象
        id object = [[objcClass alloc]init];
        
        //遍历属性列表/字段列表
        for(NSString * prop in propArray)
        {
            //从结果集中获取指定列的数据
            id value = [resultSet objectForColumnName:prop];
            //通过KVC的方式为对象赋值
            [object setValue:value forKey:prop];
        }
        
        //将对象添加到数组中
        [objectsArray addObject:object];
    }
    return objectsArray;
}
#pragma mark ~~~运行时
//获取一个类的所有属性
-(BOOL)createTableFromClass:(Class)objcClass
{
    //获取class的名称（name）
    NSString * tableName = NSStringFromClass(objcClass);
    
    //获取class的属性列表
    NSArray * propertiesArray = [self getPropertiesFromClass:objcClass];
    
    //SQLite数据库，无类型数据库--可存储任何类型的数据
    //拼接字段
    //componentsJoinedByString--在数组和数组之间添加字符串
    NSString * propertiesStr = [propertiesArray componentsJoinedByString:@" TEXT NOT NULL, "];
    
    propertiesStr = [propertiesStr stringByAppendingString:@" TEXT NOT NULL"];
    
    NSString * createSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,%@);",tableName,propertiesStr];
    
    NSLog(@"create = %@",createSql);
    
    //执行SQL语句
    BOOL isSuccess = [_fmdb executeUpdate:createSql];
    
    return isSuccess;
}

#pragma  mark ~~~~运行时
//获取一个类的所有属性
-(NSArray *)getPropertiesFromClass:(Class)class
{
    //创建一个数组用于存储所有属性
    NSMutableArray * propertiesArray = [[NSMutableArray alloc]init];
    
    unsigned int propertiescount = 0;
    
    //通过runtime来获取类中所有的属性(runtime--降低代码的耦合性)
    /**
     *  参数1：class
     *  参数2：返回的是属性的个数
     *  返回值:属性的结构体指针
     */
    //返回一个指针-指向一个数组，指向数组中的第一个元素
    objc_property_t * objcproperty =  class_copyPropertyList(class, &propertiescount);
    
    //循环变量取出属性
    for (int idx = 0; idx < propertiescount; idx++)
    {
        //取下标
        objc_property_t  property = objcproperty[idx];
        
        //获取结构体中属性的name
        const char * propertyName = property_getName(property);
        
        //将char * 转换成为NSString
        NSString * nameStr = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        
        //将其添加到数组中
        [propertiesArray addObject:nameStr];
    }
    
    return propertiesArray;
}

#pragma mark ~~~获取一个对象的所有属性值
-(NSArray *)getValuesFromObject:(id)object
{
    //创建数组，用于存储所有的值
    NSMutableArray * valuesArray = [NSMutableArray array];
    
    //首先获取所有的属性
    NSArray * propArray = [self getPropertiesFromClass:[object class]];
    
    //循环遍历
    for(NSString * prop in propArray)
    {
        //通过KVC的方式来获取对象中的值
        id value = [object valueForKey:prop];
        
        if(!value)
        {
            [valuesArray addObject:[NSNull null]];
            //nil NSNull 区别
        }
        else
        {
            [valuesArray addObject:value];
        }
       //[valuesArray addObject:value];
    }
    
    return valuesArray;
}
@end
