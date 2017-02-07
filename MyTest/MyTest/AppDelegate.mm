
#import "AppDelegate.h"
#import "RootViewController.h"
#import "FeedbackViewController.h"
#import "WKWebViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize window = _window;

/*
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
*/

// 当应用程序启动完毕的时候就会调用(系统自动调用)
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.frame = [[UIScreen mainScreen] bounds];
    //self.window.rootViewController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
	
	self.window.backgroundColor = [UIColor whiteColor];
	
	//a.初始化一个tabBar控制器
	UITabBarController *rootTabBar = [[UITabBarController alloc] init];

	//设置控制器为Window的根控制器
	self.window.rootViewController = rootTabBar;
	
	UIViewController *c0 = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
	c0.view.backgroundColor=[UIColor whiteColor];
	
	UINavigationController *nav0 = [[UINavigationController alloc] initWithRootViewController:c0];
	nav0.tabBarItem.title = @"首页";
	
	
	UIViewController *c1 = [[FeedbackViewController alloc] initWithNibName:@"FeedbackView" bundle:nil];
	c1.view.backgroundColor=[UIColor whiteColor];
	UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:c1];
	nav1.tabBarItem.title=@"消息";
	
	//c1.tabBarItem.image=[UIImage imageNamed:@"tab_recent_nor"];
	//c1.tabBarItem.badgeValue=@"123";
	
	UIViewController* c2 = [[WKWebViewController alloc] init];
	UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:c2];
	nav2.tabBarItem.title=@"联系人";
	
	UIViewController *c3=[[UIViewController alloc]init];
	UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:c3];
	nav3.tabBarItem.title=@"动态";
	
	UIViewController *c4=[[UIViewController alloc]init];
	UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:c4];
	nav4.tabBarItem.title=@"设置";
	
	//c.添加子控制器到ITabBarController中
	//c.1第一种方式
	//    [tb addChildViewController:c1];
	//    [tb addChildViewController:c2];
	
	//c.2第二种方式
	rootTabBar.viewControllers=@[nav0, nav1, nav2, nav3,nav4];
	
    [self.window makeKeyAndVisible];
    NSLog(@"didFinishLaunchingWithOptions");
    return YES;
}

// 即将失去活动状态的时候调用(失去焦点, 不可交互)
- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"ResignActive");
}

// 重新获取焦点(能够和用户交互)
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"BecomeActive");
}

// 应用程序进入后台的时候调用
// 一般在该方法中保存应用程序的数据, 以及状态
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"Background");
}

// 应用程序即将进入前台的时候调用
// 一般在该方法中恢复应用程序的数据,以及状态
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"Foreground");
}

// 应用程序即将被销毁的时候会调用该方法
// 注意:如果应用程序处于挂起状态的时候无法调用该方法
- (void)applicationWillTerminate:(UIApplication *)application
{
}

// 应用程序接收到内存警告的时候就会调用
// 一般在该方法中释放掉不需要的内存
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    NSLog(@"MemoryWarning");
}

@end
