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
#import "ASValueTrackingSlider.h"
#import "WZFlashButton.h"
#import "../Pods/MMMaterialDesignSpinner/Pod/Classes/MMMaterialDesignSpinner.h"
#define ORIGINAL_MAX_WIDTH 640.0f

#define TabHeight 49.0f
#define ParaHeight 64.0f
#define StatusBatHeight 22.0f
#define NavBatHeight 44.0f
#define myBlue [UIColor colorWithRed:67.0/255.0f green:209.0f/255.0f blue:250.0/255.0 alpha:1.0f]

@interface CutViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate,UITabBarDelegate,InfiniTabBarDelegate,CPPickerViewDataSource, CPPickerViewDelegate, ASValueTrackingSliderDelegate,UIAlertViewDelegate>{

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
@property(strong ,nonatomic)UIImage *m_selected_img;
@property(strong ,nonatomic)UIImage *m_saved_img;

@property(strong ,nonatomic)UIImage *m_default_img;
@property(strong ,nonatomic)CPPickerView *horizontalPickerView;
@property(strong ,nonatomic)MMMaterialDesignSpinner *m_spinnerView;
@property(strong ,nonatomic)UISegmentedControl *correct_level_segment_contrl;
@property (nonatomic, strong) UIImageView *portraitImageView;
//control buttons
@property(strong , nonatomic)UIView* m_control_View;
@property(strong , nonatomic)InfiniTabBar* m_para_TabBar;
@property(strong , nonatomic)UITabBar* m_auto_TabBar;
@property(assign , nonatomic)int m_selected_item_tag;
//secondary control
@property(strong , nonatomic)UIScrollView* m_second_paraView;
@property(assign , nonatomic)BOOL m_second_paraView_isShowed;

//change & save &share
@property(strong , nonatomic)UIView *m_css_view;
@property(strong , nonatomic)WZFlashButton *m_change_img_btn;
@property(strong , nonatomic)WZFlashButton *m_save_and_share_btn;

@property(assign , nonatomic)BOOL m_isSelectUserImg;
@property(strong , nonatomic)WZFlashButton *m_generateBtn;
//p1
@end

@implementation CutViewController
@synthesize m_selected_img;
@synthesize m_default_img;
@synthesize horizontalPickerView;
@synthesize correct_level_segment_contrl;
@synthesize m_spinnerView;
@synthesize m_para_TabBar;
@synthesize m_auto_TabBar;
@synthesize m_control_View;
@synthesize m_selected_item_tag;
@synthesize m_second_paraView;
@synthesize m_second_paraView_isShowed;
@synthesize m_isSelectUserImg;
@synthesize m_generateBtn;
@synthesize m_css_view;
@synthesize m_change_img_btn;
@synthesize m_save_and_share_btn;
@synthesize m_saved_img;
- (void)viewDidLoad
{
    m_second_paraView_isShowed = NO;
    m_isSelectUserImg = NO;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [super viewDidLoad];
    [self.view addSubview:self.portraitImageView];
    [self loadPortrait];
    
//    UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [btn setTitle:NSLocalizedString(@"next_step2", @"") forState:UIControlStateNormal];
//    btn.backgroundColor = [UIColor whiteColor];
//    CGRect rect = CGRectMake(0, self.view.frame.size.height*3/4, self.view.frame.size.width, 50);
//    btn.frame = rect;
//    UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(next)];
//    [btn addGestureRecognizer:Tap];
//    [self.view addSubview:btn];
    
   // UIImageView *qrcodeview = [[UIImageView alloc] initWithFrame:_portraitImageView.frame];
   // qrcodeview.image = [UIImage imageNamed:@"qrcode_mask.png"];
    //[self.view addSubview:qrcodeview];
    min_version = 5;
    
    CGRect btn_frame;
    float s_width = self.view.frame.size.width;
    float s_height = self.view.frame.size.height;
    btn_frame.size.width = 0.57*s_width;
    btn_frame.size.height = 44;
    btn_frame.origin.x = (s_width - btn_frame.size.width)/2;
    btn_frame.origin.y = s_height - TabHeight - ParaHeight;
    m_generateBtn = [[WZFlashButton alloc]initWithFrame:btn_frame];
    m_generateBtn.textLabel.font = [UIFont systemFontOfSize:14];
    [m_generateBtn setText:NSLocalizedString(@"cut_generate_btn", nil) withTextColor:[UIColor whiteColor]];
    m_generateBtn.layer.cornerRadius = 5;
    [m_generateBtn clipsToBounds];
    __weak typeof(self) weakSelf = self;
    m_generateBtn.clickBlock = ^{
        [weakSelf next];
    };
    [m_generateBtn setBackgroundColor:[UIColor colorWithRed:67.0/255.0f green:209.0f/255.0f blue:250.0/255.0 alpha:1.0f]];
    [self.view addSubview:m_generateBtn];
    
    [self loadSecondaryParaView];
    [self loadControllTab];

    [self loadCSSView];
    
    CGRect spinner_frame ;
    spinner_frame.size.width = 40;
    spinner_frame.size.height = 40;
    spinner_frame.origin.x = (self.view.frame.size.width-spinner_frame.size.width)/2;
    spinner_frame.origin.y = (self.view.frame.size.height-spinner_frame.size.height - ParaHeight - TabHeight - StatusBatHeight - NavBatHeight)/2+(StatusBatHeight + NavBatHeight) - 18;
    m_spinnerView = [[MMMaterialDesignSpinner alloc] initWithFrame:spinner_frame];
    m_spinnerView.lineWidth = 2.5f;
    m_spinnerView.tintColor = [UIColor colorWithRed:69/255.0 green:209.0/255.0 blue:250/255.0 alpha:1.0];
    [self setTitle:NSLocalizedString(@"cut_view_title", nil)];
    
    //self.navigationController.navigationBar.barTintColor = myBlue;
    NSLog(@"my storyboard = %@", self.storyboard);
}

-(void)loadCSSView{
    float s_witdh = self.view.frame.size.width;
    float s_height = self.view.frame.size.height;
    
    CGRect viewframe;
    viewframe.size.width = s_witdh;
    viewframe.size.height = 38;
    viewframe.origin.x = 0;
    //init mid between _portraitImageView and tabcontrol
    viewframe.origin.y = (((s_height - TabHeight) - (_portraitImageView.frame.origin.y+_portraitImageView.frame.size.height))-viewframe.size.height)/2 + (_portraitImageView.frame.origin.y+_portraitImageView.frame.size.height);
    m_css_view = [[UIView alloc] initWithFrame:viewframe];
    [m_css_view setBackgroundColor:[UIColor whiteColor]];
    
    //1/3
    viewframe.origin.y = 0;
    viewframe.size.width = 0.5*s_witdh*0.57;
    viewframe.origin.x = (s_witdh/2-viewframe.size.width)/2 + 0.5*s_witdh*0.1;
    m_change_img_btn = [[WZFlashButton alloc] initWithFrame:viewframe];
    [m_change_img_btn setBackgroundColor:myBlue];
    [m_change_img_btn setText:NSLocalizedString(@"cut_change_img", nil) withTextColor:[UIColor whiteColor]];
    m_change_img_btn.textLabel.font = [UIFont systemFontOfSize:14];
    m_change_img_btn.layer.cornerRadius = viewframe.size.height/2;
    [m_change_img_btn clipsToBounds];
    __weak typeof(self)weakself = self;
    m_change_img_btn.clickBlock = ^{
        [weakself editPortrait];
    };
    [m_css_view addSubview:m_change_img_btn];
    
    viewframe.size.width = 0.5*s_witdh*0.57;
    viewframe.origin.x = (s_witdh/2-viewframe.size.width)/2+s_witdh/2 - 0.5*s_witdh*0.1;
    m_save_and_share_btn = [[WZFlashButton alloc] initWithFrame:viewframe];
    [m_save_and_share_btn setBackgroundColor:myBlue];
    m_save_and_share_btn.layer.cornerRadius = viewframe.size.height/2;
    m_save_and_share_btn.textLabel.font = [UIFont systemFontOfSize:14];
    [m_save_and_share_btn clipsToBounds];
    [m_save_and_share_btn setText:NSLocalizedString(@"cut_save_and_share", nil) withTextColor:[UIColor whiteColor]];
    m_save_and_share_btn.clickBlock = ^{
        [weakself saveAndShare];
    };
    [m_css_view addSubview:m_save_and_share_btn];
    [self.view addSubview:m_css_view];
    [m_css_view setHidden:YES];
}

// 指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if(error != NULL){
        if ([error code]==-3310) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"premission_deny_title", nil)
                                                        message:NSLocalizedString(@"premission_deny_msg", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"save_alert_ok",nil)
                                              otherButtonTitles:nil];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"save_failed", nil)
                                                        message:[error description]
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"save_alert_ok",nil)
                                              otherButtonTitles:nil];
            [alert show];
        }
    }else{
        NSLog(@"save success!");
        NSLog(@"path: %@",contextInfo);
        m_saved_img = image;
        [self performSegueWithIdentifier:@"gotoSaveAndShare" sender:self];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *receiver = segue.destinationViewController;
    if([receiver respondsToSelector:@selector(setM_shareImg:)]){
        [receiver setValue:m_saved_img forKey:@"m_shareImg"];
       // [receiver setValue:[m_historyAry objectAtIndex:m_selected_index]forKey:@"item"];
    }
}
-(void)saveAndShare{
    NSLog(@"saveAndShare");
    UIImage *img = _portraitImageView.image;
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    return;
//    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    [library writeImageToSavedPhotosAlbum:[img CGImage] orientation:(ALAssetOrientation)[img imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
//        if(error){
//            if ([error code]==-3310) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"premission_deny_title", nil)
//                                                                message:NSLocalizedString(@"premission_deny_msg", nil)
//                                                               delegate:self
//                                                      cancelButtonTitle:NSLocalizedString(@"save_alert_ok",nil)
//                                                      otherButtonTitles:nil];
//                [alert show];
//            }else{
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"save_failed", nil)
//                                                                message:[error description]
//                                                               delegate:self
//                                                      cancelButtonTitle:NSLocalizedString(@"save_alert_ok",nil)
//                                                      otherButtonTitles:nil];
//                [alert show];
//            }
//        }else{
//            NSLog(@"save success!");
//            m_asset_url = assetURL ;
//            NSLog(@"path: %@",m_asset_url);
//            [self performSegueWithIdentifier:@"gotoSaveAndShare" sender:self];
//        }
//    }];
}
#pragma mark - CPPickerViewDataSource

