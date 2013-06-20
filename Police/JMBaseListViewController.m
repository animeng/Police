//
//  JMBaseListViewController.m
//  SaleHouse
//
//  Created by wang animeng on 13-4-23.
//  Copyright (c) 2013年 jam. All rights reserved.
//

#import "JMBaseListViewController.h"
#import "BaseCell.h"

@interface JMBaseListViewController ()

@property (nonatomic,strong) UILabel *tipLabel;

@end

@implementation JMBaseListViewController

#pragma mark - viewController lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self setupTableView];
    [self setupTipsMessageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - setup view

- (void)setupTableView
{
    self.tableView = [[UITableView alloc]
                      initWithFrame:CGRectInset(self.view.bounds, 0, 0)
                      style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
}

- (void)setupTipsMessageView
{
    self.tipLabel = [[UILabel alloc] initWithFrame:self.tableView.bounds];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.backgroundColor = [UIColor clearColor];
    self.tipLabel.textColor = [UIColor whiteColor];
    self.tipLabel.numberOfLines = 0;
    self.tipLabel.text = self.noMessageTips;
    [self.tableView addSubview:self.tipLabel];
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
    return [BaseCell heightOfCell];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"JMHouseListCell";
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[BaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - public method

- (void)setNoMessageTips:(NSString *)noMessageTips
{
    _noMessageTips = noMessageTips;
    self.tipLabel.text = noMessageTips;
}

- (void)reloadTableView
{
    if ([self.listDatas count] == 0) {
        if (![self.tipLabel superview]) {
            [self.tableView addSubview:self.tipLabel];
        }
    }
    else{
        [self.tipLabel removeFromSuperview];
    }
    [self.tableView reloadData];
}

@end
