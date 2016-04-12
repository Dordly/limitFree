//
//  CategoryViewController.m
//  LimitFree
//
//  Created by Apple on 16/3/31.
//  Copyright © 2016年 Dordly. All rights reserved.
//

#import "CategoryViewController.h"
#import "ClassificationModel.h"
#import "CategoryTableViewCell.h"

//单元格复用标志
#define CellIdenttifier @"categoryTableViewCell"

@interface CategoryViewController ()<UITableViewDataSource,UITableViewDelegate>

//表格视图
@property (nonatomic , strong)UITableView * tableView;

//数据源数组
@property (nonatomic, strong)NSArray * dataSourcearray;

//数据请求
@property (nonatomic, strong)AFHTTPSessionManager * httpManager;

//提示框
@property (nonatomic, strong) MBProgressHUDManager * hubManager;

@end

@implementation CategoryViewController

//懒加载
-(AFHTTPSessionManager *)httpManager
{
    if(!_httpManager)
    {
        _httpManager=[AFHTTPSessionManager limitFreeManager];
    }
    return _httpManager;
}

-(MBProgressHUDManager *)hubManager
{
    if(!_hubManager)
    {
        _hubManager = [[MBProgressHUDManager alloc]initWithView:self.view];
    }
    return _hubManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createViews];
    
    [self custonNavigationItem];
    
}

//MARK:定制NAvigationItem
-(void)custonNavigationItem

{
    [self addTitleViewWithTitle:[NSString stringWithFormat:@"%@分类",self.title]];
    
    [self addBarButtonItem:@"返回" Image:[UIImage imageNamed:@"buttonbar_back"] Target:self action:@selector(onBack) isLeft:YES];
    
}

//MARK:返回事件
-(void)onBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//创建视图
-(void)createViews
{
    self.tableView = [[UITableView alloc]init];
    
    [self.view addSubview:self.tableView];
    
    //注册单元格
    [self.tableView registerNib:[UINib nibWithNibName:@"CategoryTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdenttifier];
    
    //建立约束
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view);
    }];
    //设置数据源和委托
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    
    //设置行高
    self.tableView.rowHeight=87;
    
    __weak typeof(self) weakself = self;
    //设置header
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        [weakself requestCategory];
        
    }];
    [self.tableView.mj_header beginRefreshing];
}

//请求分类数据
-(void)requestCategory
{
    __weak typeof(self) weakself = self;
    [self.httpManager GET:kCateUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"成功返回数据:%@",responseObject);
        
        weakself.dataSourcearray = [NSArray yy_modelArrayWithClass:[ClassificationModel class] json:responseObject];
        
        //回到主线程中刷新数组
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [weakself.tableView.mj_header endRefreshing];
            
            [weakself.tableView reloadData];
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
       
        NSLog(@"失败返回:%@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [weakself.tableView.mj_header endRefreshing];
            
            [weakself.hubManager showErrorWithMessage:error.localizedDescription duration:1.0];
        });
    }];
}

//配置单元格的内容显示数据的方法
-(void)configureCell:(CategoryTableViewCell *)cell withModel:(ClassificationModel *)model
{
    //对单元格进行赋值
    [cell.categoryImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"category_All.jpg"]];
    
    cell.categoryNameLabel.text = model.categoryCname;
    
    //拼接字符串
    //使用KVC来
    NSString * countStr = [NSString stringWithFormat:@"共有%@款，其中%@%@款",model.categoryCount,self.title,[model valueForKey:self.categoryType]];
    
    cell.categoryCountLabel.text = countStr;
}
#pragma mark ~~~遵从协议，实现方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourcearray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:CellIdenttifier forIndexPath:indexPath];
    
    ClassificationModel * model = self.dataSourcearray[indexPath.row];
    
    [self configureCell:cell withModel:model];
    
    return cell;
}
#pragma mark ~~~UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassificationModel * model = self.dataSourcearray[indexPath.row];
    
    //判断是否赋值
    if(self.block)
    {
        self.block(model.categoryId);
    }
    //返回上一级
    [self.navigationController popViewControllerAnimated:YES];
}

@end
