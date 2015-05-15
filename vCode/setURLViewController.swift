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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func textFieldDidEnd(sender:AnyObject){
        sender.resignFirstResponder()
         //println(textField.text)
    }
    
    @IBAction func chooseImg(){
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
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            var picker:UIImagePickerController = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            picker.mediaTypes = [kUTTypeImage]
            picker.allowsEditing = false
            
            self.presentViewController(picker, animated: true, completion: nil)
            
        }
    }
    @IBAction func send(){
        var finalview:FinalViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FinalViewController") as! FinalViewController
        //self.presentViewController(finalview, animated: true, completion: nil)
        self.showViewController(finalview, sender: sender)
    }
    func saveToUserDefaults(){
        var ud = NSUserDefaults.standardUserDefaults()
        ud.setObject("http://"+textField.text, forKey: "url")
        ud.setObject("url", forKey: "uploadType")
        ud.synchronize()
        println("saved complete!")
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imgView.image = image
        NSUserDefaults.standardUserDefaults().setObject(UIImagePNGRepresentation(imgView.image), forKey: "originImg")
        println("image choosen.")
        send()
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
