//
//  HistoryViewController.m
//  vCode
//
//  Created by ruitaocc on 15/6/6.
//  Copyright (c) 2015年 ruitaocc. All rights reserved.
//

#import "HistoryViewController.h"
#import "DateHelper.h"
@interface HistoryViewController()
@property(strong,nonatomic)NSMutableArray* m_historyAry;
@property(assign,nonatomic)int m_selected_index;
@end
@implementation HistoryViewController
@synthesize m_historyAry;
@synthesize m_selected_index;
-(void)viewDidLoad{
     m_historyAry = [HistoryEntry getAllHistory];
    [self setTitle :NSLocalizedString(@"history", nil)];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *receiver = segue.destinationViewController;
    if([receiver respondsToSelector:@selector(setItem:)]){
        [receiver setValue:[m_historyAry objectAtIndex:m_selected_index]forKey:@"item"];
    }
}

#pragma mark - UItableviewDataSourece
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [HistoryEntry rowCountWithWhere:nil];
};

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    static NSString *reuseIdetify = @"HistoryTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.showsReorderControl = YES;
        
    }
    cell.textLabel.backgroundColor = [UIColor clearColor];
    NSInteger index = [m_historyAry count]-indexPath.row-1;
    NSString *str = [(HistoryEntry*)[m_historyAry objectAtIndex:index]m_time];
    NSDate *date = [DateHelper dateFromString:str withFormat:@"yyyy_MM_dd_HH_mm_ss"];
    NSString *time =[DateHelper stringFromDate:date withFormat:@"yyyy-MM-dd HH:mm:ss"];
    cell.textLabel.text =time;
    return cell;
};


#pragma mark -UITableviewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    m_selected_index =(int)([m_historyAry count]-indexPath.row-1);
    [self performSegueWithIdentifier:@"History2Detail" sender:self];
};


@end
