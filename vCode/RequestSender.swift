//
//  RequestSender.swift
//  vCode
//
//  Created by DarkTango on 5/12/15.
//  Copyright (c) 2015 ruitaocc. All rights reserved.
//

import Foundation
enum RSatus : Int{
    case Unknown = 0
    case OK
    case Uploading
}
class RequestSender:NSObject{
    static var shortURL:String = ""
    static var baseURL:String = "http://2vma.co"
    static var uploadType:String = ""
    static var namecardAvatarURL = ""
    static var status:RSatus = RSatus.OK
    static var hasPendingReq:Bool = false // is there any request pending, should stop the follow req.

    override init(){
        println("init for sender")
    }
    
    deinit{
        println("deinit for sender")
    }
    
    class func getRStatus()->RSatus{
        return self.status
    }
    
    class func getIsPendingReq()->Bool{
        return self.hasPendingReq
    }
    
    class func sendRequest()->Bool{
        
        if(self.hasPendingReq){
            return false
        }
        if(self.status == RSatus.Uploading){
            self.hasPendingReq = true
            return true
        }
        
        self.status = RSatus.Uploading
        var uuid:String = "123"
        var message:String = ""
        var url:String = ""
        var vcard:String = ""
        var img:NSData
        var tm:String = ""
        var sign:String = ""
        var namecard:NameCardEntry = NameCardEntry();
        
        self.uploadType = NSUserDefaults.standardUserDefaults().objectForKey("uploadType") as! String
        
        //set tm

