//
//  ShareViewController.m
//  vCode
//
//  Created by ruitaocc on 15/6/23.
//  Copyright (c) 2015年 ruitaocc. All rights reserved.
//

#import "ShareViewController.h"
#import "WZFlashButton.h"
#define TabHeight 49.0f
#define ParaHeight 64.0f
#define StatusBatHeight 22.0f
#define NavBatHeight 44.0f
#define myBlue [UIColor colorWithRed:67.0/255.0f green:209.0f/255.0f blue:250.0/255.0 alpha:1.0f]

@interface ShareViewController ()
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
    
    CGRect shareRect = saveView.frame;
    shareRect.origin.y  = shareRect.origin.y+shareRect.size.height;
    UIView *shareView = [[UIView alloc] initWithFrame:shareRect];
    [shareView setBackgroundColor:[UIColor lightGrayColor]];
    
    [self.view addSubview:shareView];
    [self.view addSubview:saveView];
                                                                
}
-(void)modify{

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