- (NSInteger)numberOfItemsInPickerView:(CPPickerView *)pickerView
{
    return 40-min_version+1;
}
- (NSString *)pickerView:(CPPickerView *)pickerView titleForItem:(NSInteger)item
{
    return [NSString stringWithFormat:@"%d", (int)(min_version + item)];
}
#pragma mark - CPPickerViewDelegate

- (void)pickerView:(CPPickerView *)pickerView didSelectItem:(NSInteger)item
{
    NSLog(@"Version :%@",[NSString stringWithFormat:@"%d", min_version + item]);
    m_para_version = (int)(min_version + item);
    
    [self computeQR];
}

-(void)loadSecondaryParaView{
    float s_witdh = self.view.frame.size.width;
    float s_height = self.view.frame.size.height;
    float height = ParaHeight;
    CGRect frame = CGRectMake(0, s_height, s_witdh, height);
    m_second_paraView = [[UIScrollView alloc] initWithFrame:frame];
    m_second_paraView.contentSize = CGSizeMake(6*s_witdh, height);
    m_second_paraView.pagingEnabled = NO;
    m_second_paraView.scrollEnabled = NO;
    m_second_paraView.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
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
    style_label.font = [UIFont systemFontOfSize:0.9*sysFontSize];
    style_label.textColor = [UIColor blackColor];
    [stylesubview addSubview:style_label];
    UITabBarItem *topRated = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemTopRated tag:10];
    UITabBarItem *featured = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:11];
    UITabBarItem *recents = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:12];
    UITabBarItem *contacts = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:13];
    UITabBarItem *contacts2 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:14];
    InfiniTabBar * m_style_TabBar = [[InfiniTabBar alloc] initWithItemFrame:CGRectMake(0.2*s_witdh, (ParaHeight-TabHeight)/2, 0.78*s_witdh, TabHeight) withItems:[NSArray arrayWithObjects:topRated,featured,recents,contacts,contacts2,nil]];
    [m_style_TabBar selectItemWithTag:10];
    m_style_TabBar.infiniTabBarDelegate = self;
    m_style_TabBar.bounces = NO;
    m_style_TabBar.scrollEnabled = NO;
    m_style_TabBar.pagingEnabled = NO;
    m_style_TabBar.layer.cornerRadius = 10;
    [stylesubview addSubview:m_style_TabBar];
    
    [m_second_paraView addSubview:stylesubview];
    
    //version
    frame.origin.x = 1 * s_witdh;
    UIView *sub_verison_view = [[UIView alloc] initWithFrame:frame];
    UILabel *version_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0.3*s_witdh, height)];
    version_label.textAlignment = NSTextAlignmentCenter;
    version_label.text = NSLocalizedString(@"p_label_version", nil);
    version_label.font = [UIFont systemFontOfSize:0.9*sysFontSize];
    [sub_verison_view addSubview:version_label];
    horizontalPickerView = [[CPPickerView alloc] initWithFrame:CGRectMake(0.35*s_witdh, (height-40)/2, 0.6*s_witdh, 40)];
    horizontalPickerView.backgroundColor = [UIColor whiteColor];
    horizontalPickerView.dataSource = self;
    horizontalPickerView.delegate = self;
    horizontalPickerView.allowSlowDeceleration = YES;
    horizontalPickerView.showGlass = YES;
    horizontalPickerView.peekInset = UIEdgeInsetsMake(0, 0.6*s_witdh*0.3, 0, 0.6*s_witdh*0.3);
    [horizontalPickerView reloadData];;
   // horizontalPickerView setSelectedItem:
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
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:NSLocalizedString(@"correct_low", nil),NSLocalizedString(@"correct_mid", nil),NSLocalizedString(@"correct_quality", nil),NSLocalizedString(@"correct_high", nil),nil];
    correct_level_segment_contrl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    [correct_level_segment_contrl setFrame:CGRectMake(0.3*s_witdh, (height-28)/2, 0.65*s_witdh, 28)];
    [correct_level_segment_contrl setSelectedSegmentIndex:0];
    [correct_level_segment_contrl addTarget:self action:@selector(correctionLevelChanged:) forControlEvents:UIControlEventValueChanged];
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
    UIColor *blue = [UIColor colorWithHue:0.55 saturation:0.75 brightness:1.0 alpha:1.0];
    UIColor *green = [UIColor colorWithHue:0.3 saturation:0.65 brightness:0.8 alpha:1.0];
    UIColor *red = [UIColor colorWithHue:0.0 saturation:0.8 brightness:1.0 alpha:1.0];
    ASValueTrackingSlider  *coding_slider = [[ASValueTrackingSlider alloc] initWithFrame:CGRectMake(0.3*s_witdh, 24, 0.65*s_witdh, 30)];
    [coding_slider setTag:40];
    coding_slider.delegate = self;
    coding_slider.maximumValue = 127.0;
    [coding_slider setMaxFractionDigitsDisplayed:0];
    coding_slider.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:10];
    [coding_slider setPopUpViewAnimatedColors:@[red, green,]
                               withPositions:@[@20, @100]];
    coding_slider.popUpViewArrowLength = 4.0;
    coding_slider.popUpViewCornerRadius = 5.0;
    [sub_coding_view addSubview:coding_slider];
    [m_second_paraView addSubview:sub_coding_view];
    
    coding_slider.value = 70;
    
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
    ASValueTrackingSlider * padding_slider = [[ASValueTrackingSlider alloc] initWithFrame:CGRectMake(0.3*s_witdh, 24, 0.65*s_witdh, 30)];
    [padding_slider setTag:50];
    padding_slider.delegate = self;
    padding_slider.maximumValue = 127.0;
    [padding_slider setMaxFractionDigitsDisplayed:0];
    padding_slider.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:10];
    [padding_slider setPopUpViewAnimatedColors:@[red, green,]
                                withPositions:@[@20, @100]];
    padding_slider.popUpViewArrowLength = 4.0;
    padding_slider.popUpViewCornerRadius = 5.0;
    [sub_papding_view addSubview:padding_slider];
    [m_second_paraView addSubview:sub_papding_view];
    
    padding_slider.value = 50;
    
    //ratio
    frame.origin.x = 5*s_witdh;
    UIView *subview = [[UIView alloc] initWithFrame:frame];
    UILabel *r_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0.3*s_witdh, height)];
    r_label.textAlignment = NSTextAlignmentCenter;
    r_label.text = NSLocalizedString(@"p_label_ratio", nil);
    r_label.font = [UIFont systemFontOfSize:0.9*sysFontSize];
    [subview addSubview:r_label];
    ASValueTrackingSlider  *r_slider = [[ASValueTrackingSlider alloc] initWithFrame:CGRectMake(0.3*s_witdh, 24, 0.65*s_witdh, 30)];
    [r_slider setTag:60];
    r_slider.delegate = self;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterPercentStyle];
    [r_slider setNumberFormatter:formatter];
    [r_slider setMaxFractionDigitsDisplayed:0];
    r_slider.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:10];
    [r_slider setPopUpViewAnimatedColors:@[blue, blue,]
                                 withPositions:@[@0.2, @1.0]];
    r_slider.popUpViewArrowLength = 4.0;
    r_slider.popUpViewCornerRadius = 5.0;
    [subview addSubview:r_slider];
    [m_second_paraView addSubview:subview];
    r_slider.value = 1.0;
    
    [self.view addSubview:m_second_paraView];
}

