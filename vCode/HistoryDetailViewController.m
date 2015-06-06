
//
//  HistoryDetailViewController.m
//  vCode
//
//  Created by ruitaocc on 15/6/6.
//  Copyright (c) 2015年 ruitaocc. All rights reserved.
//

#import "HistoryDetailViewController.h"

@implementation HistoryDetailViewController
@synthesize item;

-(void)viewDidLoad{
    [self setTitle:NSLocalizedString(@"historyDetail", nil)];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 400)];
    [lable setLineBreakMode:NSLineBreakByWordWrapping];
    [lable setNumberOfLines:4];
    [lable setTextColor:[UIColor blackColor]];
    [lable setText:[item  m_time]];
    [self.view addSubview:lable];
}

@end
