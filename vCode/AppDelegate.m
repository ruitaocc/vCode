//
//  AppDelegate.m
//  vCode
//
//  Created by ruitaocc on 15/4/19.
//  Copyright (c) 2015年 ruitaocc. All rights reserved.
//

#import "AppDelegate.h"
#import <MediaPlayer/MPMoviePlayerController.h>
#import <MediaPlayer/MPMoviePlayerViewController.h>
#import "../Pods/UMengFeedback/UMFeedback_iOS_2.3/UMengFeedback_SDK_2.3/UMFeedback.h"
#import "UMSocial.h"

#import "UMSocialYixinHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialInstagramHandler.h"
#import "UMSocialWhatsappHandler.h"
#import "UMSocialLineHandler.h"
#import "UMSocialTumblrHandler.h"
#import "UIDeviceHardware.h"
#import "HistoryEntry.h"

#define UmengAppkey @"5566c41067e58e4d69004417"
#define WechatAppid @"wx2fbcb9c2b0d608b7"

#define WechatSecret @"df0b45523a99f9c46d0194b16159c746"
#define VcodeHome @"http://www.2vma.co"

#define QQAppid @"1104741802"
#define QQAppKey @"vVW7B16n1TIc8WWP"

#define InstagramAppid @"990cd77e467a404eaf50df8ed7838d93"
#define InstagramAppKey @"27796fc5662f4df2ae642a6b8ccce9db"

#define FacebookAppid @"103395366670682"
#define FacebookAppKey @"0d38521dd72a49ab9a1fc54fd030c091"

#define SinaAppid @"2296515498"
#define SinaAppKey @"9758e17bd2305eaedca27016d3bb1d2b"

#define YixinAppid @"yx9a50f14ca0a948d8b3e331a5f0f4fca7"

@interface AppDelegate (){
    bool isSkip;
}

@property (strong, nonatomic) UIView *lunchView;
@property (strong, nonatomic) UIView *moviePlayView;
@property (strong,nonatomic)MPMoviePlayerViewController *moviePlayerController;

@property (strong,nonatomic)UIButton *skip_btn;
@property (strong,nonatomic)UIImageView *intro_musk;
@end

@implementation AppDelegate

