//
//  AppListViewController.m
//  LimitFree
//
//  Created by Apple on 16/3/29.
//  Copyright © 2016年 Dordly. All rights reserved.
//

#import "AppListViewController.h"
#import "APPListModel.h"
#import "AppListCell.h"
#import "SearchViewController.h"
#import "CategoryViewController.h"
#import "AppDetailViewController.h"
#import "SettingViewController.h"

//单元格复用的宏定义
#define CellIdentifier @"AppListCell"

@interface AppListViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

//数据源数组
@property (nonatomic, strong)NSMutableArray * dataSourceArray;

//数据请求管理对象
@property (nonatomic, strong)AFHTTPSessionManager * httpManager;

//记录当前页
@property (nonatomic, assign)NSInteger currentPage;

//显示APP列表的表格视图
@property (nonatomic , strong)UITableView * applistTableView;

//设置搜索框
@property (nonatomic, strong)UISearchBar * searchBar;

@end

@implementation AppListViewController

//懒加载
-(NSMutableArray *)dataSourceArray
{
    if(!_dataSourceArray)
    {
        _dataSourceArray=[[NSMutableArray alloc]init];
    }
    return _dataSourceArray;
}

-(AFHTTPSessionManager *)httpManager
{
    if(!_httpManager)
    {
        _httpManager=[AFHTTPSessionManager limitFreeManager];
    }
    return _httpManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self customNavigationItem];
    
    [self createViews];
}

#pragma mark ~~~创建视图
-(void)createViews
{
    _applistTableView=[[UITableView alloc]init];
    
    [self.view addSubview:_applistTableView];
    
    //注册单元格
    [_applistTableView registerNib:[UINib nibWithNibName:@"AppListCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    
    //设置行高
    _applistTableView.rowHeight =130;
    
    //创建UISearchBar
    _searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    
    //设置UISearchBar
    _searchBar.showsCancelButton=YES;
    _searchBar.placeholder=@"百万应用等你来搜喲";
    
    _searchBar.delegate=self;
    _applistTableView.tableHeaderView = _searchBar;

    //通过Masonry建立约束
    _applistTableView.translatesAutoresizingMaskIntoConstraints=NO;
    
    [_applistTableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        //设置边紧挨
        make.edges.equalTo(self.view);
        
    }];
    
    //设置UITableView的dataSource和delegate
    _applistTableView.dataSource = self;
    _applistTableView.delegate = self;
    
    //5.将self变成weakself
    __weak typeof (self) weakself=self;
    
    //设置上拉刷新,header和footer同时只能一个生效
    _applistTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        //6.
        weakself.currentPage=1;
        [weakself requestAppListWithPage:weakself.currentPage searchText:weakself.searchText categoryID:weakself.cateforyID];
        
        //禁用footer
        weakself.applistTableView.mj_footer.hidden=YES;
        
    }];
    
    //下拉加载
    _applistTableView.mj_footer=[MJRefreshAutoFooter footerWithRefreshingBlock:^{
        
        //7.
        weakself.currentPage++;
        [weakself requestAppListWithPage:weakself.currentPage searchText:weakself.searchText categoryID:weakself.cateforyID];
        
        //禁用header
        weakself.applistTableView.mj_header.hidden=YES;
    }];
    
    //8.第一次加载数据的时候，直接使用tableView所对应的beginRefreshing,相当与自动请求数据
    [_applistTableView.mj_header beginRefreshing];
}
#pragma mark ~~~数据请求
-(void)requestAppListWithPage:(NSInteger)page searchText:(NSString *)searchText categoryID:(NSString *)cateID
{
    //弱引用指针
    __weak typeof(self) weakself=self;
    
    //1.拼接请求地址
    //如果一个字符串为nil的时候--null
    NSString * url = [NSString stringWithFormat:self.requestURL,page,searchText==nil?@"":searchText];
    
    //2.判断cateID是否为0
    if(cateID.length >0)
    {
        url = [url stringByAppendingFormat:@"&cate_id=%@",cateID];
    }
    //3.百分号编码(保证地址)
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"%@",url);
    
    //4.请求数据
    [self.httpManager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
    {
        NSLog(@"%@",responseObject);
        
        //将字典转换为模型数据
        APPListModel * listModel=[APPListModel yy_modelWithJSON:responseObject];
        
        if(page==1)
        {
            //移除所有的数据
            [weakself.dataSourceArray removeAllObjects];

        }
        
        //将模型中的数据添加到数据源中
        [weakself.dataSourceArray addObjectsFromArray:listModel.applications];
        
        //异步加载
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //停止刷新
            [weakself.applistTableView.mj_header endRefreshing];
            [weakself.applistTableView.mj_footer endRefreshing];
            
            //解禁footer和header
            weakself.applistTableView.mj_header.hidden=NO;
            weakself.applistTableView.mj_footer.hidden=NO;
            
            //判断数据是否加载完成
            if(weakself.dataSourceArray.count>=[listModel.totalCount integerValue])
            {
                //表示请求完成，没有数据可请求了
                //设置tableView footer的状态
                [weakself.applistTableView.mj_footer endRefreshingWithNoMoreData];
                
            }
            else
            {
                //重置提示没有更多数据
                [weakself.applistTableView.mj_footer resetNoMoreData];
            }
            
           //刷新数据
            [weakself.applistTableView reloadData];
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        NSLog(@"error=%@",error);
        
        if(weakself.currentPage>1)
        {
            weakself.currentPage--;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
           
            //返回hud对象
            MBProgressHUD * hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            hud.labelText = error.localizedDescription;
            
            [hud hide:YES afterDelay:1.0];
        });
    }];
    
}

