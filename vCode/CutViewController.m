//
//  CutViewController.m
//  
//
//  Created by DarkTango on 5/28/15.
//
//

#import "CutViewController.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "vCode-swift.h"
#import "QRDetector.h"
#import "CPPickerView.h"

#import "../Pods/MMMaterialDesignSpinner/Pod/Classes/MMMaterialDesignSpinner.h"
#define ORIGINAL_MAX_WIDTH 640.0f


@interface CutViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate,UITabBarDelegate,InfiniTabBarDelegate,CPPickerViewDataSource, CPPickerViewDelegate>{

    int min_version;
    int max_version;
    //parameter
    int m_para_style;
    int m_para_version;
    int m_para_level;
    float m_para_coding_area;
    float m_para_padding_area;
    float m_para_ratio;
}
@property(strong ,nonatomic)CPPickerView *horizontalPickerView;
@property(strong ,nonatomic)MMMaterialDesignSpinner *m_spinnerView;
@property (nonatomic, strong) UIImageView *portraitImageView;
//control buttons
@property(strong , nonatomic)UIView* m_control_View;
@property(strong , nonatomic)InfiniTabBar* m_para_TabBar;
@property(strong , nonatomic)UITabBar* m_auto_TabBar;
@property(assign , nonatomic)int m_selected_item_tag;
//secondary control
@property(strong , nonatomic)UIScrollView* m_second_paraView;
@property(assign , nonatomic)BOOL m_second_paraView_isShowed;
//p1
@end

@implementation CutViewController
@synthesize horizontalPickerView;
@synthesize m_spinnerView;
@synthesize m_para_TabBar;
@synthesize m_auto_TabBar;
@synthesize m_control_View;
@synthesize m_selected_item_tag;
@synthesize m_second_paraView;
@synthesize m_second_paraView_isShowed;
- (void)viewDidLoad
{
    m_second_paraView_isShowed = NO;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [super viewDidLoad];
    [self.view addSubview:self.portraitImageView];
    [self loadPortrait];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:NSLocalizedString(@"next_step2", @"") forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    CGRect rect = CGRectMake(0, self.view.frame.size.height*3/4, self.view.frame.size.width, 50);
    btn.frame = rect;
    UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(next)];
    [btn addGestureRecognizer:Tap];
    [self.view addSubview:btn];
    UIImageView *qrcodeview = [[UIImageView alloc] initWithFrame:_portraitImageView.frame];
    qrcodeview.image = [UIImage imageNamed:@"qrcode_mask.png"];
    [self.view addSubview:qrcodeview];
    min_version = 5;
    [self loadSecondaryParaView];
    [self loadControllTab];
}
#pragma mark - CPPickerViewDataSource

- (NSInteger)numberOfItemsInPickerView:(CPPickerView *)pickerView
{
    return 40-min_version+1;
}
- (NSString *)pickerView:(CPPickerView *)pickerView titleForItem:(NSInteger)item
{
    return [NSString stringWithFormat:@"%i", min_version + item];
}
#pragma mark - CPPickerViewDelegate

- (void)pickerView:(CPPickerView *)pickerView didSelectItem:(NSInteger)item
{
    NSLog(@"%@",[NSString stringWithFormat:@"%i", min_version + item]);
}

