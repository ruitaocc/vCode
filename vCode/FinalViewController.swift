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

    override func viewDidLoad() {
        super.viewDidLoad()
        println("view did load!")
        let ud = NSUserDefaults.standardUserDefaults()
        let imgData:NSData = ud.objectForKey("originImg") as! NSData
        //println(imgData)
        if let oringinImg = UIImage(data: imgData){
            println("wrapped")
            imageView.image = oringinImg
        }
        sendRequest()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendRequest(){
       
        var uuid:String = "123"
        var message:String = ""
        var url:String = ""
        var vcard:String = ""
        var img:NSData
        var tm:String = ""
        var sign:String = ""
        
        let uploadType:String = NSUserDefaults.standardUserDefaults().objectForKey("uploadType") as! String
        
        //set tm
        let dat:NSDate = NSDate(timeIntervalSinceNow: 0)
        let a:NSTimeInterval = dat.timeIntervalSince1970
        tm = String(stringInterpolationSegment: a)
        tm = tm.stringByReplacingOccurrencesOfString(".", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        println("tm: "+tm)
        
        //set sign
        let secretKey:String = "C10-705"
        sign = md5Encryptor.md5(secretKey+tm+uuid)
        
        //set upload params
        switch uploadType{
        case "txt":
            message = NSUserDefaults.standardUserDefaults().objectForKey("text") as! NSString as String
            println(message)
        default:
            break
        }
        
        let request = NSMutableURLRequest()
        request.URL = NSURL(string: "http://2vma.co/api/short_url")
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded ; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let postData = "tm="+tm+"&uuid="+uuid+"&sign="+sign+"&message="+message+"&url="+url+"&vcard="+vcard
        //let postData = "tm=111&uuid=123&sign=1339ba084d895328187e53d1fe497d77&url=http://www.baidu.com"
        request.HTTPBody = postData.dataUsingEncoding(NSUTF8StringEncoding)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
        (response,data,error) in
            let strdata = NSString(data: data, encoding: NSUTF8StringEncoding)!
            let json:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            println(strdata)
            println(json)
        })
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

