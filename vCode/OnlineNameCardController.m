//
//  OnlineNameCardController.m
//  vCode
//
//  Created by ruitaocc on 15/6/7.
//  Copyright (c) 2015年 ruitaocc. All rights reserved.
//

#import "OnlineNameCardController.h"

#import "WZFlashButton.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "DateHelper.h"
#import "NameCardKey.h"
#import "SHEmailValidator.h"

@interface OnlineNameCardController()
@property (assign,nonatomic)BOOL isNeedWaitForAvatarUp;
@end

@implementation OnlineNameCardController
@synthesize m_gebtn;
@synthesize m_portraitImageView;
@synthesize isNeedWaitForAvatarUp;

@synthesize m_ui_address;
@synthesize m_ui_birthday;
@synthesize m_ui_email;
@synthesize m_ui_fullname;
@synthesize m_ui_gender;
@synthesize m_ui_homepage;
@synthesize m_ui_intr;
@synthesize m_ui_job;
@synthesize m_ui_nickname;
@synthesize m_ui_org;
@synthesize m_ui_qq;
@synthesize m_ui_tel;
@synthesize m_ui_wechat;
@synthesize m_tableView;
-(void)viewDidLoad{
    [self setTitle:NSLocalizedString(@"OnlineNameCardTittle", nil) ];
    //UITableViewCell* lastCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:10 inSection:0]];
    
    
    [m_ui_fullname setLimmitLength:30];
    [m_ui_address setLimmitLength:80];
    [m_ui_birthday setLimmitLength:20];
    [m_ui_email setLimmitLength:30];
    [m_ui_homepage setLimmitLength:120];
    [m_ui_intr setLimmitLength:60];
    [m_ui_job setLimmitLength:40];
    [m_ui_nickname setLimmitLength:30];
    [m_ui_org setLimmitLength:60];
    [m_ui_wechat setLimmitLength:40];
    [m_ui_tel setLimmitLength:20];
    [m_ui_qq setLimmitLength:20];
    m_ui_fullname.text = @"cairuti";
    m_ui_email.text = @"email@caruitao.com";
    float s_width = self.view.frame.size.width;;
    CGRect btn_frame;
    btn_frame.size.width = 0.57*s_width;
    btn_frame.size.height = 44;
    btn_frame.origin.x = (s_width-btn_frame.size.width)/2;
    btn_frame.origin.y = (84-btn_frame.size.height)/2;
    [m_gebtn resetFrame:btn_frame];
    m_gebtn.backgroundColor = [UIColor colorWithRed:67.0/255.0f green:209.0f/255.0f blue:250.0/255.0 alpha:1.0f];
    m_gebtn.flashColor = [UIColor whiteColor];
    [m_gebtn setText:NSLocalizedString(@"ol_generate", nil) withTextColor:[UIColor whiteColor]];
    [m_gebtn setTextColor:[UIColor whiteColor]];
    __weak typeof(self) weakSefl = self;
    m_gebtn.clickBlock = ^(void){
        //[weakSelf performSegueWithIdentifier:@"HomeToURL" sender:weakSelf];
        //vilad data
        NSLog(@"Generate but click");
        if([[weakSefl.m_ui_fullname text] isEqualToString:@""]||[[weakSefl.m_ui_email text] isEqualToString:@""]){
            UIAlertView *alert = [[UIAlertView alloc] init];
            [alert setTitle:NSLocalizedString(@"namecard_must_fill", nil)];
            [alert addButtonWithTitle:@"OK"];
            [alert show];
            return ;
        };
        
        NSString *email = [weakSefl.m_ui_email text];
        NSError *error = nil;
        [[SHEmailValidator validator]validateSyntaxOfEmailAddress:email withError:&error];
        if (error) {
            // An error occurred
            UIAlertView *alert = [[UIAlertView alloc] init];
            [alert setTitle:NSLocalizedString(@"namecard_email_format_error", nil)];
            [alert addButtonWithTitle:@"OK"];
            [alert show];
            return ;
        }
        
        if (![RequestSender getIsPendingReq]) {
            //
            /*
             #define NC_K_FULLNAME @"NC_K_FULLNAME";
             #define NC_K_NICKNAME @"NC_K_NICKNAME";
             #define NC_K_GENDER  @"NC_K_GENDER";
             #define NC_K_BIRTHDAY  @"NC_K_BIRTHDAY";
             #define NC_K_AVATAR_LOCAL_NAME  @"NC_K_AVATAR_LOCAL_NAME";   <----no use for server
             #define NC_K_AVATAR_URL  @"NC_K_AVATAR_URL";
             #define NC_K_TEL  @"NC_K_TEL";
             #define NC_K_EMAIL  @"NC_K_EMAIL";
             #define NC_K_ADDRESS  @"NC_K_ADDRESS";
             #define NC_K_QQ  @"NC_K_QQ";
             #define NC_K_WECHAT @"NC_K_WECHAT";
             #define NC_K_HOMEPAGE  @"NC_K_HOMEPAGE";
             #define NC_K_JOB @"NC_K_JOB";
             #define NC_K_ORG  @"NC_K_ORG";
             #define NC_K_INTR  @"NC_K_INTR";
             */

            //
            [[NSUserDefaults standardUserDefaults]setObject:[weakSefl.m_ui_fullname text] forKey:@"NC_K_FULLNAME"];
            [[NSUserDefaults standardUserDefaults]setObject:[weakSefl.m_ui_nickname text] forKey:@"NC_K_NICKNAME"];
            [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInteger:[weakSefl.m_ui_gender selectedSegmentIndex]] forKey:@"NC_K_GENDER"];
            //[[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"NC_K_AVATAR_LOCAL_NAME"];
            //[[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"NC_K_AVATAR_URL"];
            [[NSUserDefaults standardUserDefaults]setObject:[weakSefl.m_ui_birthday text] forKey:@"NC_K_BIRTHDAY"];
            [[NSUserDefaults standardUserDefaults]setObject:[weakSefl.m_ui_tel text] forKey:@"NC_K_TEL"];
            [[NSUserDefaults standardUserDefaults]setObject:[weakSefl.m_ui_email text] forKey:@"NC_K_EMAIL"];
            [[NSUserDefaults standardUserDefaults]setObject:[weakSefl.m_ui_address text] forKey:@"NC_K_ADDRESS"];
            [[NSUserDefaults standardUserDefaults]setObject:[weakSefl.m_ui_qq text] forKey:@"NC_K_QQ"];
            [[NSUserDefaults standardUserDefaults]setObject:[weakSefl.m_ui_wechat text] forKey:@"NC_K_WECHAT"];
            [[NSUserDefaults standardUserDefaults]setObject:[weakSefl.m_ui_homepage text] forKey:@"NC_K_HOMEPAGE"];
            [[NSUserDefaults standardUserDefaults]setObject:[weakSefl.m_ui_job text] forKey:@"NC_K_JOB"];
            [[NSUserDefaults standardUserDefaults]setObject:[weakSefl.m_ui_org text] forKey:@"NC_K_ORG"];
            [[NSUserDefaults standardUserDefaults]setObject:[weakSefl.m_ui_intr text] forKey:@"NC_K_INTR"];
            
            //send request
            [[NSUserDefaults standardUserDefaults]setObject:@"online_namecard" forKey:@"uploadType"];
            [RequestSender sendRequest];
            [weakSefl performSegueWithIdentifier:@"OnlineNameCardToCutView" sender:weakSefl];

        }else{
            //pending
        }
        
        
        NSLog(@"generate call");
    };
    NSLog(@"tableview loaded");
   // [lastCell addSubview:m_generate_btn];
    
    [self loadPortrait];
    
    [m_portraitImageView.layer setCornerRadius:(108/2)];
    [m_portraitImageView.layer setMasksToBounds:YES];
    [m_portraitImageView setContentMode:UIViewContentModeScaleAspectFill];
    [m_portraitImageView setClipsToBounds:YES];
    m_portraitImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    m_portraitImageView.layer.shadowOffset = CGSizeMake(4, 4);
    m_portraitImageView.layer.shadowOpacity = 0.5;
    m_portraitImageView.layer.shadowRadius = 2.0;
    m_portraitImageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    m_portraitImageView.layer.borderWidth = 2.0f;
    m_portraitImageView.userInteractionEnabled = YES;
    m_portraitImageView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
    [m_portraitImageView addGestureRecognizer:portraitTap];
    [self initPreference];
   self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, -36, 0);
    isNeedWaitForAvatarUp = NO;
}
-(void)initPreference{
    
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"NC_K_FULLNAME"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"NC_K_NICKNAME"];
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:0] forKey:@"NC_K_GENDER"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"NC_K_AVATAR_LOCAL_NAME"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"NC_K_AVATAR_URL"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"NC_K_BIRTHDAY"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"NC_K_TEL"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"NC_K_EMAIL"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"NC_K_ADDRESS"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"NC_K_QQ"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"NC_K_WECHAT"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"NC_K_HOMEPAGE"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"NC_K_JOB"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"NC_K_ORG"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"NC_K_INTR"];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    // cutview.haveDataToEncode = true;
    //cutview.dataToEncode = textField.text;
    UIViewController *receiver = segue.destinationViewController;
    if([receiver respondsToSelector:@selector(setHaveDataToEncode:)]){
        NSNumber *val = [NSNumber numberWithBool:false];
        [receiver setValue:val forKey:@"haveDataToEncode"];
    }
    
}