@synthesize moviePlayerController;
@synthesize lunchView;
@synthesize moviePlayView;
@synthesize skip_btn;
@synthesize intro_musk;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /*test*/
    
    [self configUMeng];
    
    UIDeviceHardware* hw = [[UIDeviceHardware alloc] init];
    BOOL is_ip56 = [hw Is_IPH_56];
    
    // Override point for customization after application launch.
    //splash animation
    [self.window makeKeyAndVisible];
    lunchView = [[NSBundle mainBundle ]loadNibNamed:@"LaunchScreen" owner:nil options:nil][0];
    lunchView.frame = CGRectMake(0, 0, self.window.screen.bounds.size.width, self.window.screen.bounds.size.height);
    
    NSURL *videoURL;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"intro" ofType:@"mp4"];
    //判断是网络地址还是本地播放地址
    if ([path hasPrefix:@"http://"]) {
        videoURL = [NSURL URLWithString:path];
    }else{
        videoURL = [NSURL fileURLWithPath:path];
    }	
    moviePlayerController= [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
    float width = 0.57*self.window.screen.bounds.size.width, height = width;
    float x =  (self.window.screen.bounds.size.width-width)/2.0;
    float y =  (self.window.screen.bounds.size.height-height)/2.0;
    [moviePlayerController.view setFrame:CGRectMake(x,y,width,height)];
    moviePlayerController.moviePlayer.movieSourceType=MPMovieSourceTypeFile;
    [moviePlayerController.moviePlayer setScalingMode:MPMovieScalingModeNone];
    [moviePlayerController.moviePlayer setRepeatMode:MPMovieRepeatModeOne];
    [moviePlayerController.moviePlayer setControlStyle:MPMovieControlStyleNone];
    [moviePlayerController.moviePlayer setFullscreen:NO animated:YES];
    [moviePlayerController.moviePlayer play];
    //视频播放组件的容器,加这个容器是为了兼容iOS6,如果不加容器在iOS7下面没有任何问题,如果在iOS6下面视频的播放画面会自动铺满self.view;
    moviePlayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width,height)];
    [lunchView addSubview:moviePlayView];
    [moviePlayView addSubview:[moviePlayerController.moviePlayer view]];
    
    //
    float exWidth = 330.0*351.0/325.0;
    float musk_with = exWidth*width/333.0 , musk_height = musk_with;
    float mx =  (self.window.screen.bounds.size.width-musk_with)/2.0;
    float my =  (self.window.screen.bounds.size.height-musk_height)/2.0;
    UIImage *intro_musk_img = [UIImage imageNamed:@"intro_musk351_325.png"];
    intro_musk = [[UIImageView alloc] initWithFrame:CGRectMake(mx, my, musk_with, musk_height)];
    [intro_musk setImage:intro_musk_img];
    [lunchView addSubview:intro_musk];
    
    CGRect btnframe;
    btnframe.size.width = 0.8*width;
    btnframe.size.height = 0.25*btnframe.size.width;
    btnframe.origin.x = (self.window.screen.bounds.size.width-btnframe.size.width)/2;
    btnframe.origin.y= y+height+(self.window.screen.bounds.size.height-y-height)/2*0.7;
    skip_btn = [[UIButton alloc] initWithFrame:btnframe];
    UIImage *skipBG = [UIImage imageNamed:@"skip_normal_w.png"];
    [skip_btn setBackgroundImage:skipBG forState:UIControlStateNormal];
    UIImage *skipCL = [UIImage imageNamed:@"skip_highlight.png"];
    [skip_btn setBackgroundImage:skipCL forState:UIControlStateHighlighted];
    //skip_btn set
    [skip_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [skip_btn setTitle:NSLocalizedString(@"skip_text", nill) forState:UIControlStateNormal];
    if(!is_ip56){
        [[skip_btn titleLabel]setFont:[UIFont systemFontOfSize:14]];
    }
    [lunchView addSubview:skip_btn];
    [skip_btn addTarget:self action:@selector(skip_btn_click) forControlEvents:UIControlEventTouchUpInside];
    float sheight = self.window.screen.bounds.size.height;
    
    float sweight = self.window.screen.bounds.size.width;
    
//    UIImage *grid_bg_img = [UIImage imageNamed:@"ip56bg"];
//    UIImageView *grid_bg_view = [[UIImageView alloc]initWithFrame:CGRectMake(40,20,sweight,sheight) ];
//    [grid_bg_view setContentMode:UIViewContentModeScaleAspectFill];
//    [grid_bg_view setImage:grid_bg_img];
//    
//    float grid_unit_width = self.window.screen.bounds.size.width/10.0;
//
    NSLog(@"%f %f",sheight,sweight);
//    float tx = 2*grid_unit_width;
//    float ty = sheight/2+8*grid_unit_width;
//    UIImage *timg = [UIImage imageNamed:@"128.jpg"];
//    UIImageView *tview = [[UIImageView alloc]initWithFrame:CGRectMake(tx, ty, grid_unit_width, grid_unit_width)];
//    [tview setContentMode:UIViewContentModeScaleAspectFill];
//    [tview setImage:timg];
    
    
    [self.window addSubview:lunchView];
//    [self.window addSubview:grid_bg_view];
//    [self.window addSubview:tview];
    //[self.window bringSubviewToFront:lunchView];
    isSkip = false;
    [NSTimer scheduledTimerWithTimeInterval:65 target:self selector:@selector(removeLun) userInfo:nil repeats:NO];
    
    //UMengFeedBack otion
    return YES;
}
-(void)configUMeng{
    //feedback sdk
    [UMFeedback setAppkey:UmengAppkey];
    
    //sns sdk//设置友盟社会化组件appkey
    [UMSocialData setAppKey:UmengAppkey];
    
    //打开调试log的开关
    [UMSocialData openLog:YES];
    
    //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
    //[UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
    
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:WechatAppid appSecret:WechatSecret url:VcodeHome];
    

    //打开新浪微博的SSO开关
    //   [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    //    [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //打开腾讯微博SSO开关，设置回调地址，只支持32位
    //    [UMSocialTencentWeiboHandler openSSOWithRedirectUrl:@"http://sns.whalecloud.com/tencent2/callback"];
    
    //    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:QQAppid appKey:QQAppKey url:VcodeHome];
    
    //    //设置易信Appkey和分享url地址
    [UMSocialYixinHandler setYixinAppKey:YixinAppid url:VcodeHome];
    
    //    //设置来往AppId，appscret，显示来源名称和url地址，只支持32位
    //    [UMSocialLaiwangHandler setLaiwangAppId:@"8112117817424282305" appSecret:@"9996ed5039e641658de7b83345fee6c9" appDescription:@"友盟社会化组件" urlStirng:@"http://www.umeng.com/social"];
    
    //打开人人网SSO开关
    //[UMSocialRenrenHandler openSSO];
    
    //使用友盟统计
    //[MobClick startWithAppkey:UmengAppkey];
    
    ////    设置facebook应用ID，和分享纯文字用到的url地址
    //[UMSocialFacebookHandler setFacebookAppID:@"91136964205" shareFacebookWithURL:@"http://www.umeng.com/social"];
    //
    ////    下面打开Instagram的开关
    [UMSocialInstagramHandler openInstagramWithScale:NO paddingColor:[UIColor blackColor]];
    //
    //[UMSocialTwitterHandler openTwitter];
    
    //打开whatsapp
    [UMSocialWhatsappHandler openWhatsapp:UMSocialWhatsappMessageTypeImage];
    
    //打开Tumblr
    [UMSocialTumblrHandler openTumblr];
    
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatFavorite,UMShareToWechatTimeline]];
    //打开line
    NSLog(@"share app names:%@",NSLocalizedStringFromTable(@"wechat_session", @"UMSocialLocalizable", nil));
    [UMSocialLineHandler openLineShare:UMSocialLineMessageTypeImage];
    for (NSString *snsName in [UMSocialSnsPlatformManager sharedInstance].allSnsValuesArray) {
        NSLog(@"%@",snsName);
    }
}

-(void)skip_btn_click{
    [self removeLun];
}
#pragma mark -------------------视频播放结束委托--------------------

/*
 @method 当视频播放完毕释放对象
 */
-(void)myMovieFinishedCallback:(NSNotification*)notify
{
    //视频播放对象
    MPMoviePlayerController* theMovie = [notify object];
    //销毁播放通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:theMovie];
    [theMovie.view removeFromSuperview];
  
}
-(void)removeLun {
    if(!isSkip){
        [intro_musk  removeFromSuperview];
        [skip_btn removeFromSuperview];
        [moviePlayerController.moviePlayer.view removeFromSuperview];
        [moviePlayView removeFromSuperview];
        [lunchView removeFromSuperview];
        isSkip=!isSkip;
    }
}
/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UMSocialSnsService  applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
