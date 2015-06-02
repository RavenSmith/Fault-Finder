//
//  EarthquakeDataParser.m
//  Fault Finder
//
//  Created by Raven Smith on 6/1/15.
//  Copyright (c) 2015 Raven Smith. All rights reserved.
//

#import "EarthquakeDataParser.h"
#import "AFNetworking.h"

@implementation EarthquakeDataParser

static NSString * const leadingURLHalf = @"http://comcat.cr.usgs.gov/fdsnws/event/1/query?starttime=";
static NSString * const trailingURLHalf = @"&format=geojson&minmagnitude=1&orderby=time";

-(void)initWithTimestamp:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *currentDate = [[NSDate alloc]init];
    
    _timestamp =  [dateFormatter stringFromDate:currentDate];
}

-(void)fetchEarthquakeData {
    NSString *frontURLPiece = [NSString stringWithFormat:_timestamp, leadingURLHalf];
    NSString *wholeURL = [frontURLPiece stringByAppendingString:trailingURLHalf];
    
    NSURL *url = [NSURL URLWithString:wholeURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _earthquakes = (NSDictionary *) responseObject;
        NSLog(@"fetched earthquake data");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error Retrieving Earthquake Data"
                                  message:[error localizedDescription]
                                  delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles: nil];
        [alertView show];
    }];

    [operation start];
    
}

@end
