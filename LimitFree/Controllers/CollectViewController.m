//
//  CollectViewController.m
//  LimitFree
//
//  Created by Apple on 16/4/7.
//  Copyright © 2016年 Dordly. All rights reserved.
//

#import "CollectViewController.h"
#import "CollectCell.h"
#import "DataBaseManager.h"
#import "CollectionModel.h"

#define CellIdentifier @"Cell"
@interface CollectViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *CollectCollectionView;

//图片数组
@property (nonatomic, strong)NSMutableArray * CellectAppArray;

//判断当前是否处于编辑状态
@property (nonatomic, assign)BOOL isEditing;

@end

@implementation CollectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //创建视图
    [self setupViews];
    
    //取消编辑
    self.isEditing = NO;
    
    //拿到数据库中所收藏的数据
    self.CellectAppArray =[NSMutableArray arrayWithArray:[[DataBaseManager sharedManager] getAllObjectFromClass:[CollectionModel class]]];
    
    
    //创建NaviItem
    [self customNaviItem];
    
    [_CollectCollectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
-(void)customNaviItem
{
    [self addTitleViewWithTitle:@"我的收藏"];
    [self addBarButtonItem:@"编辑" Image:[UIImage imageNamed:@"buttonbar_edit"] Target:self action:@selector(onEditAction:) isLeft:NO];
    [self addBarButtonItem:@"返回" Image:[UIImage imageNamed:@"buttonbar_back"] Target:self action:@selector(onBackAction) isLeft:YES];
    
}

//MARK:编辑按钮
-(void)onEditAction:(UIButton *)sender
{
    //判断是否处于编辑状态
    if(self.isEditing)
    {
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        
        self.isEditing = NO;
    }
    else
    {
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        self.isEditing = YES;
    }
    
    //刷新UICollectionView
    [self.CollectCollectionView reloadData];
}

//MARK:返回按钮
-(void)onBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupViews
{
    //设置itemsize
    UICollectionViewFlowLayout * flowLayout =(id)self.CollectCollectionView.collectionViewLayout;
    
    flowLayout.itemSize = CGSizeMake(80, 100);
    
    //设置最小行间距
    flowLayout.minimumLineSpacing = 20;
    
    //设置最小单元格间距
    flowLayout.minimumInteritemSpacing = 20;
    
    //设置内间距
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    
    //注册单元格
    [self.CollectCollectionView registerNib:[UINib nibWithNibName:@"CollectCell" bundle:nil] forCellWithReuseIdentifier:CellIdentifier];
    
    //设置委托和数据源
    self.CollectCollectionView.delegate = self;
    self.CollectCollectionView.dataSource = self;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _CellectAppArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CollectionModel * model =self.CellectAppArray[indexPath.row];
    cell.collectLabel.text = model.appName;
    [cell.collectImageView sd_setImageWithURL:[NSURL URLWithString:model.appImage] placeholderImage:[UIImage imageNamed:@"appproduct_appdefault"]];
    cell.collectImageView.layer.masksToBounds = YES;
    cell.collectImageView.layer.cornerRadius = 10;
    
    //判断是否处于编辑状态
    if(self.isEditing)
    {
        cell.deleteButton.hidden = NO;
        
        //动画效果
        //参数1:动画持续时间
        //参数2:动画延迟时间
        cell.transform = CGAffineTransformMakeRotation(-0.05);
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionAllowUserInteraction animations:^{
            cell.transform = CGAffineTransformMakeRotation(0.05);
        } completion:nil];
    }
    else
    {
        cell.deleteButton.hidden = YES;
        
        //恢复原状
        cell.transform =CGAffineTransformIdentity;
    }
    
    [cell.deleteButton addTarget:self action:@selector(onDeleteAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

//MARK:删除按钮
-(void)onDeleteAction:(UIButton *)sender
{
    //找到单元格
    CollectCell * cell = (CollectCell *)sender.superview.superview;
    
    //获取单元格所对应的indexPath
    NSIndexPath * indexPath = [self.CollectCollectionView indexPathForCell:cell];
    
    //判断是先删除单元格还是数据？
    //先数据--先数据库中的数据
    CollectionModel * collectionModel = self.CellectAppArray[indexPath.row];
    [[DataBaseManager sharedManager] deleteTableRecordWithObject:collectionModel];
    //再删除数据源数据
    [self.CellectAppArray removeObject:collectionModel];
    
    //最后删除单元格
    [self.CollectCollectionView deleteItemsAtIndexPaths:@[indexPath]];
    
    //延迟重新刷新UICollectionView
    //参数1：表示延迟时间
    //参数2：延迟执行操作的队列
    //参数3：执行的操作
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.CollectCollectionView reloadData];
    });
}
@end
