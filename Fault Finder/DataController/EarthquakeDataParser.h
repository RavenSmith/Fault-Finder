//
//  EarthquakeDataParser.h
//  Fault Finder
//
//  Created by Raven Smith on 6/1/15.
//  Copyright (c) 2015 Raven Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EarthquakeDataParser : NSObject

@property (nonatomic, strong) NSString * timestamp;
@property (nonatomic, strong) NSDictionary * earthquakes;

-(void)initWithTimestamp:(NSDate *)date;
-(void)fetchEarthquakeData;

@end
