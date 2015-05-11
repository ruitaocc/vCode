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


-(IBAction)chooseimg:(id)sender{
    printf("choose\n");
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];

    [picker setDelegate:self];
    [self presentViewController:picker animated:YES completion:nil];
    
}

-(IBAction)doComput:(id)sender{
    [self sendRequest:@"http://www.baidu.com"];
    
};

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

- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}

-(void)sendRequest:(NSString*)url{
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://2vma.co/api/short_url"]];
    
    // Specify that it will be a POST request
    request.HTTPMethod = @"POST";
    
    // This is how we set header fields
    [request setValue:@"application/x-www-form-urlencoded ; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    
    // Convert your data and set your request's HTTPBody property
    NSString *stringData = [NSString stringWithFormat:@"tm=111&uuid=123&sign=1339ba084d895328187e53d1fe497d77&url=%@",url];
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"send request.");
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
    NSString *aString = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    NSError* jsonError;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingMutableContainers error:&jsonError];
    NSLog(aString);
    NSString* encodedata = [[json objectForKey:@"data"] objectForKey:@"shortUrl"];
    
    NSLog(@"%@",encodedata);
    UIImage *img = [_imageView image];
    NSLog(@"begin compute");
    HQR *hqr = [HQR getInstance];
    //corection level 4level QR_ECLEVEL_L QR_ECLEVEL_M QR_ECLEVEL_Q QR_ECLEVEL_H
    [hqr setLevel:QR_ECLEVEL_L];
    [hqr setVersion:5];//2-40
    [hqr setThreshold_PaddingArea:0 nodePaddingArea:100 GuideRatio:1.0];
    UIImage *outimg = [hqr generateQRwithImg:img text:encodedata isGray: NO];
    //"http://2vma.co/zxcASD"
    [_imageView setImage:outimg];
    NSLog(@"finished!");
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}


@end
