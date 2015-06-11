//
//  FFTableViewController.h
//  Fault Finder
//
//  Created by Raven Smith on 6/2/15.
//  Copyright (c) 2015 Raven Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EarthquakeDataParser.h"
#import "FFTableViewCell.h"
#import "FFActivityViewController.h"

@interface FFTableViewController : UITableViewController <EarthquakeDataParserDelegate>

@property (nonatomic, strong) NSArray * quakes;
@property (nonatomic, strong) FFActivityViewController* waiting;
@property (nonatomic, strong) UIAlertController *actionSheet;


-(void) changeView: (int) option;

@end
