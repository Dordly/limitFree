//
//  SubjectViewController.m
//  LimitFree
//
//  Created by Apple on 16/3/29.
//  Copyright © 2016年 Dordly. All rights reserved.
//

#import "SubjectViewController.h"
#import "SubjectModel.h"
#import "SubjectCell.h"
#import "AppDetailViewController.h"

//复用
#define CellIdentifier @"SubjectCell"
@interface SubjectViewController ()<UITableViewDataSource>

@property (nonatomic, strong)UITableView * subjectTableView;

@property (nonatomic, strong)NSMutableArray * dataSourceArray;

@property (nonatomic , strong)AFHTTPSessionManager * httpManager;

@property (nonatomic, assign)NSInteger currentpage;

@end

@implementation SubjectViewController

-(AFHTTPSessionManager *)httpManager
{
    if(!_httpManager)
    {
        _httpManager=[AFHTTPSessionManager limitFreeManager];
    }
    return _httpManager;
}

-(NSMutableArray *)dataSourceArray
{
    if(!_dataSourceArray)
    {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addTitleViewWithTitle:self.title];
    
    //创建视图
    [self createViews];
    
}

//创建视图
-(void)createViews
{
    self.subjectTableView = [[UITableView alloc]init];
    
    [self.view addSubview:self.subjectTableView];
    self.subjectTableView.backgroundColor=[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1];
    
    //建立约束
    self.subjectTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.subjectTableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        //边相等
        make.edges.equalTo(self.view);
    }];
    
    //设置属性
    self.subjectTableView.dataSource = self;
    
    //设置行高
    self.subjectTableView.rowHeight = 320;
    
    //注册单元格
    [self.subjectTableView registerNib:[UINib nibWithNibName:@"SubjectCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    
    __weak typeof(self) weakself = self;
    //设置上拉刷新，下拉加载
    self.subjectTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakself.currentpage = 1;
        [weakself requestSubjectsWithPage:weakself.currentpage];
        //刷新数据
        [weakself.subjectTableView reloadData];
        
    }];
    self.subjectTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        
        weakself.currentpage ++;
        [weakself requestSubjectsWithPage:weakself.currentpage];
    }];
    
    //第一次刷新
    [self.subjectTableView.mj_header beginRefreshing];
    
}

//请求数据
-(void)requestSubjectsWithPage:(NSInteger)page
{
    __weak typeof(self) weakself = self;
    //拼接url
    NSString * url = [NSString stringWithFormat:kSubjectUrl,page];
    
    //请求数据
    [self.httpManager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //解析数据
        if(page==1)
        {
            //移空数据源
            [weakself.dataSourceArray removeAllObjects];
        }
        
        NSArray * appListModel =[NSArray yy_modelArrayWithClass:[SubjectModel class] json:responseObject];
        
        [weakself.dataSourceArray addObjectsFromArray:appListModel];
        
        //更新视图
        dispatch_async(dispatch_get_main_queue(), ^{
           
            //刷新数据
            [weakself.subjectTableView reloadData];
            
            //停止刷新
            [weakself.subjectTableView.mj_header endRefreshing];
            [weakself.subjectTableView.mj_footer endRefreshing];
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        NSLog(@"%@",error);
        
    }];
    
}

//MARK:遵从协议，实现协议中的方法--UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubjectCell * cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //设置模型数据源
    SubjectModel * model = self.dataSourceArray[indexPath.row];
    
    cell.model = model;
    __weak typeof(self) weakself =self;
    cell.block = ^(NSString * applicationId)
    {
        //显示详情页面
        AppDetailViewController * appDetailVC = [[AppDetailViewController alloc]init];
        
        appDetailVC.applicationId = applicationId;
        
        [weakself.navigationController pushViewController:appDetailVC animated:YES];
    };
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}
@end
