//
//  FFTableViewCell.h
//  Fault Finder
//
//  Created by Raven Smith on 6/2/15.
//  Copyright (c) 2015 Raven Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImage * icon;
@property (nonatomic, weak) IBOutlet UILabel * title;
@property (nonatomic, weak) IBOutlet UILabel * details;
@property (nonatomic, strong) NSString * titleText;
@property (nonatomic, strong) NSString * detailText;

//-(void)configureCell;

@end
