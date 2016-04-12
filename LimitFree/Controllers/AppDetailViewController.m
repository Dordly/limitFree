//
//  AppDetailViewController.m
//  LimitFree
//
//  Created by Apple on 16/4/1.
//  Copyright © 2016年 Dordly. All rights reserved.
//

#import "AppDetailViewController.h"
#import "AppdetailModel.h"
//大图
#import "bigPictureViewController.h"

//友盟分享
#import <UMSocial.h>
//导入定位
#import <CoreLocation/CoreLocation.h>
#import "CLLocation+Sino.h"
#import "DataBaseManager.h"
#import "CollectionModel.h"

//定义宏定义
//小图片开始的标记值
#define SmallPictureBeginTag 100

#define NearAppsTag 120

@interface AppDetailViewController ()<UMSocialUIDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *appInforLabel;

@property (weak, nonatomic) IBOutlet UILabel *appRateLabel;

- (IBAction)shareAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *favirateButton;

- (IBAction)favirateAction:(UIButton *)sender;

- (IBAction)downLoadAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *smallPicScrollView;

@property (weak, nonatomic) IBOutlet UITextView *discTextView;

@property (weak, nonatomic) IBOutlet UIScrollView *nearAppScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *smallPicScrollViewHeight;

//模型数据
@property (nonatomic, strong)AppdetailModel * model;

//网络请求管理对象
@property (nonatomic , strong)AFHTTPSessionManager * httpManager;

//定位的管理对象
@property (nonatomic, strong)CLLocationManager * locationManager;

//附近的人正在使用的Apps数组
@property (nonatomic, strong)NSArray * nearAppsArray;
@end

@implementation AppDetailViewController

//懒加载
-(AFHTTPSessionManager *)httpManager
{
    if(!_httpManager)
    {
        _httpManager=[AFHTTPSessionManager limitFreeManager];
    }
    return _httpManager;
}

//重写
-(CLLocationManager *)locationManager
{
    if(!_locationManager)
    {
        _locationManager =[[CLLocationManager alloc]init];
        
        //设置代理
        _locationManager.delegate = self;
        
        //定位范围-距离
        _locationManager.distanceFilter = 10;
        
        //定位精度
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
       //请求用户权限,判断当前App的定位权限
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if(status ==kCLAuthorizationStatusNotDetermined)
        {
            //未被授权时，请求用户授权
            [_locationManager requestWhenInUseAuthorization];
        }
        else if (status == kCLAuthorizationStatusDenied)
        {
            NSLog(@"未被授权，请前往设置中的爱限免项目打开定位服务");
        }

    }
    return _locationManager;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self requestAppDetail];
    
    //请求定位,开始定位
    [self.locationManager startUpdatingLocation];
    
    [self custonNavigationItem];
 
}

//MARK:定制NAvigationItem
-(void)custonNavigationItem
{
    [self addTitleViewWithTitle:[NSString stringWithFormat:@"应用详情"]];
    
    [self addBarButtonItem:@"返回" Image:[UIImage imageNamed:@"buttonbar_back"] Target:self action:@selector(onBack) isLeft:YES];
    
}
-(void)onBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//请求附近人使用App的数据
-(void)requestNearApps:(CLLocation *)location
{
    __weak typeof(self) weakself = self;
    //将地球坐标转换为火星坐标
    location = [location locationMarsFromEarth];
    
    //拼接URL
    NSString * url = [NSString stringWithFormat:kNearAppUrl,location.coordinate.longitude,location.coordinate.latitude];
    
    //请求数据
    [self.httpManager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
    {
        NSLog(@"%@",responseObject);
        
        //获取数组
        NSArray * applications = responseObject[@"applications"];
        
        NSArray * appDetailArray = [NSArray yy_modelArrayWithClass:[AppdetailModel class] json:applications];
        
        //加载数据
        [weakself updateNearAppsView:appDetailArray];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        NSLog(@"%@",error);
    }];
    
}