#pragma -mark ASValueTrackingSliderDelegate
- (void)sliderWillDisplayPopUpView:(ASValueTrackingSlider *)slider{
};
- (void)sliderWillHidePopUpView:(ASValueTrackingSlider *)slider{
    if(slider.tag == 40){
        m_para_coding_area = slider.value;
        NSLog(@"m_para_coding_area : %f",m_para_coding_area);
    }else if (slider.tag == 50){
        m_para_padding_area = slider.value;
        NSLog(@"m_para_padding_area : %f",m_para_padding_area);
    }else if (slider.tag == 60){
        m_para_ratio = slider.value;
        NSLog(@"m_para_ratio : %f",m_para_ratio);
    }
    [self computeQR];
};
- (void)sliderDidHidePopUpView:(ASValueTrackingSlider *)slider{
    
};


-(void)correctionLevelChanged:(UISegmentedControl *)Seg{
    m_para_level = Seg.selectedSegmentIndex;
    NSLog(@"Correction Level:%d",m_para_level);
    [self computeQR];
}

-(void)loadControllTab{
    float s_witdh = self.view.frame.size.width;
    float s_height = self.view.frame.size.height;
    float auto_width = s_witdh*0.3;
    float seperate = 0;
    float para_width = s_witdh-auto_width-seperate;
    float height = TabHeight;
    m_control_View = [[UIView alloc] initWithFrame:CGRectMake(0, s_height, s_witdh, height)];
    m_control_View.backgroundColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1];
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
    //[m_para_TabBar setContentInset:UIEdgeInsetsMake(0, 30, 0, 0)];
    [m_para_TabBar showsHorizontalScrollIndicator];
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
    
    //
    if(tag>=10 && tag<=14){
        m_para_style = tag-10;
        NSLog(@"Style:%d",m_para_style);
        [self computeQR];
        return;
    }
    
    if(m_selected_item_tag==tag){
        NSLog(@"do no thing");
        return;
    }
    if(m_selected_item_tag==0){
        [m_auto_TabBar setSelectedItem:nil];
    }
    if(tag==0){
        [m_para_TabBar selectItemWithTag:-1];
        [self autoCompute];
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
    float f_height = TabHeight;
    float sec_height = ParaHeight;
    m_second_paraView.alpha = 1.0;
    CGRect sf = m_second_paraView.frame;
    sf.origin.y = s_height-f_height-sec_height;
    m_second_paraView.frame = sf;
    sf.origin.y = s_height-f_height;
    CGRect css_frame= m_css_view.frame;
    css_frame.origin.y = (((s_height - TabHeight) - (_portraitImageView.frame.origin.y+_portraitImageView.frame.size.height))-css_frame.size.height)/2 + (_portraitImageView.frame.origin.y+_portraitImageView.frame.size.height);
    [UIView animateWithDuration:0.25 //时长
                          delay:0 //延迟时间
                        options:UIViewAnimationOptionTransitionNone//动画效果
                     animations:^{
                         
                         m_second_paraView.frame = sf;
                         m_second_paraView.alpha = 0.0;
                         m_css_view.frame = css_frame;
                     } completion:^(BOOL finish){
                         m_second_paraView_isShowed = NO;
                         //动画结束时调用
                         //[self computeQR];
                     }];
}
-(void)showSecondParaView{
    float s_height = self.view.frame.size.height;
    float f_height = TabHeight;
    float sec_height = ParaHeight;
    m_second_paraView.alpha = 0.0;
    CGRect sf = m_second_paraView.frame;
    sf.origin.y = s_height-f_height;
    m_second_paraView.frame = sf;
    sf.origin.y = s_height-f_height-sec_height;
    
    CGRect css_frame= m_css_view.frame;
    css_frame.origin.y = (((s_height - TabHeight-ParaHeight) - (_portraitImageView.frame.origin.y+_portraitImageView.frame.size.height))-css_frame.size.height)/2 + (_portraitImageView.frame.origin.y+_portraitImageView.frame.size.height);
    
    [UIView animateWithDuration:0.5 //时长
                          delay:0 //延迟时间
                        options:UIViewAnimationOptionTransitionNone//动画效果
                     animations:^{
                         
                         m_second_paraView.frame = sf;
                         m_second_paraView.alpha = 1;
                         m_css_view.frame = css_frame;
                         
                     } completion:^(BOOL finish){
                         //动画结束时调用
                         m_second_paraView_isShowed = YES;
                         //[self computeQR];
                     }];
}

