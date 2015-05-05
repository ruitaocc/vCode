//
//  ViewController.h
//  vCode
//
//  Created by ruitaocc on 15/4/19.
//  Copyright (c) 2015年 ruitaocc. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ViewController:UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property IBOutlet UIImageView *imageView;
-(IBAction)doComput:(id)sender;
-(IBAction)chooseimg:(id)sender;
-(IBAction)saveImg:(id)sender;
@end

