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
#import "UMSocial_Sdk_4.2.3/Header/UMSocial.h"
#import "UIDeviceHardware.h"
#import "HistoryEntry.h"

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
    HistoryEntry *h1 = [[HistoryEntry alloc] init];
    [h1 saveToDB];
    sleep(2);
    
    HistoryEntry *h2 = [[HistoryEntry alloc] init];

    [h2 saveToDB];
    sleep(2);
    HistoryEntry *h3 = [[HistoryEntry alloc] init];

    [h3 saveToDB];
    sleep(2);
    NSMutableArray *his = [HistoryEntry getAllHistory];
    NSLog(@"history row:%d",(int)[his count]);
    
    
    
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
    [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(removeLun) userInfo:nil repeats:NO];
    
    //UMengFeedBack otion
    
    [UMFeedback setAppkey:@"5566c41067e58e4d69004417"];
    [UMSocialData setAppKey:@"5566c41067e58e4d69004417"];
    return YES;
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
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
