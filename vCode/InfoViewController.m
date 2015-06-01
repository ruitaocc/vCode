//
//  InfoViewController.m
//  vCode
//
//  Created by ruitaocc on 15/5/31.
//  Copyright (c) 2015年 ruitaocc. All rights reserved.
//

#import "InfoViewController.h"
#import "../Pods/CTFeedback/Classes/CTFeedbackViewController.h"
@interface InfoViewController ()

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self.view setTitle:NSLocalizedString(@"info_title", nil)];
    [self setTitle:NSLocalizedString(@"info_title", nil)];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"email@2vma.co"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:67.0/255.0f green:209.0f/255.0f blue:250.0/255.0 alpha:1.0f] range:strRange];  //设置颜色
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    CGRect email_frame;
    email_frame.size.width = 100;
    email_frame.size.height = 20;
    email_frame.origin.x = (self.view.frame.size.width -email_frame.size.width+50)/2;
    email_frame.origin.y = (self.view.frame.size.height-40);
   
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(email_frame.origin.x-52, email_frame.origin.y, 50, 20)];
    [emailLabel setTextAlignment:NSTextAlignmentRight];
    [emailLabel setFont:[UIFont systemFontOfSize:13]];
    [emailLabel setTextColor:[UIColor blackColor]];
    [emailLabel setText:@"E-mail:"];
    [self.view addSubview:emailLabel];
    
    UIButton *btn_email = [UIButton buttonWithType:UIButtonTypeCustom];
   [btn_email setFrame:email_frame];
    [[btn_email titleLabel]setTextAlignment:NSTextAlignmentCenter];
    [[btn_email titleLabel] setFont:[UIFont systemFontOfSize:13]];
    [btn_email setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn_email setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];      //btn左对齐
    [btn_email setAttributedTitle:str forState:UIControlStateNormal];
    [btn_email addTarget:self action:@selector(btn_email_click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_email];
    
}
-(void)btn_email_click{
    CTFeedbackViewController *feedbackViewController = [CTFeedbackViewController controllerWithTopics:CTFeedbackViewController.defaultTopics localizedTopics:CTFeedbackViewController.defaultLocalizedTopics];
    feedbackViewController.toRecipients = @[@"email@2vma.co"];
    
    //feedbackViewController.appName =NSLocalizedString(@"info_title", nil);
    feedbackViewController.useHTML = NO;
    [self.navigationController pushViewController:feedbackViewController animated:YES];
}

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