-(void)showParaMainControlTab{
    float s_height = self.view.frame.size.height;
    float s_witdh = self.view.frame.size.width;
    float height = TabHeight;
    CGRect f = m_control_View.frame;
    f.origin.y = s_height -height;
    m_control_View.alpha = 0.0;
    m_second_paraView.alpha = 0.0;
    CGRect sf = m_second_paraView.frame;
    sf.origin.y = s_height-height;
    [m_generateBtn setHidden:YES];
    [m_css_view setHidden:NO];
    m_css_view.alpha = 0.0;
    CGRect css_frame= m_css_view.frame;
    css_frame.origin.y = (((s_height - TabHeight) - (_portraitImageView.frame.origin.y+_portraitImageView.frame.size.height))-css_frame.size.height)/2 + (_portraitImageView.frame.origin.y+_portraitImageView.frame.size.height);
    [UIView animateWithDuration:0.5 //时长
                          delay:0 //延迟时间
                        options:UIViewAnimationOptionTransitionNone//动画效果
                     animations:^{
                         
                         //动画设置区域
                         m_control_View.frame=f;
                         m_control_View.alpha = 1.0;
                         
                         m_second_paraView.frame = sf;
                         m_css_view.frame = css_frame;
                         m_css_view.alpha = 1.0;
                         
                     } completion:^(BOOL finish){
                         //动画结束时调用
                         [self computeQR];
                         [m_para_TabBar setContentOffset:CGPointMake(s_witdh/10, 0) animated:YES];
                     }];
}

