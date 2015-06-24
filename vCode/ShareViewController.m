//
//  ShareViewController.m
//  vCode
//
//  Created by ruitaocc on 15/6/23.
//  Copyright (c) 2015年 ruitaocc. All rights reserved.
//

#import "ShareViewController.h"
#import "WZFlashButton.h"
#import "UMSocial_Sdk_4.2.3/Header/UMSocial.h"
#import "UMSocial_Sdk_Extra_Frameworks/Wechat/WXApi.h"
#import "UMSocial_Sdk_Extra_Frameworks/Wechat/UMSocialWechatHandler.h"
#define TabHeight 49.0f
#define ParaHeight 64.0f
#define StatusBatHeight 22.0f
#define NavBatHeight 44.0f
#define myBlue [UIColor colorWithRed:67.0/255.0f green:209.0f/255.0f blue:250.0/255.0 alpha:1.0f]

@interface UIButton (UIButtonImageWithLable)
- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType;
@end
//
@implementation UIButton (UIButtonImageWithLable)
- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType {
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    
    CGSize titleSize = [title sizeWithAttributes: @{NSFontAttributeName: [UIFont systemFontOfSize:14]}];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self setImageEdgeInsets:UIEdgeInsetsMake(-8.0,
                                              0.0,
                                              0.0,
                                              -titleSize.width)];
    [self setImage:image forState:stateType];
    
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:[UIFont systemFontOfSize:(14.0f)]];
    [self.titleLabel setTextColor:[UIColor blackColor]];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(30.0,
                                              -image.size.width,
                                              0.0,
                                              0.0)];
    [self setTitle:title forState:stateType];
}

@end
//- (void)centerImageAndTitle:(float)spacing
//{
//    // get the size of the elements here for readability
//    CGSize imageSize = self.imageView.frame.size;
//    CGSize titleSize = self.titleLabel.frame.size;
//    
//    // get the height they will take up as a unit
//    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
//    
//    // raise the image and push it right to center it
//    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
//    
//    // lower the text and push it left to center it
//    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height),0.0);
//}
//
//- (void)centerImageAndTitle
//{
//    const int DEFAULT_SPACING = 6.0f;
//    [self centerImageAndTitle:DEFAULT_SPACING];
//}
//-(void)layoutSubviews {
//    [super layoutSubviews];
//    
//    // Center image
//    CGPoint center = self.imageView.center;
//    center.x = self.frame.size.width/2;
//    center.y = self.imageView.frame.size.height/2;
//    self.imageView.center = center;
//    
//    //Center text
//    CGRect newFrame = [self titleLabel].frame;
//    newFrame.origin.x = 0;
//    newFrame.origin.y = self.imageView.frame.size.height + 5;
//    newFrame.size.width = self.frame.size.width;
//    
//    self.titleLabel.frame = newFrame;
//    self.titleLabel.textAlignment = NSTextAlignmentCenter;
//}
//@end

@interface ShareViewController ()<UMSocialUIDelegate>
@property(strong ,nonatomic)WZFlashButton *m_modify_btn;
@end

