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
    NSLog(@"am I myself?");
    if (self) {
        NSLog(@"yes I am");
        [self setup];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

-(void)setCellContent {
    _titleText = @"Test Label";
    _detailText = @"A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. ";
    self.imageView.image = [UIImage imageNamed:@"great-q.png"];

}

-(void)setup {
    
    [self setCellContent];
    
    self.backgroundColor = [UIColor orangeColor];
    self.textLabel.text = _titleText;
    self.detailTextLabel.text = _detailText;
    self.detailTextLabel.numberOfLines = 0;
    self.detailTextLabel.lineBreakMode =
    NSLineBreakByWordWrapping;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
