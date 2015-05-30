//
//  ViewController.m
//  vCode
//
//  Created by ruitaocc on 15/4/19.
//  Copyright (c) 2015年 ruitaocc. All rights reserved.
//

#import "ViewController.h"
#import "HQR.h"
#import "md5Encryptor.h"
#import "../Pods/UMengFeedback/UMFeedback_iOS_2.2/UMengFeedback_SDK_2.2/UMFeedback.h"
#import "WZFlashButton.h"
#import "UIDeviceHardware.h"
@interface ViewController ()

-(void)btn_click_info;
-(void)btn_click_feedback;
-(void)btn_click_rating;

- (void)notification_execute:(NSNotification *)notification;
@property (strong,nonatomic)UIImageView *bg_view;

@property (strong,nonatomic)UIImageView *slogan;

@property (strong,nonatomic)UIButton * btn_info;

@property (strong,nonatomic)UIButton *btn_feedback;

@property (strong,nonatomic)UIButton *btn_rating;

@property (strong,nonatomic)WZFlashButton *fbtn_URL;
@property (strong,nonatomic)WZFlashButton *fbtn_WeiChat;
@property (strong,nonatomic)WZFlashButton *fbtn_QR2VC;
@property (strong,nonatomic)WZFlashButton *fbtn_Text;
@property (strong,nonatomic)WZFlashButton *fbtn_QNameCard;
@property (strong,nonatomic)WZFlashButton *fbtn_History;
@end

