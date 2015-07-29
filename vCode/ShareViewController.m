//
//  ShareViewController.m
//  vCode
//
//  Created by ruitaocc on 15/6/23.
//  Copyright (c) 2015年 ruitaocc. All rights reserved.
//
#import <AssetsLibrary/AssetsLibrary.h>
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
    [[self titleLabel] setNumberOfLines:2];
    [[self titleLabel]setLineBreakMode:NSLineBreakByWordWrapping];
    CGSize titleSize = [title sizeWithAttributes: @{NSFontAttributeName: [UIFont systemFontOfSize:12.0f]}];
    [self.imageView setContentMode:UIViewContentModeCenter];
    [self setImageEdgeInsets:UIEdgeInsetsMake(-20.0,
                                              0.0,
                                              0.0,
                                              -titleSize.width)];
    [self setImage:image forState:stateType];
    
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:[UIFont systemFontOfSize:(12.0f)]];
    [self.titleLabel setTextColor:[UIColor blackColor]];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(40.0,
                                              -image.size.width,
                                              0.0,
                                              0.0)];
    [self setTitle:title forState:stateType];
}

@end


@interface ShareViewController ()<UMSocialUIDelegate>
@property(strong ,nonatomic)WZFlashButton *m_modify_btn;
@end

@implementation ShareViewController
@synthesize m_modify_btn;
@synthesize m_shareImg;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"cut_save_and_share", nil)];
    float s_width = self.view.frame.size.width;
    float s_height = self.view.frame.size.height;
    float c_width = 0.9*s_width;
    float x_magin = 0.05*s_width;
    float grid_width = c_width/4;
    float grid_height = grid_width*1.2;
    UIView *saveView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, s_width, (s_height-StatusBatHeight-NavBatHeight)/2)];
    
    CGRect shareRect;
    shareRect.origin.y  = 0;
    shareRect.size.height = s_height;
    shareRect.origin.x = 0;
    shareRect.size.width = s_width;
    UIScrollView * scrollview = [[UIScrollView alloc] initWithFrame:shareRect];
    
    NSString *filePath = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"shareplatform.plist"];
    NSArray *sharedic = [NSArray arrayWithContentsOfFile:filePath];
    int i = 0;
    float sHeight = x_magin*2 +grid_height*(ceil([sharedic count]/4.0));
    for(NSArray *item in sharedic){
        NSString *itemName = NSLocalizedString(item[0], nil);
        NSString *itemImg = [NSString stringWithFormat:@"UMSocialSDKResourcesNew.bundle/SnsPlatform/%@",item[1]];
        UIImage *img = [UIImage imageNamed:itemImg];
        int row = i / 4;
        int column = i % 4;
        float x = x_magin + column * grid_width;
        float y = x_magin + saveView.frame.origin.y+saveView.frame.size.height+ row * grid_height;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, grid_width, grid_height)];
        btn.tag = i+10000;
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [btn setImage:img withTitle:itemName forState:UIControlStateNormal];
        //btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 5.0f;
        [btn clipsToBounds];
         [btn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        [scrollview addSubview:btn];
        i++;
    }
    [self.view addSubview:scrollview];

    
    
    
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
    btn_frame.origin.y = (s_height - TabHeight - ParaHeight)/2 - 44 - 16 ;
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
    lrect.origin.y = rect.origin.y+rect.size.height;
    UILabel *saveedLabel = [[UILabel alloc] initWithFrame:lrect];
    [saveedLabel setText:NSLocalizedString(@"saveed_note", nil)];
    [saveedLabel setTextAlignment:NSTextAlignmentCenter];
    [saveedLabel setTextColor:[UIColor grayColor]];
    [saveView addSubview:saveedLabel];
    UIView *segView = [[UIView alloc] initWithFrame:CGRectMake(30, (s_height-StatusBatHeight-NavBatHeight)/2 - 2, s_width - 60, 1)];
    [segView setBackgroundColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:0.7]];
    [saveView addSubview:segView];
    //share label
    
    lrect.size.width = s_width-60;
    lrect.size.height = 16;
    lrect.origin.x = 30;
    lrect.origin.y = ((s_height-StatusBatHeight-NavBatHeight)/2 - 2) - 16;
    UILabel *shareLabel = [[UILabel alloc] initWithFrame:lrect];
    [shareLabel setText:NSLocalizedString(@"sharelabel", nil)];
    [shareLabel setTextAlignment:NSTextAlignmentLeft];
    [shareLabel setFont:[UIFont systemFontOfSize:14]];
    [shareLabel setTextColor:[UIColor grayColor]];
    [saveView addSubview:shareLabel];
    
    //
    [scrollview addSubview:saveView];
    [scrollview setContentSize:CGSizeMake(s_width, sHeight+saveView.frame.size.height)];
    
    //[self loadShareView];
    //
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"home", nil)
                                                                    style:UIBarButtonItemStyleDone target:self action:@selector(goBackHome)];
    //rightButton.image = [UIImage imageNamed:@"like_icon.png"];
    self.navigationItem.rightBarButtonItem = rightButton;
                                                                
}
-(void)getVerifiedList{
    
    
    
}
-(void)goBackHome{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)loadShareView{
        //
}
-(void)shareAction:(UIButton*)sender{
    
    NSLog(@"sender tag:%d",(int)sender.tag);
    //NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:@"shareinfo.plist"];
    
    NSString *shareText = @"友盟社会化组件可以让移动应用快速具备社会化分享、登录、评论、喜欢等功能，并提供实时、全面的社会化数据统计分析服务。 http://www.umeng.com/social";
    UIImage *shareImage = m_shareImg;
    
   // [[UMSocialControllerService defaultControllerService]setSocialUIDelegate:self];
    [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:shareImage socialUIDelegate:self];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline];
    snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    
}
//下面可以设置根据点击不同的分享平台，设置不同的分享文字
-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    
    
    //UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:m_shareImg_URL]];
    if([platformName isEqualToString:UMShareToWechatTimeline]){
        NSLog(@"wechat");
        NSLog(@"m_shareImg:%@",m_shareImg);
        socialData.shareText = @"#from 2V码";
        socialData.shareImage = m_shareImg;//[UIImage imageNamed:@"lena.jpg"];
        socialData.extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    }
    else if ([platformName isEqualToString:UMShareToSina]) {
        socialData.shareText = @"分享到新浪微博";
    }
    else{
        socialData.shareText = @"分享内嵌文字";
    }
    
    
}

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
    [self.navigationController popViewControllerAnimated:YES];
    return;
    
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
