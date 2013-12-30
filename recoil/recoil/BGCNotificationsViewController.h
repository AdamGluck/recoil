//
//  BGCNotificationsViewController.h
//  recoil
//
//  Created by Adam Gluck on 8/5/13.
//  Copyright (c) 2013 BGC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGCNotificationsViewController : UITableViewController

/**
 * @abstract The casualties that are used in the TableViewDataSource.
 * @discussion If you are passing to this method externally then make sure to order the casualities by date first. Otherwise there will be indeterminant behavior.
 */
@property (strong, nonatomic) NSMutableArray *casualties;
/**
 * @discussion Simply calls [self.tableView reloadData]
 */
-(void)reload;

@end
