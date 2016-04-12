//
//  bigPictureViewController.m
//  LimitFree
//
//  Created by Apple on 16/4/6.
//  Copyright © 2016年 Dordly. All rights reserved.
//

#import "bigPictureViewController.h"
#import "AppdetailModel.h"

@interface bigPictureViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *picNumLabel;

- (IBAction)FinishAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *bigPicScrollView;

- (IBAction)savePicAction:(UIButton *)sender;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *collectionViews;

@end

@implementation bigPictureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateViews];
    self.view.backgroundColor = [UIColor blackColor];
    [self setupViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置视图
-(void)setupViews
{
    //添加手势--UIScrollView
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OnBigScrollViewTap:)];
    
    //将手势添加到self.bigPicScrollView
    [self.bigPicScrollView addGestureRecognizer:tapGesture];    
    
}

//实现手势的回调方法
-(void)OnBigScrollViewTap:(UITapGestureRecognizer *)sender
{
    
    //判断当前是否已显示/隐藏
    if([self.picNumLabel isHidden])
    {
        //显示视图,遍历数组
        for(UIView * view in self.collectionViews)
        {
            view.hidden = NO;
            
            //添加动画效果
            [UIView animateWithDuration:0.5 animations:^{
                
                //
                view.alpha = 1;
            }];
        }
        
        //显示状态栏
        /*
         UIStatusBarAnimationNone,
         UIStatusBarAnimationFade ,
         UIStatusBarAnimationSlide
         */
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    else
    {
        //首先将alpha从1变为0
        //显示视图,遍历数组
        for(UIView * view in self.collectionViews)
        {
            //添加动画效果
            [UIView animateWithDuration:0.5 animations:^{
                
                view.alpha = 0;
                
            } completion:^(BOOL finished) {
                //当动画完成时,隐藏视图
                view.hidden = YES;
            }];
        }
        //隐藏状态栏，1.在info.plist文件中添加View controller-based status bar appearance--NO
        //2.调用以下方法(设置UIApplication的statusBarHidden属性/方法进行显示和隐藏)
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    
}
- (IBAction)FinishAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)savePicAction:(UIButton *)sender
{
    //1.获取图片视图
    UIImageView * currentImageView = self.bigPicScrollView.subviews[self.currentIndex];
    //获取图片
    UIImage * currentImage = currentImageView.image;
    
    //保存图片
    //先判断图片是否存在
    if(currentImage)
    {
        //显示提示信息
        [KVNProgress showWithStatus:@"保存中……"];
        
        //将图片保存到相册中
        /*
         参数1：保存的UIImage对象
         参数2和参数3：就是当保存图片或者失败的回调方法
         */
        
        UIImageWriteToSavedPhotosAlbum(currentImage, self,@selector(saveimage:didFinishSavingWithError:contextInfo:), nil);
    }
}
//当保存图片成功或者失败的回调方法
//返回值，参数列表--方法的格式
-(void)saveimage:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    //判断图片是否保存成功
    if(error)
    {
        [KVNProgress showErrorWithStatus:error.localizedDescription];
    }
    else
    {
        [KVNProgress showSuccessWithStatus:@"YES,成功了!!"];
    }
}
//加载数据
-(void)updateViews
{
    //修改标题
    self.picNumLabel.text = [NSString stringWithFormat:@"%ld Of %ld",self.currentIndex+1,self.photosArray.count];
    
    //将图片添加到UIScrollView中去
    
    CGFloat imageW = kScreenSize.width;
    CGFloat imageH = imageW/1.78;
    CGFloat imageY = CGRectGetMidY([UIScreen mainScreen].bounds)-imageH/2-50;
    
    __weak typeof(self) weakself =self;
    
    [self.photosArray enumerateObjectsUsingBlock:^(PhotosModel * photoModel, NSUInteger idx, BOOL * _Nonnull stop)
     {
         //创建图片视图
         UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageW*idx,imageY,imageW,imageH)];
         
         //将其添加到self.bigPicScrollView
         [weakself.bigPicScrollView addSubview:imageView];
         
         //设置图片
         [imageView sd_setImageWithURL:[NSURL URLWithString:photoModel.originalUrl] placeholderImage:[UIImage imageNamed:@"egopv_photo_placeholder"]];
     }];
    //设置UIScrollView，弹簧效果
    self.bigPicScrollView.bounces = NO;
    
    //按页显示
    self.bigPicScrollView.pagingEnabled = YES;
    
    //设置ContentSize
    self.bigPicScrollView.contentSize = CGSizeMake(imageW * self.photosArray.count, 100);
    self.bigPicScrollView.delegate =self;
    self.bigPicScrollView.contentOffset=CGPointMake(self.currentIndex*imageW, 0);
    
}
// 滚动视图结束减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 获取当前页数
    self.currentIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.picNumLabel.text = [NSString stringWithFormat:@"%ld Of %ld",self.currentIndex+1,self.photosArray.count];
}
@end
