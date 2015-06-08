//
//  OnlineNameCardController.m
//  vCode
//
//  Created by ruitaocc on 15/6/7.
//  Copyright (c) 2015年 ruitaocc. All rights reserved.
//

#import "OnlineNameCardController.h"
#import "vCode-swift.h"
#import "WZFlashButton.h"
@interface OnlineNameCardController()
@end

@implementation OnlineNameCardController
@synthesize m_gebtn;
-(void)viewDidLoad{
    [self setTitle:NSLocalizedString(@"OnlineNameCardTittle", nil) ];
    //UITableViewCell* lastCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:10 inSection:0]];
    float s_width = self.view.frame.size.width;;
    CGRect btn_frame;
    btn_frame.size.width = 0.57*s_width;
    btn_frame.size.height = 44;
    btn_frame.origin.x = (s_width-btn_frame.size.width)/2;
    btn_frame.origin.y = (84-btn_frame.size.height)/2;
    //__weak __typeof(self) weakSelf = self;
    //m_gebtn = [[WZFlashButton alloc]initWithFrame:btn_frame ];
    [m_gebtn resetFrame:btn_frame];
    m_gebtn.backgroundColor = [UIColor colorWithRed:67.0/255.0f green:209.0f/255.0f blue:250.0/255.0 alpha:1.0f];
    m_gebtn.flashColor = [UIColor whiteColor];
    [m_gebtn setText:NSLocalizedString(@"ol_generate", nil) withTextColor:[UIColor whiteColor]];
    [m_gebtn setTextColor:[UIColor whiteColor]];
    m_gebtn.clickBlock = ^(void){
        //[weakSelf performSegueWithIdentifier:@"HomeToURL" sender:weakSelf];
        NSLog(@"generate call");
    };
    NSLog(@"tableview loaded");
   // [lastCell addSubview:m_generate_btn];

}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0;
};
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0;
};
@end
