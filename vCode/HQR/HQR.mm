//
//  HQR.m
//  vCode
//
//  Created by ruitaocc on 15/4/20.
//  Copyright (c) 2015年 ruitaocc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HQR.h"
#import <opencv2/highgui/highgui_c.h>
#import "../../Pods/Headers/Public/ZXingObjC/ZXLuminanceSource.h"

#import "../../Pods/Headers/Public/ZXingObjC/ZXingObjC.h"
@interface HQR (){
    int _qr_point;
    int _h_qr_point;
}

@property(nonatomic,assign)int casesensitive;
@property(nonatomic,assign)int eightbit;
@property(nonatomic,assign)int size;
//@property(nonatomic,assign)int qr_point;
//@property(nonatomic,assign)int h_qr_point;
@property(nonatomic,assign)int margin;
@property(nonatomic,assign)int dpi;
@property(nonatomic,assign)int structured;
@property(nonatomic,assign)int micro;
@property(nonatomic,assign)int padding;
@property(nonatomic,assign)QRencodeMode hint;
@property(nonatomic,assign)imageType image_type;
-(QRcode*) encode:(const unsigned char *)intext length:(int)length maskImage:(int *)maskImg ;
-(UIImage *)UIImageFromIplImage:(IplImage *)image;
-(UIImage *)UIImageFromMat:(cv::Mat)aMat;
-(IplImage *)CreateIplImageFromUIImage:(UIImage *)image;

@end




void addAlignMentPatterm_gray(IplImage * img,IplImage * Qr,QRcode *qrcode,int size);//ij is the center of the alignmentpatterm
void addAlignMentPatterm_color(IplImage * img,IplImage * Qr,QRcode *qrcode,int size);//ij is the center of the alignmentpatterm
void projectPointFormQR_gray(IplImage * img,IplImage * Qr,int i,int j,int size);//QRcode to HalftoneImage
void projectPointFormQR_color(IplImage * img,IplImage * Qr,int i,int j,int size);//QRcode HalftoneImage

void convertToBits( QRcode * qrcode,int *A,const char* filename );//int

@implementation HQR
@synthesize version = _version;//qr code version
@synthesize  level=_level;//error correction level
@synthesize  casesensitive = _casesensitive;
@synthesize  eightbit = _eightbit;
@synthesize  size = _size;
//@synthesize  qr_point = _qr_point;
//@synthesize  h_qr_point = _h_qr_point;
@synthesize margin = _margin;
@synthesize dpi = _dpi;
@synthesize structured =_structured;
@synthesize micro =_micro;
@synthesize padding =_padding;
@synthesize hint = _hint;
@synthesize  image_type = _image_type;
+(HQR*)getInstance{
    
    static HQR* instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^(void){
        if(instance==nil){
            instance = [[self alloc] init];
        }
    });
    return instance;
};
-(id)init{
    if(self = [super init]){
        _version = 5;
        _level = QR_ECLEVEL_H;
        
        _casesensitive = 1;
        _eightbit = 0;
        _size = 3;
        _qr_point = (_version-1)*4+21;
        _h_qr_point = _qr_point*_size;
        _margin = -1;
        _dpi = 72;
        _structured = 0;
        _micro = 0;
        _padding = 3;
        _hint = QR_MODE_8;
    }
    return self;
}
-(void)setSize:(int)size{
    _size = size;
    _qr_point = (_version-1)*4+21;
    _h_qr_point = _qr_point*_size;
}
-(void)setVersion:(int)version{
    _version = version;
    _qr_point = (_version-1)*4+21;
    _h_qr_point = _qr_point*_size;
}
-(bool)setThreshold_PaddingArea:(float)parea nodePaddingArea:(float)nparea GuideRatio:(float)guideRatio{
    if(parea<0.0||parea>127.5){
        return true;
    }
    if(nparea<0.0||nparea>127.5){
        return true;
    }
    if(guideRatio<0.0||guideRatio>1.0){
        return true;
    }
    GUIDE_RATIO = guideRatio;
    MODIFY_THRESHOLD_PADDING_AREA = parea;
    MODIFY_THRESHOLD_NONE_PADDING_AREA = nparea;
    return true;
};

