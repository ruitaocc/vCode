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
@property(strong ,nonatomic)UIImageView *m_super_cai;
@property(strong ,nonatomic)UIImageView *m_super_didi;
@property(strong ,nonatomic)UIImageView *m_super_luo;
@property(strong ,nonatomic)UIImageView *m_super_xiao;
@property(strong ,nonatomic)UIImageView *m_super_center;
@property(strong ,nonatomic)NSString *m_url;
@end

@implementation InfoViewController
@synthesize m_super_cai;
@synthesize m_super_didi;
@synthesize m_super_luo;
@synthesize m_super_xiao;
@synthesize m_super_center;
@synthesize m_url;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self.view setTitle:NSLocalizedString(@"info_title", nil)];
    [self setTitle:NSLocalizedString(@"info_title", nil)];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"email@2vma.co"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:67.0/255.0f green:209.0f/255.0f blue:250.0/255.0 alpha:1.0f] range:strRange];  //设置颜色
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    
    float s_width = self.view.frame.size.width;
    float s_height = self.view.frame.size.height;
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
    
    
    float i_width = s_width/3.5;
    float c_width = s_width/3.0;
    float shift = c_width/5; //sqrt2
    float center_x = s_width/2;
    float center_y = s_height/2;
    
    CGRect frame0 = CGRectMake((s_width-i_width)/2,(s_height-i_width)/2, c_width, c_width);
    UIImage *img0= [UIImage imageNamed:@"2vma.png"];
    m_super_center =  [[UIImageView alloc] initWithFrame:frame0];
    [m_super_center setImage:img0];
    m_super_center.layer.cornerRadius = frame0.size.width/2;
    [m_super_center.layer setMasksToBounds:YES];
    [m_super_center setContentMode:UIViewContentModeScaleAspectFill];
    [m_super_center setClipsToBounds:YES];
    m_super_center.layer.shadowColor = [UIColor blackColor].CGColor;
    m_super_center.layer.shadowOffset = CGSizeMake(4, 4);
    m_super_center.layer.shadowOpacity = 0.5;
    m_super_center.layer.shadowRadius = 2.0;
    m_super_center.layer.borderColor = [[UIColor whiteColor] CGColor];
    m_super_center.layer.borderWidth = 2.0f;
    m_super_center.userInteractionEnabled = YES;
    m_super_center.backgroundColor = [UIColor blackColor];
    m_super_center.tag = 2001;
    UITapGestureRecognizer *portraitTap0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarClick1)];
    [m_super_center addGestureRecognizer:portraitTap0];
    [self.view addSubview:m_super_center];

    
    CGRect frame = CGRectMake(center_x+i_width/2.5, center_y+i_width/2.5, i_width*0.9, i_width*0.9);
    UIImage *img= [UIImage imageNamed:@"cairuitao.jpg"];
    m_super_cai =  [[UIImageView alloc] initWithFrame:frame];
    [m_super_cai setImage:img];
    m_super_cai.layer.cornerRadius = frame.size.width/2;
    [m_super_cai.layer setMasksToBounds:YES];
    [m_super_cai setContentMode:UIViewContentModeScaleAspectFill];
    [m_super_cai setClipsToBounds:YES];
    m_super_cai.layer.shadowColor = [UIColor blackColor].CGColor;
    m_super_cai.layer.shadowOffset = CGSizeMake(4, 4);
    m_super_cai.layer.shadowOpacity = 0.5;
    m_super_cai.layer.shadowRadius = 2.0;
    m_super_cai.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    m_super_cai.layer.borderWidth = 2.0f;
    m_super_cai.userInteractionEnabled = YES;
    m_super_cai.backgroundColor = [UIColor blackColor];
    m_super_cai.tag = 2002;
    UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarClick2)];
    [m_super_cai addGestureRecognizer:portraitTap];
    [self.view addSubview:m_super_cai];
    //
    
    frame = CGRectMake(center_x-i_width-shift, center_y-i_width-shift, i_width, i_width);
    UIImage *img2= [UIImage imageNamed:@"lena.jpg"];
    m_super_didi =  [[UIImageView alloc] initWithFrame:frame];
    [m_super_didi setImage:img2];
    m_super_didi.layer.cornerRadius = frame.size.width/2;
    [m_super_didi.layer setMasksToBounds:YES];
    [m_super_didi setContentMode:UIViewContentModeScaleAspectFill];
    [m_super_didi setClipsToBounds:YES];
    m_super_didi.layer.shadowColor = [UIColor blackColor].CGColor;
    m_super_didi.layer.shadowOffset = CGSizeMake(4, 4);
    m_super_didi.layer.shadowOpacity = 0.5;
    m_super_didi.layer.shadowRadius = 2.0;
    m_super_didi.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    m_super_didi.layer.borderWidth = 2.0f;
    m_super_didi.userInteractionEnabled = YES;
    m_super_didi.backgroundColor = [UIColor blackColor];
    m_super_didi.tag = 2003;
    UITapGestureRecognizer *portraitTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarClick3)];
    [m_super_didi addGestureRecognizer:portraitTap2];
    [self.view addSubview:m_super_didi];
    //
    frame = CGRectMake(center_x+shift*1.5, center_y-i_width-shift*1.9, i_width*1.1, i_width*1.1);
    UIImage *img3= [UIImage imageNamed:@"luojiajun.jpg"];
    m_super_luo =  [[UIImageView alloc] initWithFrame:frame];
    [m_super_luo setImage:img3];
    m_super_luo.layer.cornerRadius = frame.size.width/2;
    [m_super_luo.layer setMasksToBounds:YES];
    [m_super_luo setContentMode:UIViewContentModeScaleAspectFill];
    [m_super_luo setClipsToBounds:YES];
    m_super_luo.layer.shadowColor = [UIColor blackColor].CGColor;
    m_super_luo.layer.shadowOffset = CGSizeMake(4, 4);
    m_super_luo.layer.shadowOpacity = 0.5;
    m_super_luo.layer.shadowRadius = 2.0;
    m_super_luo.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    m_super_luo.layer.borderWidth = 2.0f;
    m_super_luo.userInteractionEnabled = YES;
    m_super_luo.backgroundColor = [UIColor blackColor];
    m_super_luo.tag = 2004;
    UITapGestureRecognizer *portraitTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarClick4)];
    [m_super_luo addGestureRecognizer:portraitTap3];
    [self.view addSubview:m_super_luo];
    //
    frame = CGRectMake(center_x-i_width-shift*1.6, center_y+shift*1.5, i_width*1.1, i_width*1.1);
    UIImage *img4= [UIImage imageNamed:@"wangliwu.jpg"];
    m_super_xiao =  [[UIImageView alloc] initWithFrame:frame];
    [m_super_xiao setImage:img4];
    m_super_xiao.layer.cornerRadius = frame.size.width/2;
    [m_super_xiao.layer setMasksToBounds:YES];
    [m_super_xiao setContentMode:UIViewContentModeScaleAspectFill];
    [m_super_xiao setClipsToBounds:YES];
    m_super_xiao.layer.shadowColor = [UIColor blackColor].CGColor;
    m_super_xiao.layer.shadowOffset = CGSizeMake(4, 4);
    m_super_xiao.layer.shadowOpacity = 0.5;
    m_super_xiao.layer.shadowRadius = 2.0;
    m_super_xiao.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    m_super_xiao.layer.borderWidth = 2.0f;
    m_super_xiao.userInteractionEnabled = YES;
    m_super_xiao.backgroundColor = [UIColor blackColor];
    m_super_xiao.tag = 2005;
    UITapGestureRecognizer *portraitTap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarClick5)];
    
    [m_super_xiao addGestureRecognizer:portraitTap4];
    [self.view addSubview:m_super_xiao];
    
}

-(void)avatarClick1{
    //2vma
    m_url = @"http://www.2vma.co/";
    [self performSegueWithIdentifier:@"InfoToWebInfo" sender:self];
}

-(void)avatarClick2{
    //cai
    m_url = @"http://2vima.sinaapp.com/";
    [self performSegueWithIdentifier:@"InfoToWebInfo" sender:self];
}

-(void)avatarClick3{
    //didi
    m_url = @"http://www.2vma.co/";
    [self performSegueWithIdentifier:@"InfoToWebInfo" sender:self];
}

-(void)avatarClick4{
    //jiajun
    m_url = @"http://www.2vma.co/";
    [self performSegueWithIdentifier:@"InfoToWebInfo" sender:self];
}

-(void)avatarClick5{
    //xiao
    m_url =@"http://a554b554.github.io/";
    [self performSegueWithIdentifier:@"InfoToWebInfo" sender:self];
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *receiver = segue.destinationViewController;
    if([receiver respondsToSelector:@selector(setUrl:)]){
        
        [receiver setValue:m_url forKey:@"url"];
    }
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
