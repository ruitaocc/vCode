//
//  FinalViewController.swift
//  vCode
//
//  Created by DarkTango on 5/11/15.
//  Copyright (c) 2015 ruitaocc. All rights reserved.
//

import UIKit

class FinalViewController: UIViewController,NSURLConnectionDelegate {
    @IBOutlet var imageView:UIImageView!
    @IBOutlet var backButton:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.hidden = true
        println("view did load!")
        let ud = NSUserDefaults.standardUserDefaults()
        let imgData:NSData = ud.objectForKey("originImg") as! NSData
        //println(imgData)
        if let oringinImg = UIImage(data: imgData){
            println("wrapped")
            imageView.image = oringinImg
        }
      
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveShortURL:", name: "didReceiveURL", object: nil)
        
        let a = RequestSender.shortURL
        if a != ""{
            backButton.hidden = false
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true);
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didReceiveShortURL(sender:AnyObject){
        println("received!!")
        println("url:"+RequestSender.shortURL)
        backButton.hidden = false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

/*
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
        secretkey = C10-705;
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
*/