        let dat:NSDate = NSDate(timeIntervalSinceNow: 0)
        let a:NSTimeInterval = dat.timeIntervalSince1970
        tm = String(stringInterpolationSegment: a)
        tm = tm.stringByReplacingOccurrencesOfString(".", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        println("tm: "+tm)
        
        //set sign
        let secretKey:String = "C10-705"
        sign = md5Encryptor.md5(secretKey+tm+uuid)
        
        let request = NSMutableURLRequest();
        var postData:String = ""
        request.HTTPMethod = "POST"
        
        //set upload params
        switch uploadType{
        case "txt":
            self.shortURL = ""
            request.URL = NSURL(string: "http://2vma.co/api/message")
            message = NSUserDefaults.standardUserDefaults().objectForKey("text") as! String
            postData = "tm="+tm+"&uuid="+uuid+"&sign="+sign+"&message="+message+"&url="+url+"&vcard="+vcard
            request.setValue("application/x-www-form-urlencoded ; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = postData.dataUsingEncoding(NSUTF8StringEncoding)
            
            println(message)
        case "url":
            
            self.shortURL = ""
            request.URL = NSURL(string: "http://2vma.co/api/short_url")
            url = NSUserDefaults.standardUserDefaults().objectForKey("url") as! String
            postData = "tm="+tm+"&uuid="+uuid+"&sign="+sign+"&message="+message+"&url="+url+"&vcard="+vcard
            request.setValue("application/x-www-form-urlencoded ; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = postData.dataUsingEncoding(NSUTF8StringEncoding)
            
            println(url)
        case "qrcode":
            RequestSender.shortURL = ""
        case "online_namecard":
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
            
            self.shortURL = ""
            request.URL = NSURL(string: "http://2vma.co/api/card")
            namecard.m_fullname = NSUserDefaults.standardUserDefaults().objectForKey("NC_K_FULLNAME") as! String
            namecard.m_nickname = NSUserDefaults.standardUserDefaults().objectForKey("NC_K_NICKNAME") as! String
            namecard.m_gender = NSUserDefaults.standardUserDefaults().objectForKey("NC_K_GENDER") as! Int
            //let _gender = namecard.m_gender
            //let str_gender = String(_gender)
            
            let str_gender : String =  NSNumberFormatter().stringFromNumber(namecard.m_gender)!
            
            namecard.m_birthday = NSUserDefaults.standardUserDefaults().objectForKey("NC_K_BIRTHDAY") as! String
            
            namecard.m_avatar_url = NSUserDefaults.standardUserDefaults().objectForKey("NC_K_AVATAR_URL") as! String
            namecard.m_avatar_local_name = NSUserDefaults.standardUserDefaults().objectForKey("NC_K_AVATAR_LOCAL_NAME") as! String
            
            namecard.m_tel = NSUserDefaults.standardUserDefaults().objectForKey("NC_K_TEL") as! String
            namecard.m_email = NSUserDefaults.standardUserDefaults().objectForKey("NC_K_EMAIL") as! String
            namecard.m_address = NSUserDefaults.standardUserDefaults().objectForKey("NC_K_ADDRESS") as! String
            namecard.m_qq   = NSUserDefaults.standardUserDefaults().objectForKey("NC_K_QQ") as! String
            namecard.m_wechat = NSUserDefaults.standardUserDefaults().objectForKey("NC_K_WECHAT") as! String
            namecard.m_homepage = NSUserDefaults.standardUserDefaults().objectForKey("NC_K_HOMEPAGE") as! String
            namecard.m_job = NSUserDefaults.standardUserDefaults().objectForKey("NC_K_JOB") as! String
            namecard.m_org = NSUserDefaults.standardUserDefaults().objectForKey("NC_K_ORG") as! String
            namecard.m_intr = NSUserDefaults.standardUserDefaults().objectForKey("NC_K_INTR") as! String
            postData = "tm="+tm+"&uuid="+uuid+"&sign="+sign+"&fullname="+namecard.m_fullname+"&nickname="+namecard.m_nickname+"&gender="+str_gender+"&birthday="+namecard.m_birthday+"&avatar="+namecard.m_avatar_url+"&tel="+namecard.m_tel+"&email="+namecard.m_email+"&address="+namecard.m_address+"&qq="+namecard.m_qq+"&wechat="+namecard.m_wechat+"&homepate="+namecard.m_homepage+"&job="+namecard.m_job+"&org="+namecard.m_org+"&intr="+namecard.m_intr
            request.setValue("application/x-www-form-urlencoded ; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = postData.dataUsingEncoding(NSUTF8StringEncoding)
            
            println(url)
        case "image":
            self.namecardAvatarURL = ""
            request.URL = NSURL(string: "http://2vma.co/api/image")
            //file
            let localFIleName = NSUserDefaults.standardUserDefaults().objectForKey("NC_K_AVATAR_LOCAL_NAME") as! String
            
            let img = UIImage(contentsOfFile: localFIleName)
            let data : NSData = UIImagePNGRepresentation(img)
            
            let boundary : String = "----WebKitFormBoundaryG0H9jTpjN7PtmaAh"
            let contentType : String = "multipart/form-data; boundary=" + boundary
            
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
            
            var body : NSMutableData = NSMutableData()
            // tm + uuid +sign
            var b : String = "--" + boundary + "\r\n"
            body.appendData(b.dataUsingEncoding(NSUTF8StringEncoding)!)
            b = "Content-Disposition: form-data; name=\"tm\"\r\n\r\n" + tm + "\r\n--" + boundary + "\r\n"
            body.appendData(b.dataUsingEncoding(NSUTF8StringEncoding)!)
            b = "Content-Disposition: form-data; name=\"uuid\"\r\n\r\n" + uuid + "\r\n--" + boundary + "\r\n"
            body.appendData(b.dataUsingEncoding(NSUTF8StringEncoding)!)
            b = "Content-Disposition: form-data; name=\"sign\"\r\n\r\n" + sign + "\r\n--" + boundary + "\r\n"
            body.appendData(b.dataUsingEncoding(NSUTF8StringEncoding)!)
            //image
            b = "Content-Disposition: form-data; name=\"image\"; filename=\"" + localFIleName + "\"\r\n" + "Content-Type: image/png\r\n\r\n"
            body.appendData(b.dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(data)
            b = "\r\n--" + boundary + "--\r\n"
            body.appendData(b.dataUsingEncoding(NSUTF8StringEncoding)!)

            
            request.HTTPBody = body
            
        default:
            break
        }
         //let postData = "tm=111&uuid=123&sign=1339ba084d895328187e53d1fe497d77&url=http://www.baidu.com"
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
            (response,data,error) in
            
            if (error != nil){
                println(error)
                
                NSNotificationCenter.defaultCenter().postNotificationName("requestERROR", object: self)
                self.alert(error.localizedDescription, button: "OK")
                self.status = RSatus.OK
                self.hasPendingReq = false
                return
                
            }
            let strdata = NSString(data: data, encoding: NSUTF8StringEncoding)!
            println(strdata)
            if let json:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary{
                println(strdata)
                println(json)
                println(json["code"])
                //NSString* encodedata = [[json objectForKey:@"data"] objectForKey:@"shortUrl"];
                if let code = json["code"] as? NSNumber{
                    //println("in")
                    if code != 0{
                        println("code error")
                        self.shortURL = ""
                    }
                    else{
                        if let data = json["data"] as? NSDictionary{
                            switch self.uploadType{
                                case "txt","url":
                                    if let url = data["shortUrl"] as? String{
                                        self.shortURL = self.baseURL+url
                                        NSNotificationCenter.defaultCenter().postNotificationName("didReceiveURL", object: self)
                                        println(self.shortURL)

                                    }
                                case "online_namecard":
                                    if let url = data["shortUrl"] as? String{
                                        self.shortURL = self.baseURL+url
                                        namecard.m_id = self.shortURL
                                        namecard.saveToDB()
                                        NSNotificationCenter.defaultCenter().postNotificationName("didReceiveURL", object: self)
                                        println(self.shortURL)

                                    }
                                case "image":
                                    if let url = data["image"] as? String{
                                        self.namecardAvatarURL = url
                                        NSUserDefaults.standardUserDefaults().setObject(url, forKey: "NC_K_AVATAR_URL")
                                    
                                    }
                                default:
                                    break;
                            }
                        }
                    }
                    
                    self.status = RSatus.OK
                    if(self.hasPendingReq){
                        self.hasPendingReq = false
                        self.sendRequest()
                    }
                }
            }
            else{
                NSNotificationCenter.defaultCenter().postNotificationName("requestERROR", object: self)
                
                self.alert("Unexpected Error", button: "OK")
                
                return
            }
        })
        if shortURL == ""{
            return false
        }
        else{
            return true
        }
        
    }
    
    class func url()->String{
        return RequestSender.shortURL;
    }
    class func imgurl()->String{
        return RequestSender.namecardAvatarURL;
    }
    
    class func alert(title:String,button:String){
        let alert = UIAlertView()
        alert.title = title
        alert.addButtonWithTitle(button)
        alert.show()
        return

    }
}
