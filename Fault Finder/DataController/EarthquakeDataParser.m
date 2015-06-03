//
//  EarthquakeDataParser.m
//  Fault Finder
//
//  Created by Raven Smith on 6/1/15.
//  Copyright (c) 2015 Raven Smith. All rights reserved.
//

#import "EarthquakeDataParser.h"


static NSString * const USGSOnlineURLString = @"http://earthquake.usgs.gov/fdsnws/event/1/query?";

@implementation EarthquakeDataParser

+ (EarthquakeDataParser *) sharedEarthquakeDataParser {
    static EarthquakeDataParser *_sharedEarthquakeParser = nil;
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        _sharedEarthquakeParser = [[self alloc] initWithBaseURL:[NSURL URLWithString:USGSOnlineURLString]];
    });
    
    return _sharedEarthquakeParser;
}

- (instancetype) initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        [self addTimestamp];
    }
    
    return self;
}

-(void)addTimestamp {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *currentDate = [[NSDate alloc]init];
    
    _timestamp =  [dateFormatter stringFromDate:currentDate];
}

-(void)fetchEarthquakeData {
    NSDictionary *params = @{@"starttime": _timestamp, @"format": @"geojson", @"minmagnitude": @"1", @"orderby": @"time" };
    
    [self GET:USGSOnlineURLString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *results = (NSDictionary *) responseObject;
        
        _earthquakes = results[@"features"];
        NSLog(@"fetched earthquake data: %@", _earthquakes);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTable" object:self];

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error Retrieving Earthquake Data"
                                  message:[error localizedDescription]
                                  delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles: nil];
        [alertView show];
        
    }];
    
}

@end
