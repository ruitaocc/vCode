//
//  InfoDetailViewController.m
//  vCode
//
//  Created by ruitaocc on 15/6/15.
//  Copyright (c) 2015年 ruitaocc. All rights reserved.
//

#import "InfoDetailViewController.h"

#import "../Pods/MMMaterialDesignSpinner/Pod/Classes/MMMaterialDesignSpinner.h"
@interface InfoDetailViewController ()
@property(strong, nonatomic)MMMaterialDesignSpinner *m_spinnerView;
@end

@implementation InfoDetailViewController
@synthesize m_webView;
@synthesize m_spinnerView;
@synthesize url;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"infodetail", nil)];
    // Do any additional setup after loading the view.
    NSURL *nurl =[NSURL URLWithString:url];
    NSLog(@"%@",url);
    NSURLRequest *request =[NSURLRequest requestWithURL:nurl];
    
    //
    
    CGRect frame = self.view.frame;
    //frame.origin.y = 40;
    //frame.size.height = frame.size.height - 40;
    m_webView = [[UIWebView alloc] initWithFrame:frame];
    [m_webView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:m_webView];
    [m_webView setScalesPageToFit:YES];
    [m_webView setDelegate:self];
    
    CGRect spinner_frame ;
    spinner_frame.size.width = 40;
    spinner_frame.size.height = 40;
    spinner_frame.origin.x = (self.view.frame.size.width-spinner_frame.size.width)/2;
    spinner_frame.origin.y = (self.view.frame.size.height-spinner_frame.size.height)/2;
    m_spinnerView = [[MMMaterialDesignSpinner alloc] initWithFrame:spinner_frame];
    m_spinnerView.lineWidth = 2.5f;
    m_spinnerView.tintColor = [UIColor colorWithRed:69/255.0 green:209.0/255.0 blue:250/255.0 alpha:1.0];
    [self.view addSubview:m_spinnerView];
    [m_webView loadRequest:request];
    
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [m_spinnerView startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [m_spinnerView stopAnimating];
};
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