-(void)loadSecondaryParaView{
    float s_witdh = self.view.frame.size.width;
    float s_height = self.view.frame.size.height;
    float height = 60;
    CGRect frame = CGRectMake(0, s_height, s_witdh, height);
    m_second_paraView = [[UIScrollView alloc] initWithFrame:frame];
    m_second_paraView.contentSize = CGSizeMake(6*s_witdh, height);
    m_second_paraView.pagingEnabled = NO;
    m_second_paraView.scrollEnabled = NO;
    m_second_paraView.backgroundColor = [UIColor blueColor];
    m_second_paraView.showsHorizontalScrollIndicator = NO;
    //m_second_paraView.delegate = self;
    //style
    
    float sysFontSize = [UIFont systemFontSize];
    
    frame.origin.x = 0*s_witdh;
    frame.origin.y = 0;
    UIView *stylesubview = [[UIView alloc] initWithFrame:frame];
    UILabel *style_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0.2*s_witdh, height)];
    style_label.textAlignment = NSTextAlignmentCenter;
    style_label.text = NSLocalizedString(@"p_label_style", nil);
    style_label.textColor = [UIColor whiteColor];
    [stylesubview addSubview:style_label];
    [m_second_paraView addSubview:stylesubview];
    
    //version
    frame.origin.x = 1 * s_witdh;
    UIView *sub_verison_view = [[UIView alloc] initWithFrame:frame];
    UILabel *version_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0.3*s_witdh, height)];
    version_label.textAlignment = NSTextAlignmentCenter;
    version_label.text = NSLocalizedString(@"p_label_version", nil);
    [sub_verison_view addSubview:version_label];
    //UISlider *version_slider = [[UISlider alloc] initWithFrame:CGRectMake(0.35*s_witdh, 0, 0.6*s_witdh, height)];
    horizontalPickerView = [[CPPickerView alloc] initWithFrame:CGRectMake(0.35*s_witdh, (height-44)/2, 0.6*s_witdh, 44)];
    horizontalPickerView.backgroundColor = [UIColor whiteColor];
    horizontalPickerView.dataSource = self;
    horizontalPickerView.delegate = self;
    horizontalPickerView.allowSlowDeceleration = YES;
    horizontalPickerView.showGlass = YES;
    horizontalPickerView.peekInset = UIEdgeInsetsMake(0, 0.6*s_witdh*0.3, 0, 0.6*s_witdh*0.3);
    [horizontalPickerView reloadData];;
    [sub_verison_view addSubview:horizontalPickerView];
    [m_second_paraView addSubview:sub_verison_view];
    
    //correction level
    frame.origin.x = 2 * s_witdh;
    UIView *sub_correct_level_view = [[UIView alloc] initWithFrame:frame];
    UILabel *correct_level_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0.3*s_witdh, height)];
    correct_level_label.numberOfLines = 2;
    correct_level_label.font = [UIFont systemFontOfSize:0.9*sysFontSize];
    correct_level_label.textAlignment = NSTextAlignmentCenter;
    correct_level_label.lineBreakMode = NSLineBreakByWordWrapping;
    correct_level_label.text = NSLocalizedString(@"p_label_correct", nil);
    [sub_correct_level_view addSubview:correct_level_label];
    //UISlider *coding_slider = [[UISlider alloc] initWithFrame:CGRectMake(0.25*s_witdh, 0, 0.7*s_witdh, height)];
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:NSLocalizedString(@"correct_low", nil),NSLocalizedString(@"correct_mid", nil),NSLocalizedString(@"correct_quality", nil),NSLocalizedString(@"correct_high", nil),nil];
    UISegmentedControl *correct_level_segment_contrl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    [correct_level_segment_contrl setFrame:CGRectMake(0.3*s_witdh, (height-28)/2, 0.65*s_witdh, 28)];
    [sub_correct_level_view addSubview:correct_level_segment_contrl];
    [m_second_paraView addSubview:sub_correct_level_view];

    
    
    //coding data area
    frame.origin.x = 3 * s_witdh;
    UIView *sub_coding_view = [[UIView alloc] initWithFrame:frame];
    UILabel *coding_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0.3*s_witdh, height)];
    coding_label.numberOfLines = 2;
    coding_label.font = [UIFont systemFontOfSize:0.9*sysFontSize];
    coding_label.textAlignment = NSTextAlignmentCenter;
    coding_label.lineBreakMode = NSLineBreakByWordWrapping;
    coding_label.text = NSLocalizedString(@"p_label_coding_area", nil);
    [sub_coding_view addSubview:coding_label];
    UISlider *coding_slider = [[UISlider alloc] initWithFrame:CGRectMake(0.3*s_witdh, 0, 0.65*s_witdh, height)];
    [sub_coding_view addSubview:coding_slider];
    [m_second_paraView addSubview:sub_coding_view];
    
    //padding data area
    frame.origin.x = 4 * s_witdh;
    UIView *sub_papding_view = [[UIView alloc] initWithFrame:frame];
    UILabel *padding_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0.3*s_witdh, height)];
    padding_label.numberOfLines = 2;
    padding_label.font = [UIFont systemFontOfSize:0.9*sysFontSize];
    padding_label.textAlignment = NSTextAlignmentCenter;
    padding_label.lineBreakMode = NSLineBreakByWordWrapping;
    padding_label.text = NSLocalizedString(@"p_label_padding_area", nil);
    [sub_papding_view addSubview:padding_label];
    UISlider *padding_slider = [[UISlider alloc] initWithFrame:CGRectMake(0.3*s_witdh, 0, 0.65*s_witdh, height)];
    [sub_papding_view addSubview:padding_slider];
    [m_second_paraView addSubview:sub_papding_view];
    
    //ratio
    frame.origin.x = 5*s_witdh;
    UIView *subview = [[UIView alloc] initWithFrame:frame];
    UILabel *r_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0.3*s_witdh, height)];
    r_label.textAlignment = NSTextAlignmentCenter;
    r_label.text = NSLocalizedString(@"p_label_ratio", nil);
    [subview addSubview:r_label];
    UISlider *r_slider = [[UISlider alloc] initWithFrame:CGRectMake(0.3*s_witdh, 0, 0.65*s_witdh, height)];
    [subview addSubview:r_slider];
    [m_second_paraView addSubview:subview];
    
    
    [self.view addSubview:m_second_paraView];
}
-(void)loadControllTab{
    float s_witdh = self.view.frame.size.width;
    float s_height = self.view.frame.size.height;
    float auto_width = s_witdh*0.3;
    float seperate = 0;
    float para_width = s_witdh-auto_width-seperate;
    float height = 49;
    m_control_View = [[UIView alloc] initWithFrame:CGRectMake(0, s_height, s_witdh, height)];
    [m_control_View.layer setMasksToBounds:YES];
    
    //[m_control_View setBackgroundColor:[UIColor lightGrayColor]];
    m_auto_TabBar = [[UITabBar alloc]initWithFrame:CGRectMake(0, 0, auto_width, height)];
    UITabBarItem *auto_item= [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:0];
   
    NSArray *items = [NSArray arrayWithObjects:auto_item, nil];
    [m_auto_TabBar setItems:items];
    m_selected_item_tag = 0;
    [m_auto_TabBar setSelectedItem:auto_item];
    
    m_auto_TabBar.delegate = self;
   
    UITabBarItem *topRated = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemTopRated tag:1];
    UITabBarItem *featured = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:2];
    UITabBarItem *recents = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:3];
    UITabBarItem *contacts = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:4];
    UITabBarItem *history = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:5];
    UITabBarItem *bookmarks = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:6];
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(auto_width-1, 5, 2, height-10)];
    [sep setBackgroundColor:[UIColor lightGrayColor]];
    m_para_TabBar = [[InfiniTabBar alloc] initWithFrame:CGRectMake(seperate+auto_width, 0, para_width, height) withItems:[NSArray arrayWithObjects:topRated,
                                                         featured,
                                                         recents,
                                                         contacts,
                                                         history,
                                                         bookmarks,
                                                         nil]];
    m_para_TabBar.infiniTabBarDelegate = self;
    m_para_TabBar.bounces = NO;
    [m_control_View addSubview:m_auto_TabBar];
    [m_control_View addSubview:m_para_TabBar];
    [m_control_View addSubview:sep];
    
    [self.view addSubview:m_control_View];
}