-(void)hideParaMainControlTab{
    float s_height = self.view.frame.size.height;
    CGRect f = m_control_View.frame;
    f.origin.y = s_height;
    m_control_View.alpha = 1.0;
    CGRect sf = m_second_paraView.frame;
    sf.origin.y = s_height;
    [UIView animateWithDuration:0.5 //时长
                          delay:0 //延迟时间
                        options:UIViewAnimationOptionTransitionNone//动画效果
                     animations:^{
                         
                         //动画设置区域
                         m_control_View.frame=f;
                         m_control_View.alpha=0.0;
                         m_second_paraView.frame = sf;
                         m_second_paraView.alpha = 0.0;
                     } completion:^(BOOL finish){
                         //动画结束时调用
                         //[self computeQR];
                     }];
}
-(void)autoCompute{
    NSLog(@"AutoParamether");
    [self configParameters];
    [self computeQR];
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
    if(m_spinnerView && [m_spinnerView isAnimating])return;
    if(m_spinnerView){
        [self.view addSubview:m_spinnerView];
        [m_spinnerView startAnimating];
    }
    UIImage *img = nil;
    if(m_isSelectUserImg){
        img = m_selected_img;
    }else{
        img= m_default_img;
    }
    [QRDetector generateQRforView:_portraitImageView withImg:img text:_dataToEncode style:m_para_style version: m_para_version level:m_para_level codingarea:m_para_coding_area paddingarea:m_para_padding_area guideratio:m_para_ratio withFinishedBlock:^{
        if(m_spinnerView && [m_spinnerView isAnimating]){
            [m_spinnerView stopAnimating];
            [m_spinnerView removeFromSuperview];
        }
    }];
    
    //UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
    
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
    }
}
-(void)configParameters{
    if(_haveDataToEncode){
        min_version = [QRDetector getMinimunVersionWithText:_dataToEncode];
        NSLog(@"min_version:%d",min_version);
        m_para_version = min_version > 5 ? min_version: 5;
        m_para_level = 0;
        m_para_style = 0;
        m_para_padding_area = 50;
        m_para_coding_area = 70;
        m_para_ratio = 1.0;
        [horizontalPickerView reloadData];
    }
}