#pragma mark ---UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建复用ID
    AppListCell * cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    //获取indexpath中的模型数据
    ApplicationsModel * model=self.dataSourceArray[indexPath.row];
    cell.model=model;
    
    return cell;
}
#pragma mark ~~~UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApplicationsModel * model = self.dataSourceArray[indexPath.row];
    //创建应用详情页面
    AppDetailViewController * appDetailVC = [[AppDetailViewController alloc]init];
    
    appDetailVC.applicationId = model.applicationId;
    
    appDetailVC.cateforyType = self.title;
    
    //隐藏底部
    appDetailVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:appDetailVC animated:YES];
}

#pragma mark ~~~UISearchBar
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString * searchText = searchBar.text;
    
    if(searchText.length>0)
    {
        //创建搜索页面
        SearchViewController * searchVC = [[SearchViewController alloc]init];
        
        //赋值
        searchVC.requestURL = self.requestURL;
        
        searchVC.cateforyID = self.cateforyID;
        
        searchVC.categoryType = self.categoryType;
        
        searchVC.title = searchText;
        searchVC.searchText = searchText;
        
        //设置searchViewController，且隐藏TabBar
        searchVC.hidesBottomBarWhenPushed = YES;
        
        //push
        [self.navigationController pushViewController:searchVC animated:YES];
    }
    
}

#pragma mark ~~~定制UINavigationItem
-(void)customNavigationItem
{
    //设置(定制)标题
    [self addTitleViewWithTitle:self.title];
    
    //定制左右按钮
    [self addBarButtonItem:@"分类" Image:[UIImage imageNamed:@"buttonbar_action"] Target:self action:@selector(onLeftClicked:) isLeft:YES];
    
    [self addBarButtonItem:@"设置" Image:[UIImage imageNamed:@"buttonbar_action"] Target:self action:@selector(onRightClicked:) isLeft:NO];
  
}

//MARK:左侧按钮响应
-(void)onLeftClicked:(UIButton *)sender
{
    CategoryViewController * category = [[CategoryViewController alloc]init];
    
    category.categoryType = self.categoryType;
    
    category.title = self.title;
    
    //给block赋值
    __weak typeof(self) weakself=self;
    
    category.block = ^(NSString * categoryId)
    {
        //如果分类为全部，那么就需要将cate_id参数移除，这是API设计时没考虑全
        if([categoryId isEqualToString:@"0"])
        {
            weakself.cateforyID = nil;
        }
        else
        {
        weakself.cateforyID = categoryId;
        
        //请求数据,刷新数据
        [weakself.applistTableView.mj_header beginRefreshing];
        }
    };
    //设置
    category.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:category animated:YES];
}

//MARK:右侧按钮响应
-(void)onRightClicked:(UIButton *)sender
{
    SettingViewController * setting =[[SettingViewController alloc]init];
    
    setting.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:setting animated:YES];
    
}
@end
