//
//  OnlineNameCardController.m
//  vCode
//
//  Created by ruitaocc on 15/6/7.
//  Copyright (c) 2015年 ruitaocc. All rights reserved.
//

#import "OnlineNameCardController.h"
#import "vCode-swift.h"
@implementation OnlineNameCardController

-(void)viewDidLoad{
    
    CGRect f = [[self.tableView tableHeaderView] frame];
    f.size.height = 0;
    [[self.tableView tableHeaderView]setFrame:f];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0;
};
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0;
};

@end