//MARK:更新视图数据
-(void)updateNearAppsView:(NSArray *)nearApps
{
    
    //先将所有子视图移除
    if(self.nearAppScrollView.subviews.count > 0)
    {
        [self.nearAppScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    self.nearAppsArray = nearApps;
    
    __weak typeof(self) weakself =self;
    //首先获取图片的大小和宽度
    CGFloat imageH = self.nearAppScrollView.frame.size.height-10;
    CGFloat imageW = imageH;
    
    [nearApps enumerateObjectsUsingBlock:^(AppdetailModel * model, NSUInteger idx, BOOL * _Nonnull stop)
    {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(idx*imageW, 0, imageW, imageH)];
        [weakself.nearAppScrollView addSubview:imageView];
        
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 10;
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"appproduct_appdefault"]];
        //开启用户交互
        imageView.userInteractionEnabled = YES;
        
        //添加手势
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onNearAppsScrollViewTap:)];
        //添加到imageView
        [imageView addGestureRecognizer:tapGesture];

        
    }];
    
    //设置UIScrollView
    self.nearAppScrollView.bounces = NO;
    self.nearAppScrollView.contentSize =CGSizeMake(imageW*nearApps.count, imageH);
}

//MARK:添加手势点击
-(void)onNearAppsScrollViewTap:(UITapGestureRecognizer *)sender
{
    //找出一个对象在某一个数组中的位置
    NSInteger tapIndex = [self.nearAppScrollView.subviews indexOfObject:sender.view];
    AppdetailModel * model = self.nearAppsArray[tapIndex];
    
    //跳转到下一个显示App详情页面
    AppDetailViewController * appdetailVC = [[AppDetailViewController alloc]init];
    
    appdetailVC.applicationId = model.applicationId;
    appdetailVC.cateforyType = self.cateforyType;
    
    //在下一页显示
    [self.navigationController pushViewController:appdetailVC animated:YES];
    
}
//请求应用程序的详情数据
-(void)requestAppDetail
{
    __weak typeof(self) weakself = self;
    
    //拼接URL的地址
    NSString * url = [NSString stringWithFormat:kDetailUrl,self.applicationId];
    
    //请求数据
    [self.httpManager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
    {
        //将JSON数据转换成为模型数据
        weakself.model = [AppdetailModel yy_modelWithJSON:responseObject];
        
        //更新视图
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [weakself updateViews];
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        
    }];
}

//MARK:更新视图
-(void)updateViews
{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.iconUrl] placeholderImage:[UIImage imageNamed:@"appproduct_appdefault"]];
    self.iconImageView.layer.cornerRadius = 10;
    self.iconImageView.layer.masksToBounds = YES;
    
    self.titleLabel.text = _model.name;
    
    NSString * appInforText = [NSString stringWithFormat:@"原价:￥%@ %@中 文件大小:%@MB",_model.lastPrice,self.cateforyType,_model.fileSize];
    self.appInforLabel.text = appInforText;
    
    NSString * rateInforText = [NSString stringWithFormat:@"类型:%@ 评分:%@",_model.categoryName,_model.ratingOverall];
    
    self.appRateLabel.text = rateInforText;
    
    //获取UIScrollView的高度
    CGFloat imageHeight = self.smallPicScrollViewHeight.constant;
    
    //定义图片的宽度
    CGFloat imageWidth = imageHeight * 1.77;
    
    __weak typeof(self) weakself = self;
    //遍历图片数组
    [self.model.photos enumerateObjectsUsingBlock:^(PhotosModel * photoModel, NSUInteger idx, BOOL *  stop)
    {
        //创建图片视图
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(idx * imageWidth, 0, imageWidth, imageHeight)];
        
        [weakself.smallPicScrollView addSubview:imageView];
        
        //设置图片
        [imageView sd_setImageWithURL:[NSURL URLWithString:photoModel.smallUrl] placeholderImage:[UIImage imageNamed:@"appproduct_appdefault"]];
        
        //给UIImageView添加tap手势
        //打开用户交互
        imageView.userInteractionEnabled = YES;
        
        //添加手势
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OntapSmallPicture:)];
        
        //将手势添加到ImageView上
        [imageView addGestureRecognizer:tapGesture];
        
        //设置tag值
        imageView.tag = SmallPictureBeginTag + idx;
        
    }];
    
    //设置contentSize
    self.smallPicScrollView.contentSize = CGSizeMake(self.model.photos.count* imageWidth, imageHeight);
    
    //关闭弹簧效果
    self.smallPicScrollView.bounces = NO;
    
    self.discTextView.text=_model.desc;
    
    //判断是否已收藏
    
    //1.构造一个CollectionModel
    CollectionModel * collectionModel = [[CollectionModel alloc]init];
    
    collectionModel.appId = self.model.applicationId;
    collectionModel.appName = self.model.name;
    collectionModel.appImage = self.model.iconUrl;
    
    //判断数据是否已存在
    BOOL isExist = [[DataBaseManager sharedManager]isExistWithObject:collectionModel];
    
    if(isExist)
    {
        self.favirateButton.enabled = NO;
    }
    else
    {
        self.favirateButton.enabled = YES;
    }
    
}

