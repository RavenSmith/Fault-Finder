//
//  FFTableViewCell.m
//  Fault Finder
//
//  Created by Raven Smith on 6/2/15.
//  Copyright (c) 2015 Raven Smith. All rights reserved.
//

#import "FFTableViewCell.h"
#import "LocationManager.h"

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

-(void)configureCell: (NSDictionary *)properties : (NSDictionary *)locale {
    if (properties) {
        self.detailTextLabel.text = [properties objectForKey:@"title"];
        self.textLabel.textColor = [UIColor whiteColor];
        
        double magnitude = [[properties objectForKey:@"mag"] doubleValue];

        [self chooseCellColor:magnitude];
        
        CGFloat time = [[properties objectForKey:@"time"] floatValue];
        [self getTimeSinceQuake:time];
        
        NSArray *coordinates = (NSArray *) [locale objectForKey:@"coordinates"];
        double longitude = [coordinates[0] doubleValue];
        double latitude = [coordinates[1] doubleValue];

        self.textLabel.text = [self getEarthquakeDistance:latitude :longitude];
        
        
    } else {
        [self setCellContent];
    }
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

-(void)setCellContent {
    _titleText = @"Test Label";
    _detailText = @"A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. A lot of text. ";
    
}


#pragma mark - Getting Earthquake Magnitude

-(void)chooseCellColor: (double) magnitude {
    if (magnitude >= 7.0) {
        
        //wet asphalt god help you
        self.backgroundColor = [UIColor colorWithRed:52/255.0f green:73/255.0f blue:94/255.0f alpha:1.0f];
        
        
    } else if ((3.1 <= magnitude ) && (magnitude <= 3.9) ) {
       
        //sunflower felt in buildings
        self.backgroundColor = [UIColor colorWithRed:241/255.0f green:196/255.0f blue:15/255.0f alpha:1.0f];
        
    } else if ((4.0 <= magnitude ) && (magnitude <= 4.9) ) {
        
        //carrot broken dishes/windows
        self.backgroundColor = [UIColor colorWithRed:230/255.0f green:126/255.0f blue:34/255.0f alpha:1.0f];
        
    } else if ((5.0 <= magnitude ) && (magnitude <= 5.9) ) {
       
        //alizarin moved heavy furniture
        self.backgroundColor = [UIColor colorWithRed:231/255.0f green:76/255.0f blue:60/255.0f alpha:1.0f];
        
    } else if ((6.0 <= magnitude ) && (magnitude <= 6.9) ) {
        
        //wisteria buildings shift on their foundation
        self.backgroundColor = [UIColor colorWithRed:142/255.0f green:68/255.0f blue:173/255.0f alpha:1.0f];
        
    } else {
        
        //turquoise not really felt
        self.backgroundColor = [UIColor colorWithRed:26/255.0f green:188/255.0f blue:156/255.0f alpha:1.0f];
        
    }
}

#pragma mark - Getting Earthquake Time

-(void)getTimeSinceQuake: (CGFloat) timeInMillisecondsSinceEpoch {
    
    CGFloat numSeconds = timeInMillisecondsSinceEpoch / 1000;
    NSDate *date = [[NSDate alloc]init];
    NSInteger epochTime = [date timeIntervalSince1970];
    NSInteger NSelapsedTime = epochTime - numSeconds;
    int elapsedTime = (int) NSelapsedTime;

    NSString *stringElapsedTime = [self getPlainTextEarthquakeTime:elapsedTime];
    NSString *statementOfTime = @"\n";
    statementOfTime = [statementOfTime stringByAppendingString:stringElapsedTime];
    self.detailTextLabel.text = [self.detailTextLabel.text stringByAppendingString:statementOfTime];
    
}

-(NSString *) getPlainTextEarthquakeTime: (int) elapsedTime {
    
    if (elapsedTime == 0 ) {
        return @"Now";
        
    } else if ( elapsedTime == 1) {
        return @"1 second ago";
        
    } else if (elapsedTime < 60) {
        
        return [self getExactSeconds:elapsedTime];
        
    } else {
        
        int elapsedMins = elapsedTime / 60;
        
        if (elapsedMins == 1) {
            
            return @"1 minute ago";
            
        } else if (elapsedMins < 60) {
            
            return [self getExactMinutes:elapsedMins];
            
        } else {
            
            int elapsedHours = elapsedMins / 60;
            int remainingMins = elapsedTime % 60;
            
            if (elapsedHours == 1) {
                
                return @"1 hour ago";
                
            } else if (elapsedHours < 24) {
                
                return [self getExactHoursAndMinutes:elapsedHours :remainingMins];
                
            } else {
                return @"Yesterday";
            }
        }
    }
}

-(NSString *)getExactSeconds: (int) elapsedTimeInSeconds {
    
    NSString *stringElapsedTimeInSeconds = [NSString stringWithFormat:@"%i", elapsedTimeInSeconds];
    stringElapsedTimeInSeconds = [stringElapsedTimeInSeconds stringByAppendingString:@" seconds ago"];
    return stringElapsedTimeInSeconds;
}

-(NSString *)getExactMinutes: (int) elapsedTimeInMinutes {
    
    NSString *stringElapsedMinutes = [NSString stringWithFormat:@"%i", elapsedTimeInMinutes];
    stringElapsedMinutes =  [stringElapsedMinutes  stringByAppendingString:@" minutes ago"];
    return stringElapsedMinutes;
}

-(NSString *)getExactHoursAndMinutes: (int) elapsedTimeInHours :(int) remainingMins {
    
    NSString *stringElapsedHours = [NSString stringWithFormat:@"%i", elapsedTimeInHours];
    NSString *stringElapsedMinutes = [NSString stringWithFormat:@"%i", remainingMins];
    
    stringElapsedHours =  [stringElapsedHours  stringByAppendingString:@" hours and "];
    stringElapsedHours =  [stringElapsedHours  stringByAppendingString:stringElapsedMinutes];
    stringElapsedHours =  [stringElapsedHours  stringByAppendingString:@" minutes ago"];
    return stringElapsedHours;
    
}


#pragma mark - Getting Earthquake Distance

-(NSString *)getEarthquakeDistance:(double)eLatitude :(double)eLongitude {
    
    LocationManager *locationManager = [LocationManager sharedInstance];
    
    
    CLLocation *current = [[CLLocation alloc] initWithLatitude:locationManager.currentLocation.coordinate.latitude longitude:locationManager.currentLocation.coordinate.longitude];
    CLLocation *itemLoc = [[CLLocation alloc] initWithLatitude:eLatitude longitude:eLongitude];
    
    CLLocationDistance itemDist = [itemLoc distanceFromLocation:current];
//    NSLog(@"\nwhere is user? \n\nlatitude: %f\nlongitude: %f", current.coordinate.latitude, current.coordinate.longitude);
//    NSLog(@"\nwhere is quake? \n\nlatitude: %f\nlongitude: %f", itemLoc.coordinate.latitude, itemLoc.coordinate.longitude);

    
    NSString *results = @"";

    //convert from meters to miles
    itemDist = itemDist / 1609.34;
    
    if (itemDist < 1) {
        results = [results stringByAppendingString:@"less than 1 mile away"];
    } else if (itemDist < 2) {
        results = [results stringByAppendingString:@"1 mile away"];
    } else {
        int nicerDist = (int) itemDist;
        results = [results stringByAppendingFormat:@"%i miles away", nicerDist];
    }
    
    return results;
}



@end
