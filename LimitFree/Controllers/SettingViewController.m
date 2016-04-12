//
//  SettingViewController.m
//  LimitFree
//
//  Created by Apple on 16/4/7.
//  Copyright © 2016年 Dordly. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingCell.h"
#import "MySettingViewController.h"
#import "MyHelpViewController.h"
#import "CollectViewController.h"

#define CellIdentifier @"SettingCell"

@interface SettingViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *settingCollectionView;

//设置图片数组
@property (nonatomic, strong)NSArray * settingImageArray;

//设置名称数组
@property (nonatomic, strong)NSArray * settingNameArray;

@end

@implementation SettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupViews];
    
    [self createDataSource];
    
    [self customNavigationItem];
    
}
-(void)customNavigationItem
{
    [self addTitleViewWithTitle:[NSString stringWithFormat:@"设置"]];
    [self addBarButtonItem:@"返回" Image:[UIImage imageNamed:@"buttonbar_back"] Target:self action:@selector(onBack) isLeft:YES];
}

-(void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//配置视图
-(void)setupViews
{
    //设置itemsize
    UICollectionViewFlowLayout * flowLayout = (id)self.settingCollectionView.collectionViewLayout;
    
    flowLayout.itemSize = CGSizeMake(60, 85);
    
    //设置最小行间距
    flowLayout.minimumLineSpacing = 20;
    
    //设置最小单元格间距
    flowLayout.minimumInteritemSpacing = 20;
    
    //设置内间距
    //CGFloat top, left, bottom, right;
    flowLayout.sectionInset =UIEdgeInsetsMake(20, 20, 20, 20);
    
    //注册单元格
    [self.settingCollectionView registerNib:[UINib nibWithNibName:@"SettingCell" bundle:nil] forCellWithReuseIdentifier:CellIdentifier];
    
    //设置委托和数据源
    self.settingCollectionView.dataSource = self;
    self.settingCollectionView.delegate = self;
    
}

//创建数据源
-(void)createDataSource
{
    self.settingImageArray = @[@"account_setting",@"account_favorite",@"account_user",@"account_collect",@"account_download",@"account_comment",@"account_help",@"account_candou"];
    self.settingNameArray = @[@"我的设置",@"我的关注",@"我的账号",@"我的收藏",@"我的下载",@"我的评论",@"我的帮助",@"蚕豆应用"];
    //加载数据
    [self.settingCollectionView reloadData];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.settingImageArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SettingCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.settingImageView.image = [UIImage imageNamed:self.settingImageArray[indexPath.row]];
    cell.settingLabel.text = self.settingNameArray[indexPath.row];
    
    return cell;
    
}

#pragma mark ~~~UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MySettingViewController * mySettingVC = [mainSB instantiateViewControllerWithIdentifier:@"MySettingViewController"];
            [self.navigationController pushViewController:mySettingVC animated:YES];
        }
            break;
            case 3:
        {
            CollectViewController * collect = [[CollectViewController alloc]init];
            [self.navigationController pushViewController:collect animated:YES];
            
        }
            break;
            case 6:
        {
            MyHelpViewController * myhelp = [[MyHelpViewController alloc]init];
            [self.navigationController pushViewController:myhelp animated:YES];
        }
            break;
        default:
            break;
    }
}
@end
