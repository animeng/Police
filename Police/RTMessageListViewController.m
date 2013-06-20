//
//  RTMessageListViewController.m
//  Police
//
//  Created by wang animeng on 13-6-4.
//  Copyright (c) 2013年 realtech. All rights reserved.
//

#import "RTMessageListViewController.h"
#import "RTMessageAdapter.h"
#import "RTMessageCell.h"

@interface RTMessageListViewController ()

@end

@implementation RTMessageListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.noMessageTips = @"附近没有条子的警告消息哦！！！";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listDatas count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RTMessageAdapter *adapter = [self.listDatas objectAtIndex:indexPath.row];
    return [RTMessageCell heightOfCell:adapter];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"JMHouseListCell";
    RTMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[RTMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    RTMessageAdapter *adapter = [self.listDatas objectAtIndex:indexPath.row];
    [cell setContent:adapter];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.messageDelegate respondsToSelector:@selector(selectMessageList:)]) {
        [self.messageDelegate selectMessageList:indexPath.row];
    }
}

@end
