//
//  setURLViewController.swift
//  vCode
//
//  Created by DarkTango on 5/15/15.
//  Copyright (c) 2015 ruitaocc. All rights reserved.
//

import UIKit
import MobileCoreServices

class setURLViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet var imgView:UIImageView!
    @IBOutlet var sender:UIButton!

    @IBOutlet var textInput:MadokaTextField!
    
    @IBOutlet var indicatorLabel:UILabel!
    
    @IBOutlet var notesLabel:UILabel!
    
    var m_btn_next:WZFlashButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sender.setTitle(NSLocalizedString("next_step", comment: ""), forState: UIControlState.Normal)
        
        textInput.borderColor = UIColor(red: 67.0/255.0, green:209.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        indicatorLabel.textAlignment = NSTextAlignment.Center
        indicatorLabel.numberOfLines = 2
        indicatorLabel.text = NSLocalizedString("url_indicator", comment: "")
        notesLabel.textAlignment = NSTextAlignment.Left
        notesLabel.numberOfLines = 4
        notesLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        notesLabel.text = NSLocalizedString("url_guide", comment: "")
        let sysFontSize = UIFont.systemFontSize()
        notesLabel.font = UIFont.systemFontOfSize(sysFontSize*0.9)
        notesLabel.textColor = UIColor.lightGrayColor()
        
        //
        let s_width = self.view.frame.size.width
        let s_height = self.view.frame.size.height
        let grid_size = s_width/10.0;
        m_btn_next = WZFlashButton()
        var btn_frame:CGRect = CGRect()
        btn_frame.size.width = s_width*0.6;
        btn_frame.size.height = 44;
        btn_frame.origin.x = (s_width-btn_frame.size.width)/2;
        btn_frame.origin.y = s_height-btn_frame.size.height - 64;
        m_btn_next.setText(NSLocalizedString("url_next_btn", comment: ""), withTextColor: UIColor.whiteColor())
        m_btn_next.resetFrame(btn_frame);
        m_btn_next.backgroundColor = UIColor(red: 67.0/255.0, green:209.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        m_btn_next.flashColor = UIColor.whiteColor()
        m_btn_next.textLabel.font  = UIFont.systemFontOfSize(sysFontSize*0.95)
        m_btn_next.setTextColor(UIColor.whiteColor())
        m_btn_next.layer.cornerRadius = 5;
        m_btn_next.clipsToBounds = true;
        //__weak typeof(self) weakSefl = self;
        m_btn_next.clickBlock = {
            self.next()
        }
        self.view.addSubview(m_btn_next)
        self.view.endEditing(true)
        
        self.title = NSLocalizedString("url_title", comment: "")

        
        self.navigationController?.setNavigationBarHidden(false, animated: true);
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func textFieldDidEnd(sender:AnyObject){
        sender.resignFirstResponder()
         //println(textField.text)
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        textInput.resignFirstResponder()
    }
    @IBAction func next(){
        if textInput.text == ""{
            let alert:UIAlertView = UIAlertView()
            alert.message = NSLocalizedString("no_input_text", comment: "")
            alert.addButtonWithTitle("ok")
            alert.show()
            return
        }
        saveToUserDefaults()
        RequestSender.sendRequest()
        println(RequestSender.shortURL)
        var cutview:CutViewController = CutViewController();
        cutview.haveDataToEncode = false;
        //self.presentViewController(finalview, animated: true, completion: nil)
        self.showViewController(cutview, sender: sender)
    }

    func saveToUserDefaults(){
        var ud = NSUserDefaults.standardUserDefaults()
        var url:NSString = textInput.text
        var final_URL:NSString = url
        if(url.length<7){
            final_URL = "http://" + (url as String)
        }else{
            var prefix :NSString = url.substringToIndex(7)
            if(!prefix.isEqualToString("http://") && !prefix.isEqualToString("ftp://")){
                final_URL = "http://" + (url as String)
            }
        }
        ud.setObject(final_URL, forKey: "url")
        ud.setObject("url", forKey: "uploadType")
        ud.synchronize()
        println(final_URL)
        println("saved complete!")
    }
}
