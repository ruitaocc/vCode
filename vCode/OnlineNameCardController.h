//
//  OnlineNameCardController.h
//  vCode
//
//  Created by ruitaocc on 15/6/7.
//  Copyright (c) 2015年 ruitaocc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZFlashButton.h"

#import "VPImageCropperViewController.h"

#define ORIGINAL_MAX_WIDTH 640.0f
@interface OnlineNameCardController : UITableViewController<UITableViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate>
@property(strong,nonatomic)IBOutlet WZFlashButton *m_gebtn;
@property(strong,nonatomic)IBOutlet UIImageView *m_portraitImageView;
@end