- (void)editPortrait {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"actionsheet_cancel", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"actionsheet_take_photo", nil), NSLocalizedString(@"actionsheet_select_form_albums", nil), nil];
    [choiceSheet showInView:self.view];
}


- (void)loadPortrait {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        UIImage *protraitImg = [UIImage imageNamed:@"lena.jpg"] ;
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.m_portraitImageView.image = protraitImg;
        });
    });
}
#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.m_portraitImageView.image = editedImage;
    //save doc
    
    NSString *docDir  = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *avatarDir = [NSString stringWithFormat:@"%@%@",docDir,@"/avatar/"];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL dirExist;
    [fm fileExistsAtPath:avatarDir isDirectory:&dirExist];
    if(!dirExist)[fm createDirectoryAtPath:avatarDir withIntermediateDirectories:NO attributes:nil error:nil];
    NSString *avatarName = [DateHelper stringFromDate:[NSDate date] withFormat:@"yyyy_MM_dd_HH_mm_ss"];
    
    NSString *avatarPath = [NSString stringWithFormat:@"%@%@.png",avatarDir,avatarName];
    
    NSData *data  = UIImagePNGRepresentation(editedImage);
    
    [fm createFileAtPath:avatarPath contents:data attributes:nil];
    
    if([fm fileExistsAtPath:avatarPath]){
        NSLog(@"File Save To Path:%@",avatarPath);
        [[NSUserDefaults standardUserDefaults]setObject:avatarPath forKey:@"NC_K_AVATAR_LOCAL_NAME"];
        unsigned long long size = [[fm attributesOfItemAtPath:avatarPath error:nil] fileSize];
        NSNumber *num = [NSNumber numberWithLongLong:size];
        //send request
        [[NSUserDefaults standardUserDefaults]setObject:@"image" forKey:@"uploadType"];
        [[NSUserDefaults standardUserDefaults]setObject:[num description] forKey:@"avatar_size"];
        isNeedWaitForAvatarUp = YES;
        [RequestSender sendRequest];
    }
    
    
    
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
- (UIImageView *)xxxxm_portraitImageView {
    if (!m_portraitImageView) {
        CGFloat w = self.view.frame.size.width*0.57; CGFloat h = w;
        CGFloat x = (self.view.frame.size.width - w) / 2;
        CGFloat y = (self.view.frame.size.height - h) / 2;
        m_portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        //[_portraitImageView.layer setCornerRadius:(_portraitImageView.frame.size.height/2)];
        [m_portraitImageView.layer setMasksToBounds:YES];
        [m_portraitImageView setContentMode:UIViewContentModeScaleAspectFill];
        [m_portraitImageView setClipsToBounds:YES];
        m_portraitImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        m_portraitImageView.layer.shadowOffset = CGSizeMake(4, 4);
        m_portraitImageView.layer.shadowOpacity = 0.5;
        m_portraitImageView.layer.shadowRadius = 10.0;
        // _portraitImageView.layer.borderColor = [[UIColor blackColor] CGColor];
        m_portraitImageView.layer.borderWidth = .0f;
        m_portraitImageView.userInteractionEnabled = YES;
        m_portraitImageView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        [m_portraitImageView addGestureRecognizer:portraitTap];
    }else{
        
    }
    return m_portraitImageView;
}



#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0;
};
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0;
};
@end
