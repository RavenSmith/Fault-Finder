//
//  FFMapViewController.h
//  Fault Finder
//
//  Created by Raven Smith on 6/5/15.
//  Copyright (c) 2015 Raven Smith. All rights reserved.
//

#import "ViewController.h"
#import "EarthquakeDataParser.h"
#import <GoogleMaps/GoogleMaps.h>
#import "FFActivityViewController.h"


@interface FFMapViewController : ViewController <EarthquakeDataParserDelegate, GMSMapViewDelegate>

@property (strong, nonatomic) FFActivityViewController *waiting;


@end
