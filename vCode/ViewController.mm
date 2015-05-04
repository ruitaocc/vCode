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
    
    HQR *hqr = [HQR getInstance];

    //corection level 4level QR_ECLEVEL_L QR_ECLEVEL_M QR_ECLEVEL_Q QR_ECLEVEL_H
    [hqr setLevel:QR_ECLEVEL_L];
    
    [hqr setVersion:5];//2-40
    
    [hqr setThreshold_PaddingArea:50 nodePaddingArea:50 GuideRatio:1.0];
    
    UIImage *outimg = [hqr generateQRwithImg:img text:@"http://www.cairuitao.com" isGray: NO];
                                                     //"http://2vma.co/zxcASD"
    [_iamgeView setImage:outimg];
};

-(IBAction)chooseimg:(id)sender{
    printf("choose\n");
}

@end
