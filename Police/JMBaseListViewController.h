//
//  JMBaseListViewController.h
//  SaleHouse
//
//  Created by wang animeng on 13-4-23.
//  Copyright (c) 2013年 jam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMBaseListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray * listDatas;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSString *noMessageTips;

- (void)reloadTableView;

@end
