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
    @IBOutlet var sender:UIButton!
    @IBOutlet var textInput:MadokaTextField!
    @IBOutlet var indicatorLabel:UILabel!
    
    @IBOutlet var notesLabel:UILabel!
    
    var m_btn_next:WZFlashButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sender.setTitle(NSLocalizedString("next_step", comment: ""), forState: UIControlState.Normal);
        textInput.borderColor = UIColor(red: 67.0/255.0, green:209.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        indicatorLabel.textAlignment = NSTextAlignment.Center
        indicatorLabel.numberOfLines = 2
        indicatorLabel.text = NSLocalizedString("text_indicator", comment: "")
        notesLabel.textAlignment = NSTextAlignment.Left
        notesLabel.numberOfLines = 4
        notesLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        notesLabel.text = NSLocalizedString("text_guide", comment: "")
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
        m_btn_next.setText(NSLocalizedString("text_next_btn", comment: ""), withTextColor: UIColor.whiteColor())
        m_btn_next.resetFrame(btn_frame);
        m_btn_next.backgroundColor = UIColor(red: 67.0/255.0, green:209.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        m_btn_next.flashColor = UIColor.whiteColor()
        m_btn_next.textLabel.font  = UIFont.systemFontOfSize(sysFontSize*0.95)
        m_btn_next.setTextColor(UIColor.whiteColor())
        //__weak typeof(self) weakSefl = self;
        m_btn_next.clickBlock = {
            self.nextStep()
        }
        self.view.addSubview(m_btn_next)
        self.view.endEditing(true)
        
        self.title = NSLocalizedString("text_title", comment: "")
        self.navigationController?.setNavigationBarHidden(false, animated: true);
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true);
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        textInput.resignFirstResponder()
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

        if self.textInput.text == ""{
            let alert:UIAlertView = UIAlertView()
            alert.message = NSLocalizedString("noinputtext", comment: "")
            alert.addButtonWithTitle("ok")
            alert.show()
            return
        }
        saveToUserDefaults()
        //RequestSender.sendRequest()
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
        cutview.dataToEncode = textInput.text;
        //self.presentViewController(finalview, animated: true, completion: nil)
        self.showViewController(cutview, sender: sender)
    }

    func saveToUserDefaults(){
        var ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(textInput.text, forKey: "text")
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
