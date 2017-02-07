//
//  PrivacyStatementVCViewController.m
//  MyTest
//
//  Created by Jingui Wang on 1/26/17.
//  Copyright © 2017 jinguiwang. All rights reserved.
//

#import "PrivacyStatementViewController.h"

@interface PrivacyStatementViewController ()
@property (nonatomic, retain) IBOutlet UIWebView* webView;

@end

@implementation PrivacyStatementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSLog(@"清除cookies");
	NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	for (NSHTTPCookie *cookie in [storage cookies]) {
		[storage deleteCookie:cookie];
	}
	NSLog(@"清除UIWebView的缓存");
	[[NSURLCache sharedURLCache] removeAllCachedResponses];
	
    // Do any additional setup after loading the view from its nib.
	NSURL *url = [NSURL URLWithString:@"https://privacy.microsoft.com/en-us/privacystatement"];
	//NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url]; // url的位置
	[_webView setScalesPageToFit:YES];
	[_webView loadRequest:urlRequest];
	[_webView setDelegate:self];
	[self setTitle:@"FeedbackPrivacyStatement"];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
#pragma mark 开始加载网页
- (void)webViewDidStartLoad:(UIWebView *)webView {
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

#pragma mark 网页加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView {
	NSLog(@"%@", NSStringFromSelector(_cmd));
	
	
	// This delegate can be potentially called multiple times even when the content hasn't finished loading...
	if ([webView isLoading])
	{
		return;
	}

	// The following code is used to resize the web page content based on width of the view of PrivacyStatementViewController
	// Otherwise, only the small portion of the top left corner the privacy statement page (which is not mobile friendly) will
	// be displayed instead.

/*	CGSize viewSize = [[self view] bounds].size;
	[[webView scrollView] setContentSize:viewSize];

*/
}

#pragma mark 网页加载出错
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	NSLog(@"%@:%@", NSStringFromSelector(_cmd), error.localizedDescription);
}

#pragma mark 网页监听
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSLog(@"%@", NSStringFromSelector(_cmd));
	return YES;
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
