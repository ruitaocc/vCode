//
//  InfoDetailViewController.h
//  vCode
//
//  Created by ruitaocc on 15/6/15.
//  Copyright (c) 2015年 ruitaocc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoDetailViewController : UIViewController<UIWebViewDelegate>
@property(strong, nonatomic)IBOutlet UIWebView *m_webView;
@property(strong, nonatomic)NSString *url;
@end
