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
    UIImage *img = [_imageView image];
    
    HQR *hqr = [HQR getInstance];

    //corection level 4level QR_ECLEVEL_L QR_ECLEVEL_M QR_ECLEVEL_Q QR_ECLEVEL_H
    [hqr setLevel:QR_ECLEVEL_L];
    
    [hqr setVersion:5];//2-40
    
    [hqr setThreshold_PaddingArea:50 nodePaddingArea:50 GuideRatio:1.0];
    
    UIImage *outimg = [hqr generateQRwithImg:img text:@"helloworld!" isGray: NO];
                                                     //"http://2vma.co/zxcASD"
    [_imageView setImage:outimg];
};

-(IBAction)chooseimg:(id)sender{
    printf("choose\n");
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];

    [picker setDelegate:self];
    [self presentViewController:picker animated:YES completion:nil];
    
}



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
@end
