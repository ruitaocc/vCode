//
//  QRCodeViewController.swift
//  vCode
//
//  Created by DarkTango on 5/15/15.
//  Copyright (c) 2015 ruitaocc. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

class QRCodeViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
     var label:UILabel!
     var noteLabel:UILabel!
    @IBOutlet var nextstep:UIButton!
    
    var str_label:String = ""
    var str_noteLable:String = ""
    
    var m_btn_Scan:WZFlashButton!
    var m_btn_Album:WZFlashButton!
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var qrcodeimg:UIImage?
    var stringInQRCode:String = ""
    var setted:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        nextstep.setTitle(NSLocalizedString("next_step", comment: ""), forState: UIControlState.Normal)
        //
        
        let s_width = self.view.frame.size.width
        let s_height = self.view.frame.size.height
        let grid_size = s_width/10.0;
        
        
        //Scan
        m_btn_Album = WZFlashButton()
        m_btn_Scan = WZFlashButton()
        var btn_frame:CGRect = CGRect()
        btn_frame.size.width = grid_size*3;
        btn_frame.size.height = grid_size*2;
        btn_frame.origin.x = grid_size*1.5;
        btn_frame.origin.y = (s_height-btn_frame.size.height)/2;
        m_btn_Scan.setText(NSLocalizedString("scan_qr_code", comment: ""), withTextColor: UIColor.whiteColor())
        m_btn_Scan.resetFrame(btn_frame);
        m_btn_Scan.backgroundColor = UIColor(red: 67.0/255.0, green:209.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        m_btn_Scan.flashColor = UIColor.whiteColor()
        m_btn_Scan.setTextColor(UIColor.whiteColor())
        //__weak typeof(self) weakSefl = self;
        m_btn_Scan.clickBlock = {
            self.beginCapture()
        }
        
        //Choose form album
        btn_frame.size.width = grid_size*3;
        btn_frame.size.height = grid_size*2;
        btn_frame.origin.x = grid_size*5.5;
        btn_frame.origin.y = (s_height-btn_frame.size.height)/2;
        m_btn_Album.setText(NSLocalizedString("album_qr_code", comment: ""), withTextColor: UIColor.whiteColor())
        m_btn_Album.resetFrame(btn_frame);
        m_btn_Album.backgroundColor = UIColor(red: 67.0/255.0, green:209.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        m_btn_Album.flashColor = UIColor.whiteColor()
        m_btn_Album.setTextColor(UIColor.whiteColor())
        //__weak typeof(self) weakSefl = self;
        m_btn_Album.clickBlock = {
            self.readFromImage()
        }
        
        
        //lable
        label = UILabel()
        var label_frame:CGRect = CGRect()
        label_frame.size.width = s_width
        label_frame.size.height = 44
        label_frame.origin.x = 0;
        label_frame.origin.y = btn_frame.origin.y - 44 - btn_frame.size.height*0.5
        label.frame = label_frame
        label.textAlignment = NSTextAlignment.Center
        label.numberOfLines = 5
        label.text = str_label
        
        //notes
        noteLabel = UILabel()
        label_frame.size.width = s_width*0.8
        label_frame.size.height = 44*4
        label_frame.origin.x = s_width*0.1;
        label_frame.origin.y = btn_frame.origin.y + btn_frame.size.height*1.5
        noteLabel.frame = label_frame
        noteLabel.textAlignment = NSTextAlignment.Left
        //noteLabel.lineBreakMode = NSLineBreakMode.ByCharWrapping
        noteLabel.numberOfLines = 5
        noteLabel.text = str_noteLable
        let fontsize = UIFont.systemFontSize()
        noteLabel.font = UIFont.systemFontOfSize(fontsize*0.9)
        noteLabel.textColor = UIColor.lightGrayColor()
        
        self.view.addSubview(label)
        self.view.addSubview(noteLabel)
        self.view.addSubview(m_btn_Scan)
        self.view.addSubview(m_btn_Album)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true);
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true);
    }

    @IBAction func beginCapture(){
        stringInQRCode = ""
        beginCaptureSession()
    }
    
    @IBAction func readFromImage(){
        choose()
    }
    @IBAction func next(){
        if !setted{
            let alert:UIAlertView = UIAlertView()
            alert.message = "please scan QR code!"
            alert.addButtonWithTitle("OK")
            alert.show()
            return
        }
        let cutview = CutViewController()
        cutview.haveDataToEncode = true
        cutview.dataToEncode = stringInQRCode
        self.showViewController(cutview, sender: nextstep);
    }
    func choose(){
        setted = false
        stringInQRCode = ""
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            var picker:UIImagePickerController = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            picker.mediaTypes = [kUTTypeImage]
            picker.allowsEditing = false
            self.presentViewController(picker, animated: true, completion: nil)
        }
    }
    func beginCaptureSession(){
        setted = false
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        var error:NSError?
        let input:AnyObject! = AVCaptureDeviceInput.deviceInputWithDevice(captureDevice, error: &error)
        
        if(error != nil){
            println("\(error?.localizedDescription)")
            return
        }
        captureSession = AVCaptureSession()
        captureSession?.addInput(input as! AVCaptureInput)

        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer)
        view.bringSubviewToFront(label)
        captureSession?.startRunning()
        
        
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubviewToFront(qrCodeFrameView!)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0{
            qrCodeFrameView?.frame = CGRectZero
            label.text = "No QR code is detected!"
            return
        }
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode{
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds
            if metadataObj.stringValue != nil{
                setted = true
                label.text = metadataObj.stringValue
                stringInQRCode = label.text!
                RequestSender.shortURL = label.text!
                captureSession?.stopRunning()
                videoPreviewLayer?.removeFromSuperlayer()
                qrCodeFrameView?.removeFromSuperview()
                
            }
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        
        if let str = QRDetector.decodeQRwithImg(image){
            stringInQRCode = str
        }
        if stringInQRCode != "" {
            setted = true
            label.text = stringInQRCode
            println(stringInQRCode)
        }
        else{
            let alertview = UIAlertView()
            alertview.message = "No QR Code detect!"
            alertview.addButtonWithTitle("OK")
            alertview.show()
        }
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
