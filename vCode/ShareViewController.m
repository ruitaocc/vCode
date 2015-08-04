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
#import "UMSocial_Sdk_Extra_Frameworks/YiXin/YXApi.h"
#import "UMSocial_Sdk_Extra_Frameworks/Wechat/UMSocialWechatHandler.h"
#import "QRDetector.h"
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
    int i = 0; int index = 0;
    float sHeight = x_magin*2 +grid_height*(ceil([sharedic count]/4.0));
    for(NSArray *item in sharedic){
        if (index == 0 || index==1 ||index==2) {
            //wechat
            NSURL *url = [NSURL URLWithString:@"weixin://"];
            bool hasApp = [[UIApplication sharedApplication]canOpenURL:url];
            NSLog(@"has wechat:%d",hasApp);
            if(!hasApp){
                index++;
                continue;
            }
        }else if(index == 4 || index==5){
            //qq qzone
            NSURL *url = [NSURL URLWithString:@"mqq://"];
            bool hasApp = [[UIApplication sharedApplication]canOpenURL:url];
            NSLog(@"has qq & qzone:%d",hasApp);
            if(!hasApp){
                index++;
                continue;
            }

        }else if(index == 6){
            //instagram
            NSURL *url = [NSURL URLWithString:@"instagram://"];
            bool hasApp = [[UIApplication sharedApplication]canOpenURL:url];
            NSLog(@"has qq & qzone:%d",hasApp);
            if(!hasApp){
                index++;
                continue;
            }
        }else if(index == 7){
            //facebook
//            NSURL *url = [NSURL URLWithString:@"fb://"];
//            bool hasApp = [[UIApplication sharedApplication]canOpenURL:url];
//            NSLog(@"has facebook:%d",hasApp);
//            if(!hasApp){
//                index++;
//                continue;
//            }
        }else if(index == 8){
            //twwiter
            NSURL *url = [NSURL URLWithString:@"twitter://"];
            bool hasApp = [[UIApplication sharedApplication]canOpenURL:url];
            NSLog(@"has twitter:%d",hasApp);
            if(!hasApp){
                index++;
                continue;
            }
        }else if(index == 9){
            //whatapp
            NSURL *url = [NSURL URLWithString:@"whatsapp://"];
            bool hasApp = [[UIApplication sharedApplication]canOpenURL:url];
            NSLog(@"has whatsapp:%d",hasApp);
            if(!hasApp){
                index++;
                continue;
            }
        }else if(index == 10){
            //tumblr
            NSURL *url = [NSURL URLWithString:@"tumblr://x-callback-url/dashboard"];
            bool hasApp = [[UIApplication sharedApplication]canOpenURL:url];
            NSLog(@"has tumblr:%d",hasApp);
            if(!hasApp){
                index++;
                continue;
            }
        }else if(index == 11){
            //line
            NSURL *url = [NSURL URLWithString:@"line://msg/text/vCode"];
            bool hasApp = [[UIApplication sharedApplication]canOpenURL:url];
            NSLog(@"has line:%d",hasApp);
            if(!hasApp){
                index++;
                continue;
            }
        }else if(index == 12 || index==13){
            //yixin
            bool hasApp =   [YXApi isYXAppInstalled];
            NSLog(@"has yixin:%d",hasApp);
            if(!hasApp){
                index++;
                continue;
            }
        }else if(index ==14){
            //tencent
        }else if(index ==15){
            //renren
        }
        
        NSString *itemName = NSLocalizedString(item[0], nil);
        NSString *itemImg = [NSString stringWithFormat:@"UMSocialSDKResourcesNew.bundle/SnsPlatform/%@",item[1]];
        UIImage *img = [UIImage imageNamed:itemImg];
        int row = i / 4;
        int column = i % 4;
        float x = x_magin + column * grid_width;
        float y = x_magin + saveView.frame.origin.y+saveView.frame.size.height+ row * grid_height;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, grid_width, grid_height)];
        btn.tag = index+10000;
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [btn setImage:img withTitle:itemName forState:UIControlStateNormal];
        //btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 5.0f;
        [btn clipsToBounds];
         [btn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        [scrollview addSubview:btn];
        index++;
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
-(UIImage *)prepareForWechatTimeline:(UIImage*)image{
    // Create a thumbnail version of the image for the event object.
    CGSize size = image.size;
    size.height+=28;
    UIImage * white_placehodler = [UIImage imageNamed:@"white.png"];
    UILabel * labe = [[UILabel alloc] init];
    [labe setFont:[UIFont systemFontOfSize:24 weight:UIFontWeightBold]];
   NSString * text = NSLocalizedString(@"wechat_notes", nil);
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:24] forKey:NSFontAttributeName];
    CGSize lsize  =[text sizeWithAttributes:attributes];
    // Done cropping
    [labe setText:text];
    
    // Resize the image
    CGRect rect = CGRectMake(0.0, 0.0,size.width, image.size.height);
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:rect];
    rect =CGRectMake(0.0, image.size.height,size.width, size.height-image.size.height);
    [white_placehodler drawInRect:rect];
    rect.origin.x = (size.width-lsize.width)/2;
    [labe drawTextInRect:rect];
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // Done Resizing
    
    return thumbnail;
    
};
-(UIImage *)prepareForSinaWaterMark:(UIImage*)image{
    // Create a thumbnail version of the image for the event object.
    CGSize size = image.size;
    size.height+=56;
    UIImage * white_placehodler = [UIImage imageNamed:@"white.png"];
    
    // Resize the image
    CGRect rect = CGRectMake(0.0, 0.0,size.width, image.size.height);
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:rect];
    rect =CGRectMake(0.0, image.size.height,size.width, size.height-image.size.height);
    [white_placehodler drawInRect:rect];
    
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // Done Resizing
    
    return thumbnail;
    
};
-(void)goBackHome{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)loadShareView{
        //
}