- (void)infiniTabBar:(InfiniTabBar *)tabBar didScrollToTabBarWithTag:(int)tag{
    
};
- (void)infiniTabBar:(InfiniTabBar *)tabBar didSelectItemWithTag:(int)tag{
     [self selectTabWithTag:tag];
};

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    [self selectTabWithTag:item.tag];
};

-(void)selectTabWithTag:(int)tag{
    NSLog(@"select tag %d",tag);
    if(m_selected_item_tag==tag){
        NSLog(@"do no thing");
        return;
    }
    if(m_selected_item_tag==0){
        [m_auto_TabBar setSelectedItem:nil];
    }
    if(tag==0){
        [m_para_TabBar selectItemWithTag:-1];
    }
    m_selected_item_tag = tag;
    [self selectRelateParaPageWithTag:tag];
}

-(void)selectRelateParaPageWithTag:(int)tag{
    if (tag==0) {
        [self hideSecondParaView];
        return;
    }
    if (!m_second_paraView_isShowed) {
        [self showSecondParaView];
    }
    [self scrollSecondParaViewToTPageWithTag:tag-1 animated:YES];
    
    
}

- (BOOL)scrollSecondParaViewToTPageWithTag:(int)tag animated:(BOOL)animated{
    NSLog(@"scrollpage:%d",tag);
    CGRect sf = m_second_paraView.frame;
    sf.origin.x = tag*m_second_paraView.frame.size.width;
    sf.origin.y = 0;
    [m_second_paraView scrollRectToVisible:sf animated:animated];
    return YES;
};

