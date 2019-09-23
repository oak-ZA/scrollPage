//
//  ZAScrollerView.m
//  ScrollerContinue
//
//  Created by 张奥 on 2019/9/23.
//  Copyright © 2019 张奥. All rights reserved.
//

#import "ZAScrollerView.h"
#import "YYAnimatedImageView.h"
#import "YYImage.h"
#import "YYWebImage.h"
@interface ZAScrollerView()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) NSInteger prePageIndex;
@property (nonatomic, assign) NSTimer *timer;
@property (nonatomic, assign) void (^tapBlock)(NSInteger tapIndex);
@end
@implementation ZAScrollerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initScrollView];
        [self initPageControl];
        [self initTapGesture];
    }
    return self;
}

-(void)initScrollView{
    // 初始化尺寸
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    // 设置分页效果
    _scrollView.pagingEnabled = YES;
    // 水平滚动条隐藏
    _scrollView.showsHorizontalScrollIndicator = NO;
    // 设置到边的弹性隐藏
    _scrollView.bounces = NO;
    
    // 设置代理
    _scrollView.delegate = self;
    
    [self addSubview:_scrollView];
}

-(void)initPageControl{
    // 设置尺寸，坐标，注意纵坐标的起点
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 50, self.frame.size.width, 50)];
    // 设置当前页面索引
    _pageControl.currentPage = 0;
    // 设置未被选中时小圆点颜色
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    // 设置被选中时小圆点颜色
    _pageControl.currentPageIndicatorTintColor = [UIColor purpleColor];
    // 设置能手动点小圆点条改变页数
    _pageControl.enabled = YES ;
    // 把导航条设置为半透明状态
    [_pageControl setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.2]];
    // 设置分页控制器的事件
    [_pageControl addTarget:self action:@selector(pageControlTouched) forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:_pageControl];
}
- (void)initTapGesture
{
    // 点击事件
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] init];
    [gesture addTarget:self action:@selector(pageClick)];
    [self addGestureRecognizer:gesture];
}

-(void)pageControlTouched{
    [self removeTimer];
    
    NSInteger curPageIndex = _pageControl.currentPage;
    if (curPageIndex > _prePageIndex)
    {
        // 右滑
        [self changePageRight];
    }
    else
    {
        // 左滑
        [self changePageLeft];
    }
    
    [self startTimer];
}
#pragma mark - 分页点击回调
- (void)pageClick{
    if (self.tapBlock){
        // 传入当前页面
        if (self.imageArray.count <= 1) {
            self.tapBlock(0);
            return;
        }
        self.tapBlock(_pageControl.currentPage);
    }
}

-(void)setDataSuroces:(NSArray *)dataSurces withCallBackBlock:(TapScrollViewBlock)block{
    self.imageArray = dataSurces;
    self.pageCount = dataSurces.count;
     self.tapBlock = block;
    if (dataSurces.count <= 1) {
         _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [imageView yy_setImageWithURL:[NSURL URLWithString:self.imageArray.lastObject] placeholder:[UIImage imageNamed:@"home_default"]];
        [_scrollView addSubview:imageView];
        return;
    }
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame)*3, CGRectGetHeight(self.frame));
    _pageControl.numberOfPages = self.pageCount;
    
    //设置3个页面
    for (int i=0; i<3; i++) {
        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        imageView.tag = 1000 + i;
        [_scrollView addSubview:imageView];
    }
    
    YYAnimatedImageView *leftImage = [_scrollView viewWithTag:1000];
    YYAnimatedImageView *middleImage = [_scrollView viewWithTag:1001];
    YYAnimatedImageView *rightImage = [_scrollView viewWithTag:1002];
    
    [leftImage yy_setImageWithURL:[NSURL URLWithString:self.imageArray.lastObject] placeholder:[UIImage imageNamed:@"home_default"]];
    [middleImage yy_setImageWithURL:[NSURL URLWithString:self.imageArray.firstObject]  placeholder:[UIImage imageNamed:@"home_default"]];
    [rightImage yy_setImageWithURL:[NSURL URLWithString:self.imageArray[1]]  placeholder:[UIImage imageNamed:@"home_default"]];
    
    // 设置初始偏移量和索引
    _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    _pageControl.currentPage = 0;
    _prePageIndex = 0;
    // 开启定时器
    [self startTimer];
}
#pragma mark - 定时器相关
-(void)startTimer{
    [self removeTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(changePageRight) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}
#pragma mark - 定时器回调
- (void)changePageRight
{
    // 往右滑并且设置小圆点，永远都是滑到第三页
    [_scrollView setContentOffset:CGPointMake(self.frame.size.width * 2, 0) animated:YES];
    [self resetPageIndex:YES];
}
- (void)changePageLeft
{
    // 往左滑，永远都是滑动到第一页
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self resetPageIndex:NO];
}
#pragma mark - 重新设置索引和页面图片
- (void)resetPageIndex:(BOOL)isRight{
    if (isRight){
        // 根据之前的page下标来修改
        if (_prePageIndex == _pageCount - 1){
            // 到头了就回到第一个
            _pageControl.currentPage = 0;
        }else{
            // 这里用_prePageIndex来算，否则点击小圆点条会重复计算了
            _pageControl.currentPage = _prePageIndex + 1;
        }
    }else{
        if (_prePageIndex == 0){
            _pageControl.currentPage = _pageCount - 1;
        }else{
            _pageControl.currentPage = _prePageIndex - 1;
        }
    }
    _prePageIndex = _pageControl.currentPage;
}

