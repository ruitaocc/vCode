//
//  CutViewController.h
//  
//
//  Created by DarkTango on 5/28/15.
//
//

#import <UIKit/UIKit.h>
#import "InfiniTabBar.h"
@interface CutViewController : UIViewController
@property BOOL haveDataToEncode;
@property NSString* dataToEncode;
@property (nonatomic,assign)BOOL hasImage;
@property (nonatomic,strong)UIImage * preAvatar;
@end