- (void) didReceiveShortURL:(NSNotification*) notification{
    if (m_spinnerView) {
        [m_spinnerView stopAnimating];
        [m_spinnerView removeFromSuperview];
    }
    if ([notification.name isEqualToString:@"didReceiveURL"]) {
        _dataToEncode = RequestSender.shortURL;
        NSLog(@"%@",_dataToEncode);
        _haveDataToEncode = YES;
        [self configParameters];
        [self next];
    }
    if ([notification.name isEqualToString:@"requestERROR"]) {
        NSLog(@"Network error!");
    }
    [self configParameters];
}

#pragma marks --UIAlertVIewDelegate --
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==101){
        NSLog(@"FirstOther %d",buttonIndex);
        if(buttonIndex==1){
            //OK --go on clicked
            if (_haveDataToEncode) {
                [self configParameters];
                [self showParaMainControlTab];
            }
            else{
                [self.view addSubview:m_spinnerView];
                [m_spinnerView startAnimating];
            }
            
        }
        if(buttonIndex ==0){
            //cancel --> choose
            [self editPortrait];
        }
    }

}

- (void) next{
    if (m_spinnerView && [m_spinnerView isAnimating]) {
        return;
    }
    if(!m_isSelectUserImg){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"cut_isselect_user_img_title",nil) message:NSLocalizedString(@"cut_isselect_user_img",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cut_isselect_user_img_cancel",nil)
                                             otherButtonTitles:NSLocalizedString(@"cut_isselect_user_img_ok", nil),nil];
        alert.tag = 101;
        [alert show];
        return;
    }
    NSLog(@"prepare to compute QR code");
    if (_haveDataToEncode) {
        [self configParameters];
        [self showParaMainControlTab];
    }
    else{
        [self.view addSubview:m_spinnerView];
        [m_spinnerView startAnimating];
    }
}

- (void)loadPortrait {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        dispatch_sync(dispatch_get_main_queue(), ^{
            UIImage *protraitImg = [UIImage imageNamed:@"add.png"] ;
            m_default_img = [UIImage imageNamed:@"lena.jpg"];
            self.portraitImageView.image = protraitImg;
            m_selected_img = [protraitImg copy];
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
    m_selected_img = [editedImage copy];
    self.portraitImageView.image = editedImage;
    m_isSelectUserImg = YES;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
    [self next];
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
        CGFloat w = self.view.frame.size.width*0.67; CGFloat h = w;
        CGFloat x = (self.view.frame.size.width - w) / 2;
        CGFloat y = (self.view.frame.size.height - h - ParaHeight - TabHeight - StatusBatHeight - NavBatHeight) / 2+(StatusBatHeight + NavBatHeight) - 18;
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
        _portraitImageView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        [_portraitImageView addGestureRecognizer:portraitTap];
    }
    return _portraitImageView;
}

@end
