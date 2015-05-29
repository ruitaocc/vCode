//
//  setTextViewController.swift
//  vCode
//
//  Created by DarkTango on 5/11/15.
//  Copyright (c) 2015 ruitaocc. All rights reserved.
//

import UIKit
import MobileCoreServices
class setTextViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    @IBOutlet var imgView:UIImageView!
    @IBOutlet var textField:UITextField!
    @IBOutlet var sender:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sender.setTitle(NSLocalizedString("next_step", comment: ""), forState: UIControlState.Normal);
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func textFieldDidEnd(sender:AnyObject){
        sender.resignFirstResponder()
       // println(textField.text)
    }

    @IBAction func nextStep(){

        if textField.text == ""{
            let alert:UIAlertView = UIAlertView()
            alert.message = NSLocalizedString("noinputtext", comment: "")
            alert.addButtonWithTitle("ok")
            alert.show()
            return
        }
        saveToUserDefaults()
        RequestSender.sendRequest()
        println(RequestSender.shortURL)
        /*if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            var picker:UIImagePickerController = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            picker.mediaTypes = [kUTTypeImage]
            picker.allowsEditing = false
            
            self.presentViewController(picker, animated: true, completion: nil)
            
        }*/
        var cutview:CutViewController = CutViewController()
        cutview.haveDataToEncode = true;
        cutview.dataToEncode = textField.text;
        //self.presentViewController(finalview, animated: true, completion: nil)
        self.showViewController(cutview, sender: sender)
    }

    func saveToUserDefaults(){
        var ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(textField.text, forKey: "text")
        ud.setObject("txt", forKey: "uploadType")
        ud.synchronize()
        println("saved complete!")
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imgView.image = image
        NSUserDefaults.standardUserDefaults().setObject(UIImagePNGRepresentation(imgView.image), forKey: "originImg")
        println("image choosen.")
        self.dismissViewControllerAnimated(true, completion: nil)
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