-(void)hideSecondParaView{
    float s_height = self.view.frame.size.height;
    float f_height = 49;
    float sec_height = 60;
    m_second_paraView.alpha = 1.0;
    CGRect sf = m_second_paraView.frame;
    sf.origin.y = s_height-f_height-sec_height;
    m_second_paraView.frame = sf;
    sf.origin.y = s_height-f_height;
    [UIView animateWithDuration:0.5 //时长
                          delay:0 //延迟时间
                        options:UIViewAnimationOptionTransitionNone//动画效果
                     animations:^{
                         
                         m_second_paraView.frame = sf;
                         m_second_paraView.alpha = 0.0;
                         
                     } completion:^(BOOL finish){
                         m_second_paraView_isShowed = NO;
                         //动画结束时调用
                         //[self computeQR];
                     }];
}
-(void)showSecondParaView{
    float s_height = self.view.frame.size.height;
    float f_height = 49;
    float sec_height = 60;
    m_second_paraView.alpha = 0.0;
    CGRect sf = m_second_paraView.frame;
    sf.origin.y = s_height-f_height;
    m_second_paraView.frame = sf;
    sf.origin.y = s_height-f_height-sec_height;
    [UIView animateWithDuration:0.5 //时长
                          delay:0 //延迟时间
                        options:UIViewAnimationOptionTransitionNone//动画效果
                     animations:^{
                         
                         m_second_paraView.frame = sf;
                         m_second_paraView.alpha = 1;
                         
                     } completion:^(BOOL finish){
                         //动画结束时调用
                         m_second_paraView_isShowed = YES;
                         //[self computeQR];
                     }];
}

-(void)showParaMainControlTab{
    float s_height = self.view.frame.size.height;
    float height = 49;
    CGRect f = m_control_View.frame;
    f.origin.y = s_height -height;
    m_control_View.alpha = 0.0;
    m_second_paraView.alpha = 0.0;
    CGRect sf = m_second_paraView.frame;
    sf.origin.y = s_height-height;
    [UIView animateWithDuration:0.5 //时长
                          delay:0 //延迟时间
                        options:UIViewAnimationOptionTransitionNone//动画效果
                     animations:^{
                         
                         //动画设置区域
                         m_control_View.frame=f;
                         m_control_View.alpha=1;
                         m_second_paraView.frame = sf;
                         m_second_paraView.alpha = 1;
                         
                     } completion:^(BOOL finish){
                         //动画结束时调用
                         [self computeQR];
                     }];
}

-(void)hideParaMainControlTab{
    float s_height = self.view.frame.size.height;
    CGRect f = m_control_View.frame;
    f.origin.y = s_height;
    m_control_View.alpha = 1.0;
    [UIView animateWithDuration:0.5 //时长
                          delay:0 //延迟时间
                        options:UIViewAnimationOptionTransitionNone//动画效果
                     animations:^{
                         
                         //动画设置区域
                         m_control_View.frame=f;
                         m_control_View.alpha=0.0;
                         
                     } completion:^(BOOL finish){
                         //动画结束时调用
                         //[self computeQR];
                     }];
}

