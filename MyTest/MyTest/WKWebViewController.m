
#import "WKWebViewController.h"
#import <WebKit/WebKit.h>

@interface WKWebViewController () <WKNavigationDelegate>

@property(nonatomic, strong) WKWebView* webView;

@end

@implementation WKWebViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	CGRect screen = [[UIScreen mainScreen] bounds];
	
	///按钮栏
	//按钮栏宽
	CGFloat buttonBarWidth = 316;
	UIView* buttonBar = [[UIView alloc] initWithFrame: CGRectMake((screen.size.width - buttonBarWidth) / 2, 80, buttonBarWidth, 30)];
	
	[self.view addSubview:buttonBar];
	
	/// 1.添加LoadHTMLString按钮
	UIButton* buttonLoadHTMLString = [UIButton buttonWithType:UIButtonTypeSystem];
	[buttonLoadHTMLString setTitle:@"LoadHTMLString" forState:UIControlStateNormal];
	buttonLoadHTMLString.frame = CGRectMake(0, 0, 117, 30);
	//指定事件处理方法
	[buttonLoadHTMLString addTarget:self action:@selector(testLoadHTMLString:) forControlEvents: UIControlEventTouchUpInside];
	[buttonBar addSubview: buttonLoadHTMLString];
	
	/// 2.添加LoadData按钮
	UIButton* buttonLoadData = [UIButton buttonWithType:UIButtonTypeSystem];
	[buttonLoadData setTitle:@"LoadData" forState:UIControlStateNormal];
	buttonLoadData.frame = CGRectMake(137, 0, 67, 30);
	//指定事件处理方法
	[buttonLoadData addTarget:self action:@selector(testLoadData:) forControlEvents: UIControlEventTouchUpInside];
	[buttonBar addSubview: buttonLoadData];
	
	/// 3.添加LoadRequest按钮
	UIButton* buttonLoadRequest = [UIButton buttonWithType:UIButtonTypeSystem];
	
	[buttonLoadRequest setTitle:@"LoadRequest" forState:UIControlStateNormal];
	buttonLoadRequest.frame = CGRectMake(224, 0, 92, 30);
	//指定事件处理方法
	[buttonLoadRequest addTarget:self action:@selector(testLoadRequest:) forControlEvents: UIControlEventTouchUpInside];
	[buttonBar addSubview: buttonLoadRequest];
	
	/// 4.添加WKWebView
	self.webView = [[WKWebView alloc] initWithFrame: CGRectMake(0, 140, screen.size.width, screen.size.height - 140)];
	
	[self.view addSubview: self.webView];
	
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


- (void)testLoadHTMLString:(id)sender {
	
	NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
	NSURL *bundleUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
	NSError *error = nil;
	
	NSString *html = [[NSString alloc] initWithContentsOfFile:htmlPath encoding: NSUTF8StringEncoding error:&error];
	
	if (error == nil) {//数据加载没有错误情况下
		[self.webView loadHTMLString:html baseURL:bundleUrl];
	}
}

- (void)testLoadData:(id)sender {
	
	NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
	NSURL *bundleUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
	NSData *htmlData = [[NSData alloc]  initWithContentsOfFile: htmlPath];
	
	[self.webView loadData:htmlData MIMEType:@"text/html" characterEncodingName:@"UTF-8" baseURL:bundleUrl];
	
}

- (void)testLoadRequest:(id)sender {
	
	NSURL * url = [NSURL URLWithString: @"http://www.51work6.com"];
	NSURLRequest * request = [NSURLRequest requestWithURL:url];
	[self.webView loadRequest:request];
	self.webView.navigationDelegate = self;
	
}

#pragma mark  --实现WKNavigationDelegate委托协议
//开始加载时调用
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
	NSLog(@"开始加载");
}
//当内容开始返回时调用
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
	NSLog(@"内容开始返回");
}

//加载完成之后调用
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
	NSLog(@"加载完成");
}

//加载失败时调用
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
	NSLog(@"加载失败 error :  %@", error.description);
}

@end
