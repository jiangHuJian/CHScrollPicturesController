//
//  XABannerDetailController.m
//  XinAnSport
//
//  Created by baoju_mac_2 on 16/7/25.
//  Copyright © 2016年 baoju_yuanweiquan. All rights reserved.
//

#import "CHBannerDetailController.h"
#import "WebViewJavascriptBridge.h"
#import "CHScrollPicturesController.h"

#define CHBackGroundColor [UIColor colorWithRed:(236)/255.0 green:(237)/255.0 blue:(239)/255.0 alpha:1.0]
#define IPHONEWIDTH [UIScreen mainScreen].bounds.size.width

#define IPHONEHEIGHT [UIScreen mainScreen].bounds.size.height

@interface CHBannerDetailController ()<UIWebViewDelegate>
{
    UIActivityIndicatorView *activityIndicatorView;
    UIView *opaqueView;
}
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)NSMutableArray *imageUrls;
@property(nonatomic,strong)NSMutableArray *imageSizeArr;
@property WebViewJavascriptBridge* bridge;

@end

@implementation CHBannerDetailController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    
}

- (void)setupView
{
    self.view.backgroundColor = CHBackGroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, IPHONEWIDTH, IPHONEHEIGHT-64)];
    [self.view addSubview:self.webView];
    self.webView.backgroundColor = CHBackGroundColor;
    [self.webView setUserInteractionEnabled:YES];//是否支持交互
    
    self.webView.delegate=self;
    [self.webView setOpaque:NO];//opaque是不透明的意思
    [self.webView setScalesPageToFit:YES];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://115.28.91.6:9999/sportsApi/jsp/forum/headlines/detail/17"]];
    [self.webView loadRequest:request];
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] init];
    activityIndicatorView.center = self.webView.center;
    activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [activityIndicatorView startAnimating];
    [self.webView addSubview:activityIndicatorView];
    
}


-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [activityIndicatorView stopAnimating];
    [activityIndicatorView setHidden:YES];
    //    NSString *jsToGetHTMLSource = @"document.getElementsByTagName('html')[0].innerHTML";
    //
    //    NSMutableString *HTMLSource = (NSMutableString *)[self.webView stringByEvaluatingJavaScriptFromString:jsToGetHTMLSource];
    //
    
    //    CGFloat documentWidth = [[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('content').offsetWidth"] floatValue];
    //    CGFloat documentHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"content\").offsetHeight;"] floatValue];
    //    NSLog(@"documentSize = {%f, %f}", documentWidth, documentHeight);
    //
    //    //方法2
    //    CGRect frame = webView.frame;
    //    frame.size.width = IPHONEWIDTH;
    //    frame.size.height = 1;
    //
    //    //    wb.scrollView.scrollEnabled = NO;
    //    webView.frame = frame;
    //
    //    frame.size.height = webView.scrollView.contentSize.height;
    //
    //    NSLog(@"frame = %@", [NSValue valueWithCGRect:frame]);
    //    webView.frame = frame;
    
    //对应的初始化代码如下，在初始化中直接包含了一个用于接收JS的回调：
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [_bridge setWebViewDelegate:self];
    
    //js向oc发送数据, 获取图片
    [_bridge registerHandler:@"getImageUrls" handler:^(id data, WVJBResponseCallback responseCallback) {
        //oc向js回调
        self.imageUrls =[NSMutableArray new];
        self.imageUrls = data[@"imageUrl"];
        self.imageSizeArr = [NSMutableArray new];
        self.imageSizeArr = data[@"imageSize"];
    }];
    
    [_bridge registerHandler:@"ClickImage" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        CHScrollPicturesController *VC  =[[CHScrollPicturesController alloc]init];
        VC.photos = self.imageUrls;
        VC.imageSizes = self.imageSizeArr;
        VC.index = [data[@"index"] integerValue];
        [self.navigationController pushViewController:VC animated:YES];
    }];
    
    NSString *jsPath = [[NSBundle mainBundle] pathForResource:@"app" ofType:@"js"];
    NSString *string = [[NSString  alloc] initWithContentsOfFile:jsPath encoding:NSUTF8StringEncoding error:nil];
    
    
    [webView stringByEvaluatingJavaScriptFromString:string];
    //
    //    [self.webView loadHTMLString:HTMLSource baseURL:nil];
    
}





/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
