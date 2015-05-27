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
@interface AppDelegate ()

@property (strong, nonatomic) UIView *lunchView;
@end

@implementation AppDelegate


@synthesize lunchView;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
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
    MPMoviePlayerViewController *_moviePlayerController= [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
    int x =  (self.window.screen.bounds.size.width-333)/2;
    int y =  (self.window.screen.bounds.size.height-333)/2*0.6;
    
    [_moviePlayerController.view setFrame:CGRectMake(x,y,333,333)];
    _moviePlayerController.moviePlayer.movieSourceType=MPMovieSourceTypeFile;
    [_moviePlayerController.moviePlayer setScalingMode:MPMovieScalingModeNone];
    [_moviePlayerController.moviePlayer setRepeatMode:MPMovieRepeatModeOne];
    [_moviePlayerController.moviePlayer setControlStyle:MPMovieControlStyleNone];
    [_moviePlayerController.moviePlayer setFullscreen:NO animated:YES];
    [_moviePlayerController.moviePlayer play];
    //视频播放组件的容器,加这个容器是为了兼容iOS6,如果不加容器在iOS7下面没有任何问题,如果在iOS6下面视频的播放画面会自动铺满self.view;
    UIView *moviePlayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 333, 333)];
    [self.window addSubview:moviePlayView];
    [moviePlayView addSubview:[_moviePlayerController.moviePlayer view]];
    
    
    //[self.window addSubview:lunchView];
    
    [self.window bringSubviewToFront:lunchView];
    
    //[self.window bringSubviewToFront:webView];
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(removeLun) userInfo:nil repeats:NO];
    return YES;
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
    [lunchView removeFromSuperview];
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