-(NSString *)decodeQRwithImg:(UIImage *)img{
    if (img==nil) {
        return nil;
    }
    CGImageRef imageToDecode=img.CGImage;// Given a CGImage in which we are looking for barcodes
    
    ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode];
    ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
    
    NSError *error = nil;
    
    // There are a number of hints we can give to the reader, including
    // possible formats, allowed lengths, and the string encoding.
    ZXDecodeHints *hints = [ZXDecodeHints hints];
    
    ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
    ZXResult *result = [reader decode:bitmap
                                hints:hints
                                error:&error];
    if (result) {
        // The coded result as a string. The raw data can be accessed with
        // result.rawBytes and result.length.
        NSString *contents = result.text;
        
        // The barcode format, such as a QR code or UPC-A
        ZXBarcodeFormat format = result.barcodeFormat;
        if(format==ZXBarcodeFormat::kBarcodeFormatQRCode){
            return contents;
        }
    } else {
        // Use error to determine why we didn't get a result, such as a barcode
        // not being found, an invalid checksum, or a format inconsistency.
        
    }
    return  nil;
};
-(UIImage *)generateQRwithImg:(UIImage *)img text:(NSString *)str isGray:(BOOL)isgray{
    cout<<"start"<<endl;
    //string *inputfilepath = new string(inputfile);
    //string *outputfilepath = new string(outputfile);
    
    int * maskImage = new int[_qr_point*_qr_point];
    int * paddingArea = new int[_qr_point*_qr_point];
    //int * bits = new int[((_qr_point+31)/32)*_qr_point];//
    
    IplImage *I_gray;
    IplImage *I_color;
    IplImage *Ih_gray;//qr_guide_halftone
    IplImage *Ih_color;//qr_guide_halftone
    //IplImage *Iqr_gray;//halftone-qr-with-ditector
    IplImage *Iqr_color;//halftone-qr-with-ditector
    
    //
    IplImage * color_original  = [self CreateIplImageFromUIImage:img];
    //gray
    //cvCvtColor(fromUiimage, color_original, CV_BGR2GRAY);
    IplImage *color_resized = cvCreateImage(cvSize(_h_qr_point, _h_qr_point), color_original->depth, color_original->nChannels);
    cvResize(color_original, color_resized);
    
    IplImage *gray_original = cvCreateImage(cvSize(color_original->width, color_original->height), color_original->depth, 1);
    cvCvtColor(color_original, gray_original, CV_BGR2GRAY);
    
    IplImage *gray_resized = cvCreateImage(cvSize(_h_qr_point, _h_qr_point), IPL_DEPTH_8U, gray_original->nChannels);
    cvResize(gray_original, gray_resized);
    I_gray = gray_resized;
    DitheringHalftone(I_gray,maskImage);//
    memcpy(paddingArea,maskImage,sizeof(int)*_qr_point*_qr_point);//
    
    cout<<"pos1"<<endl;
    
    QRcode *qrcode;
    IplImage *Qr;//qr-code
    unsigned char *intext =(unsigned char *)[str cStringUsingEncoding:NSUTF8StringEncoding];
    
    int length = 0;
    length = (int)strlen((char *)intext);
#if USE_PADDING_EREA
    qrcode = [self encode:intext length:length maskImage:paddingArea];
#else
    qrcode = [self encode:intext length:length maskImage:NULL];
#endif
    int width = qrcode->width;
    unsigned char * p = qrcode->data;
    
    IplImage *img_qr = cvCreateImage(cvSize(_h_qr_point, _h_qr_point), IPL_DEPTH_64F, 1);
    Qr = img_qr;
    cvZero(Qr);
    cvSet(Qr,cvScalar(255));
    
    //convertToBits(qrcode , bits,output_data_path->c_str());
    for(int i = 0; i< width; i++){
        for(int j = 0; j< width; j++){
            if(*(p+i*width+j)%2==1){
                for(int k = 0; k<_size; k++){
                    for(int h = 0; h<_size; h++){
                        cvSet2D(Qr, i*_size+k, j*_size+h, cvScalar(0));
                    }
                }
            }else{
                for(int k = 0; k<_size; k++){
                    for(int h = 0; h<_size; h++){
                        cvSet2D(Qr, i*_size+k, j*_size+h, cvScalar(255));
                    }
                }
            }
        }
    }
    I_color = color_resized;
    cout<<"gray qr generated"<<endl;
    
    // Ih = QR_Guide_OstromoukhovHalftone(I,Qr);
    Ih_gray = Qr_Guide_Laplace_SAED_Halftone_gray(I_gray,Qr);
    cout<<"gray halftone generated"<<endl;
    //Ih_color = Qr_Guide_Laplace_SAED_Halftone_color(I_color,I_gray,Qr);
    Ih_color = Qr_Guide_Laplace_SAED_Halftone_color_paddingdata(I_color,I_gray,Qr,paddingArea,_size);
    cout<<"half tone img generated"<<endl;
    
    //Iqr_gray = cvCloneImage(Ih_gray);
    Iqr_color = cvCloneImage(Ih_color);
#if OTHER_INFO
   // 	addAlignMentPatterm_gray(Iqr_gray,Qr,qrcode,_size);
    addAlignMentPatterm_color(Iqr_color,Qr,qrcode,_size);
#endif
    cout<<"saving"<<endl;
    IplImage *img_color_3 = cvCreateImage(cvSize(Iqr_color->width * 3 , Iqr_color->height * 3 ), Iqr_color->depth, Iqr_color->nChannels);
    cvResize(Iqr_color, img_color_3, CV_INTER_NN);
    
    IplImage *img_color_3_margin = cvCreateImage(cvSize(Iqr_color->width * 3 + 24, Iqr_color->height * 3 + 24), Iqr_color->depth, Iqr_color->nChannels);
    IplImage i;
    //cv::Mat m(i.imageData);
    //cv::Mat img_color_mat(Iqr_color);66
    cv::Mat img_color_mat(Iqr_color->width,Iqr_color->height,CV_8UC3,Iqr_color->imageData,Iqr_color->widthStep);
    //cv::Mat img_color_3_mat(img_color_3);
    cv::Mat img_color_3_mat(img_color_3->width,img_color_3->height,CV_8UC3,img_color_3->imageData,img_color_3->widthStep);
    
    //cv::Mat img_color_3_margin_mat(img_color_3_margin);
    cv::Mat img_color_3_margin_mat(img_color_3_margin->width,img_color_3_margin->height,CV_8UC3,img_color_3_margin->imageData,img_color_3_margin->widthStep);
    img_color_3_margin_mat.setTo(255);
    cv::Mat imageROI_color;
    imageROI_color = img_color_3_margin_mat(cv::Rect(12, 12, img_color_mat.cols * 3, img_color_mat.rows*3));
    img_color_3_mat.copyTo(imageROI_color);
    IplImage color_3_margin = img_color_3_margin_mat;
    img_color_3_margin = (IplImage*)(&color_3_margin);
    //cvSaveImage(outputfilepath->c_str(), img_color_3_margin);
    cout<<"saved img"<<endl;
    //  cvReleaseImage(&Iqr);
    // cvReleaseImage(&fimg2);
    // cvReleaseImage(&img8bit3);    
    
    cout<<"finish"<<endl;
   // delete [] maskImage; maskImage = NULL;
    //delete [] bits; bits = NULL;
    //return [self UIImageFromMat:img_color_mat];
    return [self UIImageFromIplImage:img_color_3_margin];
    

    // return [self UIImageFromMat:img_color_3_margin_mat];
}

