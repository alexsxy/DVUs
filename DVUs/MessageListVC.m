//
//  FirstViewController.m
//  DVUs
//
//  Created by pan Shiyu on 13-9-24.
//  Copyright (c) 2013年 pan Shiyu. All rights reserved.
//

#import "MessageListVC.h"
#import "MessageEditVC.h"

@implementation MessageListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_msgList reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) { // undo
        return [DataCenter sharedDataCenter].undoList.count;
    } else {
        return [DataCenter sharedDataCenter].doneList.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *tmpCell = nil;
    static NSString *cellIdentifier = @"DoneMsgTableCell";
    DVMessage *tmpMessage = nil;
    if (indexPath.section == 0) {
        cellIdentifier = @"UndoMsgTableCell";
        tmpMessage = [[DataCenter sharedDataCenter].undoList objectAtIndex:indexPath.row];
        
        tmpCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!tmpCell) {
            tmpCell = [[UndoMsgTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        ((UndoMsgTableCell*)tmpCell).refMessage = tmpMessage;
    } else {
        cellIdentifier = @"DoneMsgTableCell";
        tmpMessage = [[DataCenter sharedDataCenter].doneList objectAtIndex:indexPath.row];
        
        tmpCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!tmpCell) {
            tmpCell = [[DoneMsgTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        ((DoneMsgTableCell*)tmpCell).refMessage = tmpMessage;
    }
    
    return tmpCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DVMessage *tmpMessage = nil;
    if (indexPath.section == 0) {
        tmpMessage = [[DataCenter sharedDataCenter].undoList objectAtIndex:indexPath.row];
    } else {
        tmpMessage = [[DataCenter sharedDataCenter].doneList objectAtIndex:indexPath.row];
    }
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MessageEditVC *vc = [sb instantiateViewControllerWithIdentifier:@"MessageEditVC"];
    
    vc.outMessage = tmpMessage;
    
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}


- (IBAction)onAdd {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MessageEditVC"];
    
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

@end

#pragma mark - format data -----------------------------

@implementation DoneMsgTableCell

- (void)setRefMessage:(DVMessage *)refMessage {
    _refMessage = refMessage;
    
    if (_refMessage) {
        _timeLabel.text = _refMessage.timeStr;
        _infoLabel.text = _refMessage.title;
    }
}

@end

@implementation UndoMsgTableCell

- (void)setRefMessage:(DVMessage *)refMessage {
    _refMessage = refMessage;
    
    if (_refMessage) {
        self.timeLabel.text = _refMessage.timeStr;
        self.infoLabel.text = _refMessage.title;
    }
}

@end