//MARK:实现小图点击回调方法
-(void)OntapSmallPicture:(UITapGestureRecognizer *)sender
{
    //获取tap点击的对象视图
    UIView * tapView = sender.view;
    
    //获取位置值
    //0-n
    NSInteger tapIndex = tapView.tag - SmallPictureBeginTag;
    
    //创建大图页面
    bigPictureViewController * bPVC = [[bigPictureViewController alloc]init];
    
    //设置属性
    bPVC.currentIndex = tapIndex;
    
    //数组
    bPVC.photosArray = _model.photos;
    
    //设置动画效果
    /*
     UIModalTransitionStyleCoverVertical , 垂直
     UIModalTransitionStyleFlipHorizontal , 水平
     UIModalTransitionStyleCrossDissolve, 叠化
     UIModalTransitionStylePartialCurl  局部卷曲
     */
    bPVC.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:bPVC animated:YES completion:nil];
    
}

//MARK:分享按钮
- (IBAction)shareAction:(UIButton *)sender
{
    //限制字数在150
    NSInteger descWordCount = 150 - _model.name.length-_model.desc.length-_model.itunesUrl.length;
    
    NSString * descText = nil;
    
    //判断desc是否足够长,才去截取它
    if(_model.desc.length > descWordCount)
    {
        descText = [_model.desc substringFromIndex:descWordCount-5];
    }
    else
    {
        descText = _model.desc;
    }
    
    //设置分享文本
    NSString * shareText = [NSString stringWithFormat:@"%@:%@--%@",_model.name,descText,_model.itunesUrl];
    
    //设置分享图片
    UIImage * shareImage = self.iconImageView.image;
    
    //分享的平台:新浪微博，微信好友，手机QQ，微信朋友圈，QQ空间
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMSocialAppKey shareText:shareText shareImage:shareImage shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToQQ,UMShareToWechatTimeline,nil] delegate:self];
}

//MARK:收藏按钮
- (IBAction)favirateAction:(UIButton *)sender
{
    //捕获异常
    //如果不捕获异常，同样会导致程序崩溃
//    @try
//    {
//        //要执行的代码(可能发生崩溃的代码)
//         DataBaseManager * manager = [[DataBaseManager alloc]init];
//        
//    } @catch (NSException *exception)
//    {
//        //捕获异常(有异常的时候，才会执行)
//        
//        NSLog(@"exception = %@",exception);
//        
//    } @finally
//    {
//        //无论代码是否存在问题，都会执行
//        NSLog(@"创建DataBaseManager");
//    }
    
    DataBaseManager * manager = [DataBaseManager sharedManager];
   
    //创建
//    [manager createTableFromClass:[CollectionModel class]];
    
//    CollectionModel * model = [[CollectionModel alloc]init];
    
//    [manager insertTableWithObject:model];
    
    //判断当前请求数据是否成功
    if(self.model)
    {
        CollectionModel * collectionModel = [[CollectionModel alloc]init];
        
        collectionModel.appId = self.model.applicationId;
        collectionModel.appName = self.model.name;
        collectionModel.appImage = self.model.iconUrl;
        
        //将其添加到数据库中
        BOOL success = [manager insertTableWithObject:collectionModel];
        if(success)
        {
            //禁用按钮
            sender.enabled = NO;
            [KVNProgress showSuccessWithStatus:@"收藏成功"];
        }
        else
        {
            [KVNProgress showSuccessWithStatus:@"收藏失败"];
        }
    }

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [KVNProgress dismiss];
}

//MARK:下载按钮
- (IBAction)downLoadAction:(UIButton *)sender
{
    //打开网址--iTunes下载
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_model.itunesUrl]];
    
    //打开网页
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    
    //打电话
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://15730128494"]];
    
}
#pragma mark ~~~CLLocationManagerDelegate
//授权状态的改变回调
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(status == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        //重新定位
        [manager startUpdatingLocation];
    }
    else if(status == kCLAuthorizationStatusDenied)
    {
        NSLog(@"定位服务不被允许");
    }
    
}

//定位服务，返回定位的经纬度数据
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    //当定位服务返回数据的时候，判断返回是否为空
    if(locations.count>0)
    {
        //停止定位服务
        [manager stopUpdatingLocation];
        
        //取值，遍历数据(获取经纬度)-最后一个对象
        CLLocation * location = locations.lastObject;
        
        //获取请求附近人正在使用的App数据
        [self requestNearApps:location];
    }
}

@end