-(void)computeQR{
//    paras
//    int m_para_style;
//    int m_para_version;
//    int m_para_level;
//    int m_para_coding_area;
//    int m_para_padding_area;
//    int m_para_ration;
    NSLog(@"ComputeQR With Data:%@",_dataToEncode);
    UIImage *img = [QRDetector generateQRwithImg:_portraitImageView.image text:_dataToEncode style:m_para_style version: m_para_version level:m_para_level codingarea:m_para_coding_area paddingarea:m_para_padding_area guideratio:m_para_ratio];
    //UIImage* img = [QRDetector generateQRwithImg:_portraitImageView.image text:_dataToEncode isGray:NO];
    _portraitImageView.image = img;
    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
    
};

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveShortURL:) name:@"didReceiveURL" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveShortURL:) name:@"requestERROR" object:nil];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:@"didReceiveURL" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:@"requestERROR" object:nil];
    if(m_spinnerView){
        [m_spinnerView stopAnimating];
        [m_spinnerView removeFromSuperview];
        m_spinnerView = NULL;
    }
}
-(void)configParameters{
    if(_haveDataToEncode){
        min_version = [QRDetector getMinimunVersionWithText:_dataToEncode];
        NSLog(@"min_version:%d",min_version);
        m_para_version = min_version;
        m_para_level = 0;
        m_para_style = 0;
        m_para_padding_area = 50;
        m_para_coding_area = 50;
        m_para_ratio = 1.0;
        [horizontalPickerView reloadData];
    }
}

- (void) didReceiveShortURL:(NSNotification*) notification{
    if (m_spinnerView) {
        [m_spinnerView stopAnimating];
    }
    if ([notification.name isEqualToString:@"didReceiveURL"]) {
        _dataToEncode = RequestSender.shortURL;
        NSLog(@"%@",_dataToEncode);
        _haveDataToEncode = YES;
    }
    if ([notification.name isEqualToString:@"requestERROR"]) {
        NSLog(@"Network error!");
    }
    [self configParameters];
}

- (void) next{
    NSLog(@"prepare to compute QR code");
    if (_haveDataToEncode) {
        [self configParameters];
        [self showParaMainControlTab];
    }
    else{
//        UIAlertView* alert = [[UIAlertView alloc] init];
//        [alert setTitle:@"did not receive response yet."];
//        [alert addButtonWithTitle:@"ok"];
//        [alert show];
        CGRect spinner_frame ;
        spinner_frame.size.width = 40;
        spinner_frame.size.height = 40;
        spinner_frame.origin.x = (self.view.frame.size.width-spinner_frame.size.width)/2;
        spinner_frame.origin.y = (self.view.frame.size.height-spinner_frame.size.height)/2;
        m_spinnerView = [[MMMaterialDesignSpinner alloc] initWithFrame:spinner_frame];
        m_spinnerView.lineWidth = 2.5f;
        m_spinnerView.tintColor = [UIColor colorWithRed:69/255.0 green:209.0/255.0 blue:250/255.0 alpha:1.0];
        [self.view addSubview:m_spinnerView];
        [m_spinnerView startAnimating];

    }
    
}

- (void)loadPortrait {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        UIImage *protraitImg = [UIImage imageNamed:@"lena.jpg"] ;
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.portraitImageView.image = protraitImg;
        });
    });
    //UIImage *protraitImg = [UIImage imageNamed:@"lena.jpg"];
    //self.portraitImageView.image = protraitImg;
}

- (void)editPortrait {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"actionsheet_cancel", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"actionsheet_take_photo", nil), NSLocalizedString(@"actionsheet_select_form_albums", nil), nil];
    [choiceSheet showInView:self.view];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.portraitImageView.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark portraitImageView getter
- (UIImageView *)portraitImageView {
    if (!_portraitImageView) {
        CGFloat w = self.view.frame.size.width*0.57; CGFloat h = w;
        CGFloat x = (self.view.frame.size.width - w) / 2;
        CGFloat y = (self.view.frame.size.height - h) / 2;
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        //[_portraitImageView.layer setCornerRadius:(_portraitImageView.frame.size.height/2)];
        [_portraitImageView.layer setMasksToBounds:YES];
        [_portraitImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_portraitImageView setClipsToBounds:YES];
        _portraitImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        _portraitImageView.layer.shadowOffset = CGSizeMake(4, 4);
        _portraitImageView.layer.shadowOpacity = 0.5;
        _portraitImageView.layer.shadowRadius = 2.0;
       // _portraitImageView.layer.borderColor = [[UIColor blackColor] CGColor];
        _portraitImageView.layer.borderWidth = .0f;
        _portraitImageView.userInteractionEnabled = YES;
        _portraitImageView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        [_portraitImageView addGestureRecognizer:portraitTap];
    }
    return _portraitImageView;
}

@end
