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
        self.params = [NSMutableDictionary new];
        [_params setObject:_timestamp forKey:@"starttime"];
        [_params setObject:@"geojson" forKey:@"format"];
        [_params setObject:@"2" forKey:@"minmagnitude"];
        [_params setObject:@"time" forKey:@"orderby"];
        
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
    
    
    //NSLog(@"How far back for quakes? %@", [_params objectForKey:@"starttime"]);
    
    [self GET:USGSOnlineURLString parameters:_params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *results = (NSDictionary *) responseObject;
        
        _earthquakes = results[@"features"];
        //NSLog(@"fetched earthquake data: %@", _earthquakes);
        
        
        NSLog(@"--------->REQUEST COMPLETED<-----------");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTable" object:self];

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error Retrieving Earthquake Data"
                                  message:[error localizedDescription]
                                  delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles: nil];
        [alertView show];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTableFailed" object:self];
        
    }];
    
}

-(void)editParams: (NSString *) order {
    [_params setObject:order forKey:@"orderby"];
}

-(void)editHistory: (NSString *) howFarBack {
    [_params setObject:howFarBack forKey:@"starttime"];
}

-(void)editMagnitudes: (NSString *) whatMagnitude {
    [_params setObject:whatMagnitude forKey:@"minmagnitude"];
}

@end
