//
//  OnlineNameCardController.h
//  vCode
//
//  Created by ruitaocc on 15/6/7.
//  Copyright (c) 2015年 ruitaocc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZFlashButton.h"
#import "vCode-swift.h"
#import "VPImageCropperViewController.h"

#define ORIGINAL_MAX_WIDTH 640.0f
@interface OnlineNameCardController : UITableViewController<UITableViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate>
@property(strong,nonatomic)IBOutlet WZFlashButton *m_gebtn;
@property(strong,nonatomic)IBOutlet UIImageView *m_portraitImageView;

@property(strong, nonatomic)IBOutlet HoshiTextField *m_ui_fullname;
@property(strong, nonatomic)IBOutlet HoshiTextField *m_ui_nickname;
@property(strong, nonatomic)IBOutlet UISegmentedControl *m_ui_gender;
@property(strong, nonatomic)IBOutlet HoshiTextField *m_ui_birthday;
@property(strong, nonatomic)IBOutlet HoshiTextField *m_ui_email;
@property(strong, nonatomic)IBOutlet HoshiTextField *m_ui_tel;
@property(strong, nonatomic)IBOutlet HoshiTextField *m_ui_address;
@property(strong, nonatomic)IBOutlet HoshiTextField *m_ui_qq;
@property(strong, nonatomic)IBOutlet HoshiTextField *m_ui_wechat;
@property(strong, nonatomic)IBOutlet HoshiTextField *m_ui_homepage;
@property(strong, nonatomic)IBOutlet HoshiTextField *m_ui_job;
@property(strong, nonatomic)IBOutlet HoshiTextField *m_ui_org;
@property(strong, nonatomic)IBOutlet HoshiTextField *m_ui_intr;

@property(strong, nonatomic)IBOutlet UITableView *m_tableView;
-(IBAction)birthdaySelect:(id)sender;
-(IBAction)AddressSelect:(id)sender;
@end
