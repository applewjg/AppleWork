

#import "ViewModelClass.h"
#import "PublicModel.h"

@interface PublicWeiboViewModel : ViewModelClass
//获取围脖列表
-(void) fetchPublicWeiBo;

//跳转到微博详情页
-(void) weiboDetailWithPublicModel: (PublicModel *) publicModel WithViewController: (UIViewController *)superController;
@end