- (void)resetPageView
{
    // 每次滑动完了之后又重新设置当前显示的page时中间的page
    YYAnimatedImageView *leftPage = [_scrollView viewWithTag:1000];
    YYAnimatedImageView *middlePage = [_scrollView viewWithTag:1001];
    YYAnimatedImageView *rightPage = [_scrollView viewWithTag:1002];
    
    if (_pageControl.currentPage == _pageCount - 1)
    {
        // n- 1 -> n -> 0
        [leftPage yy_setImageWithURL:[NSURL URLWithString:self.imageArray[_pageControl.currentPage - 1]] placeholder:[UIImage imageNamed:@"home_default"]];
        [middlePage yy_setImageWithURL:[NSURL URLWithString:self.imageArray[_pageControl.currentPage]] placeholder:[UIImage imageNamed:@"home_default"]];
        [rightPage yy_setImageWithURL:[NSURL URLWithString:self.imageArray.firstObject] placeholder:[UIImage imageNamed:@"home_default"]];
        
    }
    else if (_pageControl.currentPage == 0)
    {
        // n -> 0 -> 1
        // 到尾部了，改成从头开始
        [leftPage yy_setImageWithURL:[NSURL URLWithString:self.imageArray.lastObject] placeholder:[UIImage imageNamed:@"home_default"]];
        [middlePage yy_setImageWithURL:[NSURL URLWithString:self.imageArray.firstObject] placeholder:[UIImage imageNamed:@"home_default"]];
        [rightPage yy_setImageWithURL:[NSURL URLWithString:self.imageArray[1]] placeholder:[UIImage imageNamed:@"home_default"]];
    }
    else
    {
        // x - 1 -> x -> x + 1
        [leftPage yy_setImageWithURL:[NSURL URLWithString:self.imageArray[_pageControl.currentPage - 1]] placeholder:[UIImage imageNamed:@"home_default"]];
        [middlePage yy_setImageWithURL:[NSURL URLWithString:self.imageArray[_pageControl.currentPage]] placeholder:[UIImage imageNamed:@"home_default"]];
        [rightPage yy_setImageWithURL:[NSURL URLWithString:self.imageArray[_pageControl.currentPage + 1]] placeholder:[UIImage imageNamed:@"home_default"]];
    }
    
    // 重新设置偏移量
    _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
}

#pragma mark - scrollview滑动代理
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 先停掉定时器
    [self removeTimer];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 手动拖拽滑动结束后
    if (scrollView.contentOffset.x > self.frame.size.width){
        // 右滑
        [self resetPageIndex:YES];
    }else{
        // 左滑
        [self resetPageIndex:NO];
    }
    [self resetPageView];
    
    // 开启定时器
    [self startTimer];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 自动滑动结束后重新设置图片
    [self resetPageView];
}

@end
