//
//  FFTableViewCell.m
//  Fault Finder
//
//  Created by Raven Smith on 6/2/15.
//  Copyright (c) 2015 Raven Smith. All rights reserved.
//

#import "FFTableViewCell.h"

@interface FFTableViewCell()
@property (nonatomic, weak) IBOutlet UIImageView *iconView;
@end


@implementation FFTableViewCell

#pragma mark - Synthesis Override

-(void)setIcon:(UIImage *)icon {
    _icon = icon;
    self.iconView.image = icon;
}

#pragma mark - Initialization

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];

    if (self) {

        [self setup];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

-(void)configureCell: (NSDictionary *) properties {
    if (properties) {
        self.textLabel.text = [properties objectForKey:@"type"];
        self.detailTextLabel.text = [properties objectForKey:@"title"];
        self.textLabel.textColor = [UIColor whiteColor];
        
        double magnitude = [[properties objectForKey:@"yourDouble"] doubleValue];
        [self chooseCellColor:magnitude];
        
    } else {
        [self setCellContent];
    }
}

-(void)chooseCellColor: (double) magnitude {
    if (magnitude <= 5.0) {
        
        //turquoise
        self.backgroundColor = [UIColor colorWithRed:26/255.0f green:188/255.0f blue:156/255.0f alpha:1.0f];
        
    } else if ((5.0 < magnitude ) && (magnitude < 5.9) ) {
       
        //sunflower
        self.backgroundColor = [UIColor colorWithRed:241/255.0f green:196/255.0f blue:15/255.0f alpha:1.0f];
        
    } else if ((6.0 < magnitude ) && (magnitude < 6.9) ) {
        
        //carrot
        self.backgroundColor = [UIColor colorWithRed:230/255.0f green:126/255.0f blue:34/255.0f alpha:1.0f];
        
    } else if ((7.0 < magnitude ) && (magnitude < 7.9) ) {
       
        //alizarin
        self.backgroundColor = [UIColor colorWithRed:231/255.0f green:76/255.0f blue:60/255.0f alpha:1.0f];
        
    } else {
        
        //wet asphalt
        self.backgroundColor = [UIColor colorWithRed:52/255.0f green:73/255.0f blue:94/255.0f alpha:1.0f];
    }
}

-(void)setCellContent {
    _titleText = @"Test Label";
    _detailText = @"A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. ";
    self.imageView.image = [UIImage imageNamed:@"great-q.png"];

}

-(void)setup {

    self.textLabel.text = @"";
    self.detailTextLabel.text = @"";
    self.detailTextLabel.numberOfLines = 0;
    self.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
