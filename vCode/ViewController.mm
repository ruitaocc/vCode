//
//  ViewController.m
//  vCode
//
//  Created by ruitaocc on 15/4/19.
//  Copyright (c) 2015年 ruitaocc. All rights reserved.
//

#import "ViewController.h"
#import "HQR.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)doComput:(id)sender{
    UIImage *img = [_iamgeView image];
    //HQR *hqr = [[HQR alloc] init];
    HQR *hqr = [HQR getInstance];
    
    [hqr setLevel:QR_ECLEVEL_L];//corection level
    
    [hqr setSize:3];
    UIImage *outimg = [hqr generateQRwithImg:img text:@"http://cairuitao.com"];
                                                     //"http://2vma.co/zxcASD"
    [_iamgeView setImage:outimg];
};
@end