@implementation ShareViewController
@synthesize m_modify_btn;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"cut_save_and_share", nil)];
    float s_width = self.view.frame.size.width;
    float s_height = self.view.frame.size.height;
    
    UIView *saveView = [[UIView alloc] initWithFrame:CGRectMake(0, StatusBatHeight+NavBatHeight, s_width, (s_height-StatusBatHeight-NavBatHeight)/2)];
    
    UIImage *saveokImg = [UIImage imageNamed:@"saveok.png"];
    //blackArrow
    CGRect rect;
    rect.size.width = 0.2*s_width;
    rect.size.height = rect.size.width;
    rect.origin.x = (s_width-rect.size.width)/2;
    rect.origin.y = 0.3*rect.size.width;
    UIImageView *okImgView = [[UIImageView alloc] initWithFrame:rect];
    [okImgView setImage:saveokImg];
    [saveView addSubview:okImgView];
    
    CGRect btn_frame;
    btn_frame.size.width = 0.4*s_width;
    btn_frame.size.height = 44;
    btn_frame.origin.x = (s_width - btn_frame.size.width)/2;
    btn_frame.origin.y = (s_height - TabHeight - ParaHeight)/2 - 44 -6 ;
    m_modify_btn = [[WZFlashButton alloc]initWithFrame:btn_frame];
    m_modify_btn.textLabel.font = [UIFont systemFontOfSize:14];
    [m_modify_btn setText:NSLocalizedString(@"retouch", nil) withTextColor:[UIColor whiteColor]];
    m_modify_btn.layer.cornerRadius = 5;
    [m_modify_btn clipsToBounds];
    __weak typeof(self) weakSelf = self;
    m_modify_btn.clickBlock = ^{
        [weakSelf modify];
    };
    [m_modify_btn setBackgroundColor:[UIColor colorWithRed:67.0/255.0f green:209.0f/255.0f blue:250.0/255.0 alpha:1.0f]];
    [saveView addSubview:m_modify_btn];

    
    //label
    CGRect lrect;
    lrect.size.width = s_width;
    lrect.size.height = 44;
    lrect.origin.x = 0;
    lrect.origin.y = ((s_height-StatusBatHeight-NavBatHeight)/2-(rect.origin.y+rect.size.height) - btn_frame.origin.y)/2+rect.origin.y+rect.size.height;
    UILabel *saveedLabel = [[UILabel alloc] initWithFrame:lrect];
    [saveedLabel setText:NSLocalizedString(@"saveed_note", nil)];
    [saveedLabel setTextAlignment:NSTextAlignmentCenter];
    [saveedLabel setTextColor:[UIColor grayColor]];
    [saveView addSubview:saveedLabel];
    UIView *segView = [[UIView alloc] initWithFrame:CGRectMake(30, (s_height-StatusBatHeight-NavBatHeight)/2 - 2, s_width - 60, 1)];
    [segView setBackgroundColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:0.7]];
    [saveView addSubview:segView];
    
    //
    [self.view addSubview:saveView];
    [self loadShareView];
                                                                
}
-(void)loadShareView{
    float s_width = self.view.frame.size.width;
    float s_height = self.view.frame.size.height;
    float c_width = 0.9*s_width;
    float x_magin = 0.05*s_width;
    float grid_width = c_width/4;
    float grid_height = grid_width*1.2;
    CGRect shareRect;
    shareRect.origin.y  = (s_height-StatusBatHeight-NavBatHeight)/2 + StatusBatHeight + NavBatHeight;
    shareRect.size.height = s_height - shareRect.origin.y;
    shareRect.origin.x = 0;
    shareRect.size.width = s_width;
    UIScrollView * scrollview = [[UIScrollView alloc] initWithFrame:shareRect];
    NSString *filePath = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"shareinfo.plist"];

    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    int i = 0;
    float sHeight = x_magin*2 +grid_height*(ceil([dic count]/4.0));
    NSBundle *bundle = [NSBundle bundleWithIdentifier:@"UMSocialSDKResourcesNew"];
    
    for(NSString *key in [dic allKeys]){
        NSString *itemName = NSLocalizedString(key, nil);
        NSString *itemImg = [NSString stringWithFormat:@"UMSocialSDKResourcesNew.bundle/SnsPlatform/%@",[dic objectForKey:key]];
        UIImage *img = [UIImage imageNamed:itemImg];
        int row = i / 4;
        int column = i % 4;
        float x = x_magin + column * grid_width;
        float y = x_magin + row * grid_height;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, grid_width, grid_height)];
        btn.tag = i+10000;
       // [btn setImage:img forState:UIControlStateNormal];
       // [btn setTitle:itemName forState:UIControlStateNormal];
        
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [btn setImage:img withTitle:itemName forState:UIControlStateNormal];
        //btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
//        CGRect icon;
//        icon.size.width = 0.8*grid_width;
//        icon.size.height = icon.size.width;
//        icon.origin.x = 0.1*grid_width;
//        icon.origin.y = 0;
//        btn.imageView.frame = icon;
//        [btn.imageView clipsToBounds];
//         CGRect b_rect;
//        b_rect.size.width = grid_width;
//        b_rect.size.height = 0.25*grid_width;
//        b_rect.origin.x = 0;
//        b_rect.origin.y = 0.85*grid_width;
//        btn.titleLabel.frame= b_rect;
//        
        [btn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        [scrollview addSubview:btn];
        i++;
    }
    [scrollview setContentSize:CGSizeMake(s_width, sHeight)];
    [self.view addSubview:scrollview];
    //
}
-(void)shareAction:(UIButton*)sender{
    NSLog(@"sender tag:%d",sender.tag);
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:@"shareinfo.plist"];
}
////下面可以设置根据点击不同的分享平台，设置不同的分享文字
//-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
//{
//    if ([platformName isEqualToString:UMShareToSina]) {
//        socialData.shareText = @"分享到新浪微博";
//    }
//    else{
//        socialData.shareText = @"分享内嵌文字";
//    }
//}

-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    NSLog(@"didClose is %d",fromViewControllerType);
}

//下面得到分享完成的回调
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSLog(@"didFinishGetUMSocialDataInViewController with response is %@",response);
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}
-(void)didFinishShareInShakeView:(UMSocialResponseEntity *)response
{
    NSLog(@"finish share with response is %@",response);
}
-(void)modify{
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:@"507fcab25270157b37000010"
//                                      shareText:@"你要分享的文字"
//                                     shareImage:[UIImage imageNamed:@"icon.png"]
//                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,nil]
//                                       delegate:self];
//    //设置友盟社会化组件appkey
//    [UMSocialData setAppKey:@"5566c41067e58e4d69004417"];
//    [UMSocialData openLog:YES];
//    
//    //注册微信
//    [WXApi registerApp:@"wx2fbcb9c2b0d608b7"];
//    //设置图文分享
//    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
//    [[UMSocialControllerService defaultControllerService] setShareText:share_content shareImage:nil socialUIDelegate:nil];
//    [UMSocialWechatHandler setWXAppId:@"wx2fbcb9c2b0d608b7" appSecret:@"df0b45523a99f9c46d0194b16159c746" url:share_url];
//    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
//    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:@"友盟社会化分享让您快速实现分享等社会化功能，http://umeng.com/social" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            NSLog(@"分享成功！");
//        }
//    }];
    //设置分享内容，和回调对象
    NSString *shareText = @"友盟社会化组件可以让移动应用快速具备社会化分享、登录、评论、喜欢等功能，并提供实时、全面的社会化数据统计分析服务。 http://www.umeng.com/social";
    UIImage *shareImage = [UIImage imageNamed:@"lena.jpg"];
    
    [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:shareImage socialUIDelegate:self];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline];
    snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
