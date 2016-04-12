//
//  MySettingViewController.m
//  LimitFree
//
//  Created by Apple on 16/4/7.
//  Copyright © 2016年 Dordly. All rights reserved.
//

#import "MySettingViewController.h"
#import <SDImageCache.h>

@interface MySettingViewController ()

@end

@implementation MySettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark ~~~UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 2)
    {
        //清除缓存
        [self clearCache];
        
    }
}
//MARK:清除缓存
-(void)clearCache
{
    SDImageCache * imageCache = [SDImageCache sharedImageCache];
    
    //获取缓存的大小
    NSUInteger cachesize = [imageCache getSize];//单位为:byte-字节，bit-位（1-8）
    
    //获取缓存的图片数量
    NSUInteger cacheImageNum = [imageCache getDiskCount];
    
    NSString * msg = [NSString stringWithFormat:@"缓存文件总共%lu个,大小为%.2fM,是否清除?",cacheImageNum,cachesize/1024/1204.0];
    //提示
    /*
     UIAlertControllerStyleActionSheet
     UIAlertControllerStyleAlert
     */
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"清除缓存" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    //创建AlertAction
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
       
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"清除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
       
        //清除缓存
        [imageCache clearMemory];//内存
        [imageCache clearDisk];//磁盘
        
    }];
    
    //将UIAlertAction添加到UIAlertController中
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    //Present显示
    [self presentViewController:alertController animated:YES completion:nil];
    
}
@end