-(void)shareAction:(UIButton*)sender{
    
    NSLog(@"sender tag:%d",(int)sender.tag);
    //NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:@"shareinfo.plist"];
    
    NSString *shareText = NSLocalizedString(@"sharetext", nil);
    NSLog(@"shareText:%@",shareText);
    UIImage *shareImage = [UIImage imageWithData: UIImagePNGRepresentation(m_shareImg)];
    NSString *platform;
    if (sender.tag == 10000) {
        UIImage *img = [self prepareForWechatTimeline:m_shareImg];
        platform = UMShareToWechatTimeline;
        WXMediaMessage *message = [WXMediaMessage message];
        [message setThumbImage:[QRDetector generatePhotoThumbnail:m_shareImg]];
        
        WXImageObject *ext = [WXImageObject object];
        ext.imageData = UIImagePNGRepresentation(img);
        message.description = shareText;
        message.mediaObject = ext;
        message.mediaTagName = @"WECHAT_TAG_JUMP_APP";
        message.messageExt = shareText;
        message.messageAction = @"<action>dotalist</action>";
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.text = shareText;
        req.bText = NO;
        req.message = message;
       req.scene = 1;//timeline
       
        
        [WXApi sendReq:req];
        
        return;
    }else if(sender.tag==10001){
        platform = UMShareToWechatTimeline;
        WXMediaMessage *message = [WXMediaMessage message];
        [message setThumbImage:[QRDetector generatePhotoThumbnail:m_shareImg]];
        
        WXImageObject *ext = [WXImageObject object];
        ext.imageData = UIImagePNGRepresentation(m_shareImg);
        message.description = shareText;
        message.mediaObject = ext;
        message.mediaTagName = @"WECHAT_TAG_JUMP_APP";
        message.messageExt = shareText;
        message.messageAction = @"<action>dotalist</action>";
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.text = shareText;
        req.bText = NO;
        req.message = message;
        req.scene = 0;//session
        
        [WXApi sendReq:req];
        
        return;
    }else if(sender.tag==10002){
        platform = UMShareToWechatTimeline;
        WXMediaMessage *message = [WXMediaMessage message];
        [message setThumbImage:[QRDetector generatePhotoThumbnail:m_shareImg]];
        
        WXImageObject *ext = [WXImageObject object];
        ext.imageData = UIImagePNGRepresentation(m_shareImg);
        message.description = shareText;
        message.mediaObject = ext;
        message.mediaTagName = @"WECHAT_TAG_JUMP_APP";
        message.messageExt = shareText;
        message.messageAction = @"<action>dotalist</action>";
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.text = shareText;
        req.bText = NO;
        req.message = message;
        
        req.scene = 2;//favorite
        
        [WXApi sendReq:req];
        
        return;
    }else  if (sender.tag == 10003) {
        platform = UMShareToSina;
    }else  if (sender.tag == 10004) {
        platform = UMShareToQQ;
        
    }else  if (sender.tag == 10005) {
        platform = UMShareToQQ;
    }else  if (sender.tag == 10006) {
        platform = UMShareToInstagram;
    }else  if (sender.tag == 10007) {
        platform = UMShareToFacebook;
    }else  if (sender.tag == 10008) {
        platform = UMShareToTwitter;
    }else  if (sender.tag == 10009) {
        platform = UMShareToWhatsapp;
    }else  if (sender.tag == 10010) {
        platform = UMShareToTumblr;
    }else  if (sender.tag == 10011) {
        platform = UMShareToLine;
    }else  if (sender.tag == 10012) {
        platform = UMShareToYXSession;
        YXMediaMessage *msg = [YXMediaMessage message];
        [msg setThumbData:UIImagePNGRepresentation([QRDetector generatePhotoThumbnail:m_shareImg])];
        
        YXImageObject *ext = [YXImageObject object];
        ext.imageData =UIImagePNGRepresentation(m_shareImg);
        msg.description = shareText;
        msg.mediaObject = ext;
        
        SendMessageToYXReq*req = [[SendMessageToYXReq alloc] init];
        req.text = shareText;
        req.bText = NO;
        req.message = msg;
        req.scene = 0;
        [YXApi sendReq:req];
        return;
        
    }else  if (sender.tag == 10013) {
        platform = UMShareToYXTimeline;
        UIImage *img = [self prepareForWechatTimeline:m_shareImg];
        YXMediaMessage *msg = [YXMediaMessage message];
        [msg setThumbData:UIImagePNGRepresentation([QRDetector generatePhotoThumbnail:m_shareImg])];
        
        YXImageObject *ext = [YXImageObject object];
        ext.imageData =UIImagePNGRepresentation(img);
        msg.description = shareText;
        msg.mediaObject = ext;
        
        SendMessageToYXReq*req = [[SendMessageToYXReq alloc] init];
        req.text = shareText;
        req.bText = NO;
        req.message = msg;
        req.scene = 1;
        [YXApi sendReq:req];
        return;
    }else  if (sender.tag == 10014) {
        platform = UMShareToTencent;
    }else  if (sender.tag == 10015) {
        platform = UMShareToRenren;
    }
    [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:shareImage socialUIDelegate:self];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platform];
    snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
}
//下面可以设置根据点击不同的分享平台，设置不同的分享文字
-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    
    
    //UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:m_shareImg_URL]];
    if([platformName isEqualToString:UMShareToWechatTimeline] || [platformName isEqualToString:UMShareToWechatFavorite] || [platformName isEqualToString:UMShareToWechatSession]){
        
        socialData.extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    }else if ([platformName isEqualToString:UMShareToQQ]) {
        socialData.extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
        //socialData.extConfig.qqData =nil;
    }else if ([platformName isEqualToString:UMShareToQzone]) {
        socialData.extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
    }else if ([platformName isEqualToString:UMShareToYXSession]) {
        socialData.extConfig.yxtimelineData.yxMessageType = UMSocialYXMessageTypeImage;
        socialData.extConfig.yxsessionData.yxMessageType = UMSocialYXMessageTypeImage;
    }else if ([platformName isEqualToString:UMShareToYXTimeline]) {
        socialData.extConfig.yxtimelineData.yxMessageType = UMSocialYXMessageTypeImage;
    }else if ([platformName isEqualToString:UMShareToSina]) {
        UIImage *img = [self prepareForSinaWaterMark:m_shareImg];
        socialData.shareImage = img;
    }else if ([platformName isEqualToString:UMShareToSina]) {
    }else if ([platformName isEqualToString:UMShareToSina]) {
    }else if ([platformName isEqualToString:UMShareToSina]) {
    }else if ([platformName isEqualToString:UMShareToSina]) {
    }else if ([platformName isEqualToString:UMShareToSina]) {
    }
    else{
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
