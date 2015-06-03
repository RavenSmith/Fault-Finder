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
        
        _earthquakes = (NSDictionary *) responseObject;
        NSLog(@"fetched earthquake data");
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error Retrieving Earthquake Data"
                                  message:[error localizedDescription]
                                  delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles: nil];
        [alertView show];
        
    }];

    
    
//    NSURL *testURL = [NSURL URLWithString:@"http://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&minmagnitude=1&orderby=time&starttime=2015-06-01"];
//    
//    
//    //NSURL *url = [NSURL URLWithString:wholeURL];
//    NSURLRequest *request = [NSURLRequest requestWithURL:testURL];
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
//    operation.responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        _earthquakes = (NSDictionary *) responseObject;
//        NSLog(@"fetched earthquake data");
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        UIAlertView *alertView = [[UIAlertView alloc]
//                                  initWithTitle:@"Error Retrieving Earthquake Data"
//                                  message:[error localizedDescription]
//                                  delegate:nil
//                                  cancelButtonTitle:@"Ok"
//                                  otherButtonTitles: nil];
//        [alertView show];
//    }];
//
//    [operation start];
    
}

@end