@implementation ViewController
@synthesize btn_feedback;
@synthesize btn_info;
@synthesize btn_rating;
@synthesize bg_view;
@synthesize fbtn_URL;
@synthesize fbtn_WeiChat;
@synthesize fbtn_QR2VC;
@synthesize fbtn_Text;
@synthesize fbtn_QNameCard;
@synthesize fbtn_History;
@synthesize slogan;
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(notification_execute:)
                                                name:@"NOTIFICATION_SWITCH"
                                            object:nil];
    float s_width = self.view.frame.size.width;
    float s_height = self.view.frame.size.height;
    NSLog(@"s_width:%f,s_height:%f",s_width,s_height);
    
    float grid_size = s_width/10;
    UIDeviceHardware*hd =  [[UIDeviceHardware  alloc ]init ];
    BOOL isIPH56 = [hd Is_IPH_56];
    BOOL isSumulator = [hd Is_Simulator];
    isIPH56 = isSumulator?YES:NO;
    
    UIImage *bg;
    UIImage *img_rating,*img_feedback,*img_info,*img_slogan;
    CGRect bg_frame;
    CGRect menu_btn_frame;
    CGRect icon_btn_frame;
    CGRect slogan_frame;
    icon_btn_frame.size.width = grid_size;
    icon_btn_frame.size.height = grid_size;
    menu_btn_frame.size.width = grid_size*3;
    slogan_frame.size.width = 6*grid_size;
    slogan_frame.size.height = 2*grid_size;
    if(isIPH56){
        bg = [UIImage imageNamed:@"ip56_bg.png"];
        bg_frame.size.width = s_width;
        bg_frame.size.height = bg.size.height/640.0*s_width;
        bg_frame.origin.x = 0;
        bg_frame.origin.y = s_height-bg_frame.size.height;
        
        menu_btn_frame.size.height = grid_size*3;
        slogan_frame.origin.x = 2*grid_size;
        slogan_frame.origin.y = s_height-16*grid_size;
        
    }else{
        bg = [UIImage imageNamed:@"ip4_bg.png"];
        bg_frame.size.width = s_width;
        bg_frame.size.height = bg.size.height/640.0*s_width;
        bg_frame.origin.x = 0;
        bg_frame.origin.y = s_height-bg_frame.size.height;
        
        menu_btn_frame.size.height = grid_size*2;
        slogan_frame.origin.x = 2*grid_size;
        slogan_frame.origin.y = s_height-13*grid_size;
        
    }
    img_feedback = [UIImage imageNamed:@"feedback_icon.png"];
    img_info = [UIImage imageNamed:@"info_icon.png"];
    img_rating = [UIImage imageNamed:@"like_icon.png"];
    img_slogan = [UIImage imageNamed:@"slogan.png"];
    
    slogan = [[UIImageView alloc] initWithFrame:slogan_frame];
    [slogan setImage:img_slogan];
    bg_view = [[UIImageView alloc]initWithFrame:bg_frame];
    [bg_view setImage:bg];
    
    //icon buttons
    icon_btn_frame.origin.x = 0;
    icon_btn_frame.origin.y = 20;
    btn_rating = [[UIButton alloc] initWithFrame:icon_btn_frame];
    [btn_rating setImage:img_rating forState:UIControlStateNormal];
    [btn_rating addTarget:self action:@selector(btn_click_rating) forControlEvents:UIControlEventTouchUpInside];
    
    icon_btn_frame.origin.x = s_width-grid_size;
    icon_btn_frame.origin.y = 20;
    btn_feedback = [[UIButton alloc] initWithFrame:icon_btn_frame];
    [btn_feedback setImage:img_feedback forState:UIControlStateNormal];
    [btn_feedback addTarget:self action:@selector(btn_click_feedback) forControlEvents:UIControlEventTouchUpInside];
    
    icon_btn_frame.origin.x = s_width-grid_size;
    icon_btn_frame.origin.y = s_height-grid_size;
    btn_info = [[UIButton alloc] initWithFrame:icon_btn_frame];
    [btn_info setImage:img_info forState:UIControlStateNormal];
    [btn_info addTarget:self action:@selector(btn_click_info) forControlEvents:UIControlEventTouchDown];
    /*
     
     "menu_qnamecard"="Q NameCard";
     "menu_history"="History";
     "menu_qr2vc"="QR Code to V Code";
     "menu_test"="Text";
     "menu_url"="URL";
     "munu_weichart"="WeiChat NameCard";
     */
    //menu buttons
    __weak __typeof(self) weakSelf = self;
    
    menu_btn_frame.origin.x = grid_size;
    menu_btn_frame.origin.y = isIPH56 ? s_height-5*grid_size : s_height-4*grid_size;
    fbtn_QNameCard = [[WZFlashButton alloc]initWithFrame:menu_btn_frame ];
    //fbtn_QNameCard.backgroundColor = [UIColor colorWithRed:67.0/255.0f green:209.0f/255.0f blue:250.0/255.0 alpha:1.0f];
    fbtn_QNameCard.backgroundColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0 alpha:1.0f];
    fbtn_QNameCard.flashColor = [UIColor whiteColor];
    [fbtn_QNameCard setText:NSLocalizedString(@"menu_qnamecard", nil) withTextColor:nil];
    fbtn_QNameCard.clickBlock = ^(void){
       // [weakSelf performSegueWithIdentifier:@"HomeToURL" sender:weakSelf];
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setMessage:NSLocalizedString(@"alert_coming", nil)];
        [alert addButtonWithTitle:NSLocalizedString(@"alert_ok", nil)];
        [alert show];
    };
    
    menu_btn_frame.origin.x = grid_size*5;
    menu_btn_frame.origin.y = isIPH56 ?s_height-5*grid_size : s_height-4*grid_size;
    fbtn_History = [[WZFlashButton alloc]initWithFrame:menu_btn_frame ];
    fbtn_History.backgroundColor = [UIColor colorWithRed:67.0/255.0f green:209.0f/255.0f blue:250.0/255.0 alpha:1.0f];
    fbtn_History.flashColor = [UIColor whiteColor];
    [fbtn_History setText:NSLocalizedString(@"menu_history", nil) withTextColor:nil];
    fbtn_History.clickBlock = ^(void){
        //[weakSelf performSegueWithIdentifier:@"HomeToURL" sender:weakSelf];
    };

    menu_btn_frame.origin.x = grid_size;
    menu_btn_frame.origin.y = isIPH56 ?s_height-9*grid_size : s_height-7*grid_size;
    fbtn_QR2VC = [[WZFlashButton alloc]initWithFrame:menu_btn_frame ];
    fbtn_QR2VC.backgroundColor = [UIColor colorWithRed:67.0/255.0f green:209.0f/255.0f blue:250.0/255.0 alpha:1.0f];
    fbtn_QR2VC.flashColor = [UIColor whiteColor];
    [fbtn_QR2VC setText:NSLocalizedString(@"menu_qr2vc", nil) withTextColor:nil];
    fbtn_QR2VC.clickBlock = ^(void){
        [weakSelf performSegueWithIdentifier:@"HomeToCode" sender:weakSelf];
    };

    menu_btn_frame.origin.x = grid_size*5;
    menu_btn_frame.origin.y = isIPH56 ? s_height-9*grid_size : s_height-7*grid_size;
    fbtn_Text = [[WZFlashButton alloc]initWithFrame:menu_btn_frame ];
    fbtn_Text.backgroundColor = [UIColor colorWithRed:67.0/255.0f green:209.0f/255.0f blue:250.0/255.0 alpha:1.0f];
    fbtn_Text.flashColor = [UIColor whiteColor];
    [fbtn_Text setText:NSLocalizedString(@"menu_text", nil) withTextColor:nil];
    fbtn_Text.clickBlock = ^(void){
        [weakSelf performSegueWithIdentifier:@"HomeToText" sender:weakSelf];
    };

    menu_btn_frame.origin.x = grid_size;
    menu_btn_frame.origin.y = isIPH56 ? s_height-13*grid_size : s_height-10*grid_size;
    fbtn_URL = [[WZFlashButton alloc]initWithFrame:menu_btn_frame ];
    fbtn_URL.backgroundColor = [UIColor colorWithRed:67.0/255.0f green:209.0f/255.0f blue:250.0/255.0 alpha:1.0f];
    fbtn_URL.flashColor = [UIColor whiteColor];
    [fbtn_URL setText:NSLocalizedString(@"menu_url", nil) withTextColor:nil];
    fbtn_URL.clickBlock = ^(void){
        [weakSelf performSegueWithIdentifier:@"HomeToURL" sender:weakSelf];
    };
    
    menu_btn_frame.origin.x = grid_size*5;
    menu_btn_frame.origin.y = isIPH56 ? s_height-13*grid_size : s_height-10*grid_size;
    fbtn_WeiChat = [[WZFlashButton alloc]initWithFrame:menu_btn_frame ];
    fbtn_WeiChat.backgroundColor = [UIColor colorWithRed:67.0/255.0f green:209.0f/255.0f blue:250.0/255.0 alpha:1.0f];
    fbtn_WeiChat.flashColor = [UIColor whiteColor];
    [fbtn_WeiChat setText:NSLocalizedString(@"menu_weichat", nil) withTextColor:nil];
    [fbtn_WeiChat.textLabel setNumberOfLines:3];
    fbtn_WeiChat.clickBlock = ^(void){
        [weakSelf performSegueWithIdentifier:@"HomeToCode" sender:weakSelf];
    };

    
    
    [self.view addSubview:bg_view];
    [self.view addSubview:btn_rating];
    [self.view addSubview:btn_info];
    [self.view addSubview:btn_feedback];
    [self.view addSubview:fbtn_URL];
    [self.view addSubview:fbtn_WeiChat];
    [self.view addSubview:fbtn_QR2VC];
    [self.view addSubview:fbtn_Text];
    [self.view addSubview:fbtn_QNameCard];
    [self.view addSubview:fbtn_History];
    [self.view addSubview:slogan];
    

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)notification_execute:(NSNotification *)notification{
   // NSString *segue =(NSString*)notification.object;
    NSLog(@"%@",self);
    [self performSegueWithIdentifier:(NSString*)notification.object sender:nil];
    
    //[self performSegueWithIdentifier: @"HomeToURL" sender: self];
};
-(void)btn_click_info{
    [self performSegueWithIdentifier:@"HomeToInfo" sender:self];
};
-(void)btn_click_feedback{
    [self.navigationController pushViewController:[UMFeedback feedbackViewController] animated:YES];
};
-(void)btn_click_rating{
    NSLog(@"undefine");
};

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)feedback:(id)sender{
    [self.navigationController pushViewController:[UMFeedback feedbackViewController] animated:YES];
};
/*
-(IBAction)chooseimg:(id)sender{
    printf("choose\n");
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];

    [picker setDelegate:self];
    [self presentViewController:picker animated:YES completion:nil];
    
}

-(IBAction)doComput:(id)sender{
    [self sendRequest:@"http://www.baidu.com"];
    
};

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    void (^com)(void);
    com = ^(void)
    {
        NSLog(@"wtf");
    };
    
    
    UIImage* finalimg = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.imageView setImage:finalimg];
    [self dismissViewControllerAnimated:YES completion:com];
    
}


-(IBAction)saveImg:(id)sender{
    UIImageWriteToSavedPhotosAlbum([_imageView image], nil, nil, nil);
    NSLog(@"saved complete!");
}

- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}

-(void)sendRequest:(NSString*)url{
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://2vma.co/api/short_url"]];
    
    // Specify that it will be a POST request
    request.HTTPMethod = @"POST";
    
    // This is how we set header fields
    [request setValue:@"application/x-www-form-urlencoded ; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    
    // Convert your data and set your request's HTTPBody property
    NSString *stringData = [NSString stringWithFormat:@"tm=111&uuid=123&sign=1339ba084d895328187e53d1fe497d77&url=%@",url];
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"send request.");
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
    NSString *aString = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    NSError* jsonError;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingMutableContainers error:&jsonError];
    NSLog(aString);
    NSString* encodedata = [[json objectForKey:@"data"] objectForKey:@"shortUrl"];
    secretkey = C10-705;
    NSLog(@"%@",encodedata);
    UIImage *img = [_imageView image];
    NSLog(@"begin compute");
    HQR *hqr = [HQR getInstance];
    //corection level 4level QR_ECLEVEL_L QR_ECLEVEL_M QR_ECLEVEL_Q QR_ECLEVEL_H
    [hqr setLevel:QR_ECLEVEL_L];
    [hqr setVersion:5];//2-40
    [hqr setThreshold_PaddingArea:0 nodePaddingArea:100 GuideRatio:1.0];
    UIImage *outimg = [hqr generateQRwithImg:img text:encodedata isGray: NO];
    //"http://2vma.co/zxcASD"
    [_imageView setImage:outimg];
    NSLog(@"finished!");
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}
*/

@end
