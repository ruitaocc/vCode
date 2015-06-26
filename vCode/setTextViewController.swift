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
    @IBOutlet var m_network_transform_label:UILabel!
    @IBOutlet var m_network_transform_switch:UISwitch!
    var m_is_network_translate:Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sender.setTitle(NSLocalizedString("next_step", comment: ""), forState: UIControlState.Normal);
        textInput.borderColor = UIColor(red: 67.0/255.0, green:209.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        indicatorLabel.textAlignment = NSTextAlignment.Center
        indicatorLabel.numberOfLines = 2
        indicatorLabel.text = NSLocalizedString("text_indicator", comment: "")
        
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
        m_btn_next.textLabel.font  = UIFont.systemFontOfSize(14)
        m_btn_next.setTextColor(UIColor.whiteColor())
        m_btn_next.layer.cornerRadius = 5;
        m_btn_next.clipsToBounds = true;
        //__weak typeof(self) weakSefl = self;
        m_btn_next.clickBlock = {
            self.nextStep()
        }
        self.view.addSubview(m_btn_next)
        
        //notes
        var textinputframe:CGRect = textInput.frame
        var label_frame:CGRect = CGRect()
        label_frame.size.width = s_width*0.8
        label_frame.size.height = 44*4
        label_frame.origin.x = s_width*0.1;
        label_frame.origin.y = ((btn_frame.origin.y - ( textinputframe.origin.y + textinputframe.size.height)) - label_frame.size.height)/2 + textinputframe.origin.y + textinputframe.size.height
        notesLabel.frame = label_frame
        notesLabel.textAlignment = NSTextAlignment.Left
        notesLabel.numberOfLines = 4
        notesLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        notesLabel.text = NSLocalizedString("text_guide", comment: "")
        notesLabel.font = UIFont.systemFontOfSize(14)
        notesLabel.textColor = UIColor.lightGrayColor()
        
        
        var inputFrame:CGRect = textInput.frame
        var switchFrame:CGRect = CGRect()
        switchFrame.size = CGSizeMake(51, 31)
        switchFrame.origin.y = inputFrame.origin.y + inputFrame.size.height + 10
        switchFrame.origin.x = inputFrame.origin.x + inputFrame.size.width - 51
        //m_network_transform_switch = UISwitch(frame: switchFrame)
        m_network_transform_switch.setOn(m_is_network_translate, animated: true)
        m_network_transform_switch.addTarget(self, action: "network_translate:", forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(m_network_transform_switch)
        
        switchFrame.size.width = inputFrame.size.width - 51
        switchFrame.origin.x = inputFrame.origin.x
        //m_network_transform_label = UILabel(frame: switchFrame)
        m_network_transform_label.text = NSLocalizedString("network_transform_label", comment: "")
        m_network_transform_label.font = UIFont.systemFontOfSize(14)
        m_network_transform_label.textAlignment = NSTextAlignment.Right
        m_network_transform_label.textColor = UIColor.grayColor()
        self.view.addSubview(m_network_transform_label)

        self.view.endEditing(true)
        
        self.title = NSLocalizedString("text_title", comment: "")
        self.navigationController?.setNavigationBarHidden(false, animated: true);
    }
    func network_translate(sender:UISwitch){
        m_is_network_translate = sender.on
        println(self.m_is_network_translate)
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        self.view.bringSubviewToFront(m_network_transform_switch)
        self.view.bringSubviewToFront(m_network_transform_label)
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
        if(m_is_network_translate){
            RequestSender.sendRequest()
        }
        self.performSegueWithIdentifier("setTextToCutView", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(m_is_network_translate){
            let receiver:UIViewController = segue.destinationViewController as! UIViewController
            if(receiver.respondsToSelector(Selector("setHaveDataToEncode:"))){
                let val:NSNumber = NSNumber(bool:false)
                receiver.setValue(val, forKey: "haveDataToEncode")
            }
        }else{
            let receiver:UIViewController = segue.destinationViewController as! UIViewController
            if(receiver.respondsToSelector(Selector("setHaveDataToEncode:"))){
                let val:NSNumber = NSNumber(bool:true)
                receiver.setValue(val, forKey: "haveDataToEncode")
            }
            if(receiver.respondsToSelector(Selector("setDataToEncode:"))){
                receiver.setValue(textInput.text, forKey: "dataToEncode")
            }
        }
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
