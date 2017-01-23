
#import "PublicCell.h"

@interface PublicCell ()
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UITextView *weiboText;

@end

@implementation PublicCell

-(void) setValueWithDic : (PublicModel *) publicModel
{
    _userName.text = publicModel.userName;
    _date.text = publicModel.date;
    _weiboText.text = publicModel.text;
	UIImage *images = [UIImage imageWithData:[NSData dataWithContentsOfURL:publicModel.imageUrl]];
	DDLog(@"NSURL:%@", publicModel.imageUrl);
	_headImageView.image = images;
    //[_headImageView setImageWithURL:publicModel.imageUrl];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
