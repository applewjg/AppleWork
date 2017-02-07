

#import "RootViewController.h"
#import "FeedbackViewController.h"


@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Root View";
	UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(selectLeftAction:)];
	self.navigationItem.leftBarButtonItem = leftButton;
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd  target:self action:@selector(selectRightAction:)];
	self.navigationItem.rightBarButtonItem = rightButton;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectLeftAction:(id)sender {
	NSLog(@"selectLeftAction");
	
	//初始化提示框；
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你点击了导航栏左按钮" preferredStyle:  UIAlertControllerStyleAlert];
	
	[alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		//点击按钮的响应事件；
	}]];
	
	//弹出提示框；
	[self presentViewController:alert animated:true completion:nil];
	
}

- (IBAction)selectRightAction:(id)sender {
	NSLog(@"selectRightAction");
	UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你点击了导航栏右按钮" delegate:self  cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
	[alter show];
}

- (IBAction)gotoSecondView:(id)sender {
	NSLog(@"gotoSecondView");
	FeedbackViewController *secondView = [[FeedbackViewController alloc] init];
	
	//secondView.title = @"Feedback View";
	

	UIButton *button = [UIButton buttonWithType: UIButtonTypeRoundedRect];
	[button setTitle: @"自定义title" forState: UIControlStateNormal];
	[button sizeToFit];
	/*secondView.navigationItem.titleView = button;
	 */
	

	NSArray *array = [NSArray arrayWithObjects:@"鸡翅",@"排骨", nil];
	UISegmentedControl *segmentedController = [[UISegmentedControl alloc] initWithItems:array];
	
	[segmentedController addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	secondView.navigationItem.titleView = segmentedController;

	/*
	secondView.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:secondView action:@selector(back:)];*/
	/*
	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
	temporaryBarButtonItem.title =@"返回";
	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;*/
	
	/*
	UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
								initWithTitle:@"Done"
								style:UIBarButtonItemStyleBordered
								target:self
								action:nil];
	self.navigationController.navigationBar.topItem.backBarButtonItem=btnBack;
	 */
	
	[self.navigationController pushViewController:secondView animated:YES];
}

-(void)segmentAction:(id)sender
{
	switch ([sender selectedSegmentIndex]) {
		case 0:
		{
			UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你点击了鸡翅" delegate:self  cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
			[alter show];
			
		}
			break;
		case 1:
		{
			UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你点击了排骨" delegate:self  cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
			[alter show];
		}
			break;
			
		default:
			break;
	}
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
