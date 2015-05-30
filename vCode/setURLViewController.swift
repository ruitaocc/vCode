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
    @IBOutlet var textField:UITextField!
    @IBOutlet var sender:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sender.setTitle(NSLocalizedString("next_step", comment: ""), forState: UIControlState.Normal)
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
    
    @IBAction func next(){
        if textField.text == ""{
            let alert:UIAlertView = UIAlertView()
            alert.message = "no input text!"
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
        ud.setObject("http://"+textField.text, forKey: "url")
        ud.setObject("url", forKey: "uploadType")
        ud.synchronize()
        println("saved complete!")
    }
}
