

#import <UIKit/UIKit.h>

@interface FeedbackViewController : UIViewController<UIScrollViewDelegate, UITextViewDelegate, UITextFieldDelegate>


@property(nonatomic, retain) IBOutlet UIScrollView* scrollView;

@property(nonatomic, retain) IBOutlet UILabel* headerText;
@property(nonatomic, retain) IBOutlet UILabel* disclosureText;

@property(nonatomic, retain) IBOutlet UILabel* commentsTitleText;
@property(nonatomic, retain) IBOutlet UITextView* commentsTextView;

@property(nonatomic, retain) IBOutlet UILabel* customerId;
@property(nonatomic, retain) IBOutlet UILabel* sessionId;
@property(nonatomic, retain) IBOutlet UILabel* audienceInfo;
@property(nonatomic, retain) IBOutlet UILabel* userTags;

@property(nonatomic, retain) IBOutlet UIButton *privacyButton;

@end