-(QRcode*) encode:(const unsigned char *)intext length:(int)length maskImage:(int *)maskImg {
    QRcode *code;
    
    if(_micro) {
        if(_eightbit) {
            code = QRcode_encodeDataMQR(length, intext, _version, _level);
        } else {
            code = QRcode_encodeStringMQR((char *)intext, _version, _level, _hint, _casesensitive);
        }
    } else {
        if(_eightbit) {
            code = QRcode_encodeData(length, intext, _version, _level);
        } else {
            code = QRcode_encodeString((char *)intext, _version, _level, _hint, _casesensitive, maskImg);//use
        }
    }
    
  
    return code;
}
- (IplImage *)CreateIplImageFromUIImage:(UIImage *)image {
    // Getting CGImage from UIImage
    CGImageRef imageRef = image.CGImage;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // Creating temporal IplImage for drawing
    IplImage *iplimage = cvCreateImage(
                                       cvSize(image.size.width,image.size.height), IPL_DEPTH_8U, 4
                                       );
    // Creating CGContext for temporal IplImage
    CGContextRef contextRef = CGBitmapContextCreate(
                                                    iplimage->imageData, iplimage->width, iplimage->height,
                                                    iplimage->depth, iplimage->widthStep,
                                                    colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault
                                                    );
    // Drawing CGImage to CGContext
    CGContextDrawImage(
                       contextRef,
                       CGRectMake(0, 0, image.size.width, image.size.height),
                       imageRef
                       );
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    
    NSLog(@"image->width = %d" , iplimage->width);
    NSLog(@"image->height = %d" , iplimage->height);
    
    // Creating result IplImage
    IplImage *ret = cvCreateImage(cvGetSize(iplimage), IPL_DEPTH_8U, 3);
    cvCvtColor(iplimage, ret, CV_RGBA2BGR);
    cvReleaseImage(&iplimage);
    
    
    
    return ret;
}

