//
//  LocationManager.h
//  Fault Finder
//
//  Created by Raven Smith on 6/4/15.
//  Copyright (c) 2015 Raven Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface LocationManager : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (weak, nonatomic) id delegate;

+(LocationManager *) sharedInstance;
- (void)startUpdatingLocation;

@end
