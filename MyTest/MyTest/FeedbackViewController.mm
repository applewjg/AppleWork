//
//  FeedbackViewController.m
//  MyTest
//
//  Created by Jingui Wang on 1/26/17.
//  Copyright © 2017 jinguiwang. All rights reserved.
//

#import "FeedbackViewController.h"
#import "PrivacyStatementViewController.h"
#import "AppDelegate.h"
#import "MyUIApplication.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (instancetype)init {
	self.hidesBottomBarWhenPushed = YES;
	
	return [super init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	[self.navigationController  setToolbarHidden:NO animated:YES];
	UIBarButtonItem *one = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
	UIBarButtonItem *two = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:nil action:nil];
	UIBarButtonItem *three = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:nil action:nil];
	UIBarButtonItem *four = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:nil action:nil];
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[self setToolbarItems:[NSArray arrayWithObjects:flexItem, one, flexItem, two, flexItem, three, flexItem, four, flexItem, nil]];
	
	
	
	[self setView:_scrollView];
	
	[self setAutomaticallyAdjustsScrollViewInsets:YES];
	
	// Sets up container's background color
	[[self scrollView] setBackgroundColor:[UIColor whiteColor]];
	
	
	// Sets up UI texts
	UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
	[_headerText setText:@"hello world."];
	[_headerText setTextAlignment:NSTextAlignmentNatural];
	[_headerText setFont:font];
	
	font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
	[_disclosureText setFont:font];
	[_disclosureText setText:@"disclosure text"];
	[_disclosureText setTextAlignment:NSTextAlignmentNatural];
	
	
	font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
	[_commentsTitleText setFont:font];
	[_commentsTitleText setText:@"Comments"];
	[_commentsTitleText setTextAlignment:NSTextAlignmentNatural];
	
	font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
	[_commentsTextView setFont:font];
	[_commentsTextView setAccessibilityLabel:@"FeedbackUIFeedbackTextField_AXLabel"];
	[_commentsTextView setTextAlignment:NSTextAlignmentNatural];
	
	font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
	[_customerId setFont:font];
	[_customerId setText:@"12334567890"];
	[_customerId setTextAlignment:NSTextAlignmentNatural];
	
	font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
	[_sessionId setFont:font];
	[_sessionId setText:@"12334567890"];
	[_sessionId setTextAlignment:NSTextAlignmentNatural];
	
	[_audienceInfo setText:@"what a good day"];
	[_audienceInfo setTextAlignment:NSTextAlignmentNatural];
	
	//Revealing usertags collected from HockeyApp.
	NSUserDefaults *appDefaults = [NSUserDefaults standardUserDefaults];
	NSString *tags = [appDefaults objectForKey:@"BITAuthenticatorUserTagsKey"];
	if(tags != nil)
		[_userTags setText: [NSString stringWithFormat:@"%@ %@", @"FeedbackHockeyAppTagsAvailable", tags]];
	else
		[_userTags setText:@"FeedbackHockeyAppTagsUnavailable"];
	[_userTags setTextAlignment:NSTextAlignmentNatural];
	
	
	// Sets up privacy button
	NSMutableString* privacyButtonTitle = [NSMutableString stringWithFormat:@"Privacy Statement"];
	[privacyButtonTitle appendString:@" \u276F"];
	
	font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
	[_privacyButton setFont:font];
	[_privacyButton setTag:1];
	[_privacyButton setTitle:privacyButtonTitle forState:UIControlStateNormal];
	[_privacyButton addTarget:self
					   action:@selector(presentPrivacyStatement:)
			 forControlEvents:UIControlEventTouchUpInside];
	
}

- (void)presentPrivacyStatement:(id)sender
{
	/*
	UIApplication *application = [UIApplication sharedApplication];
	NSURL *URL = [NSURL URLWithString:@"https://privacy.microsoft.com/en-us/privacystatement"];
	[application openURL:URL options:@{} completionHandler:^(BOOL success) {
		if (success) {
			NSLog(@"Opened url");
		}
	}];*/
	
	NSLog(@"presentPrivacyStatement");
	
	PrivacyStatementViewController *pVC = [[PrivacyStatementViewController alloc] initWithNibName:@"PrivacyStatementViewController" bundle:nil];

	pVC.title = @"Feedback Viewer";

	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd  target:self action:@selector(selectRightAction:)];
	pVC.navigationItem.rightBarButtonItem = rightButton;
	
	[[pVC navigationController] setNavigationBarHidden:NO];
	
	[[self navigationController] pushViewController:pVC animated:YES];

}

- (void)viewWillDisappear:(BOOL)animated {
	[self.navigationController  setToolbarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
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