-(UIImage *)UIImageFromIplImage:(IplImage *)image {
    NSLog(@"IplImage (%d, %d) %d bits by %d channels, %d bytes/row %s",
          image->width,
          image->height,
          image->depth,
          image->nChannels,
          image->widthStep,
          image->channelSeq);
    cvCvtColor(image, image, CV_BGR2RGB);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSData *data = [NSData dataWithBytes:image->imageData length:image->imageSize];
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)data);
    CGImageRef imageRef = CGImageCreate(image->width,
                                        image->height,
                                        image->depth,
                                        image->depth * image->nChannels,
                                        image->widthStep,
                                        colorSpace,
                                        kCGImageAlphaNone |
                                        kCGBitmapByteOrderDefault,
                                        provider,
                                        NULL,
                                        false,
                                        kCGRenderingIntentDefault);
    
    UIImage *ret = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return ret;
}
-(UIImage *)UIImageFromMat:(cv::Mat)aMat
{
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    unsigned char* data = new unsigned char[4*aMat.cols * aMat.rows];
    for (int y = 0; y < aMat.rows; ++y)
    {
        cv::Vec3b *ptr = aMat.ptr<cv::Vec3b>(y);
        unsigned char *pdata = data + 4*y*aMat.cols;
        
        for (int x = 0; x < aMat.cols; ++x, ++ptr)
        {
            *pdata++ = (*ptr)[2];
            *pdata++ = (*ptr)[1];
            *pdata++ = (*ptr)[0];
            *pdata++ = 0;
        }
    }
    
    // Bitmap context
    CGContextRef context = CGBitmapContextCreate(data, aMat.cols, aMat.rows, 8, 4*aMat.cols, colorSpace, kCGImageAlphaNoneSkipLast);
    
    
    
    CGImageRef cgimage = CGBitmapContextCreateImage(context);
    
    UIImage *ret = [UIImage imageWithCGImage:cgimage scale:1.0
                                 orientation:UIImageOrientationUp];
    
    CGImageRelease(cgimage);
    
    CGContextRelease(context);  
    
    // CGDataProviderRelease(provider);
    
    CGColorSpaceRelease(colorSpace);
    
    
    return ret;
}

@end

void projectPointFormQR_gray(IplImage * img,IplImage * Qr,int i,int j,int size){
    bool iswirte = cvGet2D(Qr,i*size+1,j*size+1).val[0]>0.1;
    float scalar = 0;
    if(iswirte)scalar = 255.0;
    for(int k = 0; k<size;k++){
        for(int h = 0; h<size;h++){
            cvSet2D(img, i*size+k, j*size+h, cvScalar(scalar));
        }
    }
};
void projectPointFormQR_color(IplImage * img,IplImage * Qr,int i,int j,int size){
    bool iswirte = cvGet2D(Qr,i*size+1,j*size+1).val[0]>0.1;
    float scalar = 0;
    if(iswirte)scalar = 255.0;
    for(int k = 0; k<size;k++){
        for(int h = 0; h<size;h++){
            cvSet2D(img, i*size+k, j*size+h, cvScalar(scalar,scalar,scalar));
        }
    }
};


void addAlignMentPatterm_gray(IplImage * img,IplImage * Qr,QRcode * qrcode,int size){
    int width = qrcode->width;
    unsigned char * p = qrcode->data;
    for(int i = 0; i< width; i++){
        for(int j = 0; j< width; j++){
            //>>7 see QRcode class
            if(((*(p+i*width+j))>>7)%2==1)projectPointFormQR_gray(img,Qr,i,j,size);
        }
    }
};
void addAlignMentPatterm_color(IplImage * img,IplImage * Qr,QRcode * qrcode,int size){
    int width = qrcode->width;
    unsigned char * p = qrcode->data;
    for(int i = 0; i< width; i++){
        for(int j = 0; j< width; j++){
            //>>7 see QRcode class
            if(((*(p+i*width+j))>>7)%2==1)projectPointFormQR_color(img,Qr,i,j,size);
        }
    }
};

void convertToBits( QRcode * qrcode,int *A,const char* filename){
    unsigned char *p = qrcode->data;
    int width = qrcode->width;
    int asize = ((width+31)/32)*width;
    memset(A,0,sizeof(int)*asize);
    for(int i = 0; i< width; i++){
        for(int j = 0; j< width; j++){
            if(*(p+i*width+j)%2==1){
                int index = i*2 +j/32;
                A[index]=A[index] | (0x01<<(j%32));
            }else{
                //	
            }
        }
    }
    fstream file;
    file.open(filename,ios::out);
    for(int i = 0;i<asize ;i++){
        file<<A[i]<<endl;
    }
    file.close();
    
}