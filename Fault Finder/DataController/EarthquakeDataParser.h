//
//  EarthquakeDataParser.h
//  Fault Finder
//
//  Created by Raven Smith on 6/1/15.
//  Copyright (c) 2015 Raven Smith. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@class EarthquakeDataParser;

@protocol EarthquakeDataParserDelegate;

@interface EarthquakeDataParser : AFHTTPSessionManager

@property (nonatomic, weak) id<EarthquakeDataParserDelegate>delegate;
@property (nonatomic, strong) NSString * timestamp;
@property (nonatomic, strong) NSString * searchTerm;
@property (nonatomic, strong) NSArray * earthquakes;

+ (EarthquakeDataParser *) sharedEarthquakeDataParser;
- (instancetype) initWithBaseURL:(NSURL *)url;
-(void)fetchEarthquakeData;
-(void)addTimestamp;

@end

@protocol EarthquakeDataParserDelegate <NSObject>

@optional

@end

