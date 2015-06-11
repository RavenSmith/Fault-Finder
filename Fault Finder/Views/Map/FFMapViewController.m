//
//  FFMapViewController.m
//  Fault Finder
//
//  Created by Raven Smith on 6/5/15.
//  Copyright (c) 2015 Raven Smith. All rights reserved.
//

#import "FFMapViewController.h"
#import "LocationManager.h"


@interface FFMapViewController ()

@end

@implementation FFMapViewController {
    GMSMapView *mapView_;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LocationManager *locationManager = [LocationManager sharedInstance];

    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:locationManager.currentLocation.coordinate.latitude
                                                            longitude:locationManager.currentLocation.coordinate.longitude
                                                                 zoom:2];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = NO;
    mapView_.delegate = self;

    self.view = mapView_;
    [mapView_ addSubview:_waiting.view];
    _waiting = [[FFActivityViewController alloc]init];
    _waiting.view.hidden = NO;
    _waiting.view.center = self.view.center;
    [mapView_ addSubview:_waiting.view];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateTable"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkRes:) name:@"updateTable" object:nil];
    

    [self placeMarkers];

    
}

-(void) viewDidAppear:(BOOL)animated {
    [mapView_ addSubview:_waiting.view];
    
    NSLog(@"user switched to map view");
    
    [mapView_ clear];

    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateTable"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkRes:) name:@"updateTable" object:nil];
    
    
    [self placeMarkers];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) placeMarkers {
    


    LocationManager *locationManager = [LocationManager sharedInstance];
    GMSMarker *user = [[GMSMarker alloc]init];
    user.position = locationManager.currentLocation.coordinate;
 
    user.icon = [UIImage imageNamed:@"user-location.png"];
    user.opacity = 1;
    user.map = mapView_;
    
    [self loadEarthquakeMarkers];
    
}


-(void) loadEarthquakeMarkers {
    EarthquakeDataParser *parser = [EarthquakeDataParser sharedEarthquakeDataParser];
    parser.delegate = self;
    [parser fetchEarthquakeData];
    
    NSArray *quakes = parser.earthquakes;
    
    for (int i = 0; i < [quakes count]; i++) {
        GMSMarker *marker = [[GMSMarker alloc]init];
        NSDictionary *properties = [quakes[i]  objectForKey:@"properties"];
        NSDictionary *locale = [quakes[i] objectForKey:@"geometry"];
        [self configureMarker:properties :locale :marker];
    }
}

-(void)configureMarker: (NSDictionary *)properties : (NSDictionary *)locale : (GMSMarker *) marker {
    
        double magnitude = [[properties objectForKey:@"mag"] doubleValue];
        
        marker.icon = [self chooseMarkerColor:magnitude];
        NSArray *coordinates = (NSArray *) [locale objectForKey:@"coordinates"];
        double longitude = [coordinates[0] doubleValue];
        double latitude = [coordinates[1] doubleValue];
        CLLocationCoordinate2D coord;
        coord.latitude = latitude;
        coord.longitude = longitude;
        marker.position = coord;
        marker.opacity = 0.5;
    
        double time = [[properties objectForKey:@"time"] doubleValue];
       NSString* formattedTime = [self getTimeSinceQuake:time];
        NSString *infoWindow = [NSString stringWithFormat:@"%@\n%@ [More Info]", [properties objectForKey:@"title"], formattedTime];
    
        marker.snippet = infoWindow;
        marker.userData = [properties objectForKey:@"url"];
        marker.infoWindowAnchor = CGPointMake(0.5, 0.5);
        marker.map = mapView_;
    
//        CGFloat time = [[properties objectForKey:@"time"] floatValue];
//        [self getTimeSinceQuake:time];

}

-(UIImage*)chooseMarkerColor: (double) magnitude {
    if (magnitude >= 7.0) {
        
        //turquoise not really felt
        return [UIImage imageNamed:@"magnitude7ormore"];
    } else if ((3.1 <= magnitude ) && (magnitude <= 3.9) ) {
        
        //sunflower felt in buildings
        return [UIImage imageNamed:@"magnitude3"];
        
    } else if ((4.0 <= magnitude ) && (magnitude <= 4.9) ) {
        
        //carrot broken dishes/windows
        return [UIImage imageNamed:@"magnitude4"];
        
    } else if ((5.0 <= magnitude ) && (magnitude <= 5.9) ) {
        
        //alizarin moved heavy furniture
        return [UIImage imageNamed:@"magnitude5"];
        
    } else if ((6.0 <= magnitude ) && (magnitude <= 6.9) ) {
        
        //wisteria buildings shift on their foundation
        return [UIImage imageNamed:@"magnitude6"];
        
    } else {
        
        //wet asphalt god help you
        return [UIImage imageNamed:@"magnitude3orless"];
    }
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:marker.userData]];
}


- (IBAction)actionBtnPressed:(UIBarButtonItem *)sender {
    UIAlertController* actionSheet = [UIAlertController alertControllerWithTitle:@"History" message:@"Earthquakes happen often. Choose how far back you want to go." preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* today = [UIAlertAction actionWithTitle:@"Today" style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * action) {
                                                    
                                                    [self changeView:1];
                                                    
                                                }];
    
    UIAlertAction* lastMonth = [UIAlertAction actionWithTitle:@"Last 30 Days" style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                     
                                                     [self changeView:2];
                                                     
                                                 }];
    
    UIAlertAction* lastYear = [UIAlertAction actionWithTitle:@"Past Year (Major Quakes)" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          
                                                          [self changeView:3];
                                                          
                                                      }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * action) {}];
    
    [actionSheet addAction:today];
    [actionSheet addAction:lastMonth];
    [actionSheet addAction:lastYear];
    [actionSheet addAction:cancel];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
    
    
}



-(void)changeView: (int) option {

    [self.view addSubview:_waiting.view];
    
    [mapView_ clear];
    
    EarthquakeDataParser *parser = [EarthquakeDataParser sharedEarthquakeDataParser];
    parser.delegate = self;
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *currentDate = [[NSDate alloc]init];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *compsMonth = [[NSDateComponents alloc]init];
    NSDateComponents *compsYear = [[NSDateComponents alloc]init];
    compsMonth.month = -1;
    compsYear.year   = -1;
    
    if (option == 1) {
        //view today's quakes
        [parser editHistory:[dateFormatter stringFromDate:currentDate]];
        [parser editMagnitudes:@"1"];
        
    } else if (option == 2) {
        //view earthquakes in the past 30 days
         NSDate *date = [calendar dateByAddingComponents:compsMonth toDate:[NSDate date] options:0];
        [parser editHistory:[dateFormatter stringFromDate:date]];
        [parser editMagnitudes:@"1"];
                             
        
    } else {
        //view earthquakes from the past year
        NSLog(@"wants to see past major quakes");
        NSDate *date = [calendar dateByAddingComponents:compsYear toDate:[NSDate date] options:0];
        [parser editHistory:[dateFormatter stringFromDate:date]];
        [parser editMagnitudes:@"5"];
        
    }
    
    [parser fetchEarthquakeData];
    
    
}

-(void)checkRes:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"updateTable"])
    {
        
        EarthquakeDataParser *parser = [EarthquakeDataParser sharedEarthquakeDataParser];
        parser.delegate = self;
        
        LocationManager *locationManager = [LocationManager sharedInstance];
        GMSMarker *user = [[GMSMarker alloc]init];
        user.position = locationManager.currentLocation.coordinate;
        user.icon = [UIImage imageNamed:@"user-location.png"];
        user.opacity = 1;
        user.map = mapView_;
        
        NSArray *quakes = parser.earthquakes;
        
        for (int i = 0; i < [quakes count]; i++) {
//            NSLog(@"adding marker %i", i);
            GMSMarker *marker = [[GMSMarker alloc]init];
            NSDictionary *properties = [quakes[i]  objectForKey:@"properties"];
            NSDictionary *locale = [quakes[i] objectForKey:@"geometry"];
            [self configureMarker:properties :locale :marker];
        }


    } else if ([[notification name] isEqualToString:@"updateTableFailed"]) {
        NSLog(@"failed to update");
    }
    
    [_waiting.view removeFromSuperview];

}

- (void) mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position {

    [_waiting.view removeFromSuperview];

}

-(NSString *)getTimeSinceQuake: (CGFloat) timeInMillisecondsSinceEpoch {
    
    CGFloat numSeconds = timeInMillisecondsSinceEpoch / 1000;
    NSDate *date = [[NSDate alloc]init];
    NSInteger epochTime = [date timeIntervalSince1970];
    NSInteger NSelapsedTime = epochTime - numSeconds;
    int elapsedTime = (int) NSelapsedTime;
    
    NSString *stringElapsedTime = [self getPlainTextEarthquakeTime:elapsedTime :timeInMillisecondsSinceEpoch];
    return stringElapsedTime;
    
}

-(NSString *) getPlainTextEarthquakeTime: (int) elapsedTime : (CGFloat) timeInMillisecondsSinceEpoch {
    
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
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInMillisecondsSinceEpoch/1000];
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"MM dd, yyyy"];
                NSString* unformattedDate = [formatter stringFromDate:date];
                NSString* toBeFormatted = [unformattedDate substringToIndex:2];
                NSString* alreadyFormatted = [unformattedDate substringFromIndex:2];
                int formattedMonth = [toBeFormatted intValue];
                NSString* fullyFormattedDate = @"";
                
                switch (formattedMonth) {
                    case 1:
                        fullyFormattedDate = [fullyFormattedDate stringByAppendingString:@"January"];
                        break;
                    case 2:
                        fullyFormattedDate = [fullyFormattedDate stringByAppendingString:@"February"];
                        break;
                    case 3:
                        fullyFormattedDate = [fullyFormattedDate stringByAppendingString:@"March"];
                        break;
                    case 4:
                        fullyFormattedDate = [fullyFormattedDate stringByAppendingString:@"April"];
                        break;
                    case 5:
                        fullyFormattedDate = [fullyFormattedDate stringByAppendingString:@"May"];
                        break;
                    case 6:
                        fullyFormattedDate = [fullyFormattedDate stringByAppendingString:@"June"];
                        break;
                    case 7:
                        fullyFormattedDate = [fullyFormattedDate stringByAppendingString:@"July"];
                        break;
                    case 8:
                        fullyFormattedDate = [fullyFormattedDate stringByAppendingString:@"August"];
                        break;
                    case 9:
                        fullyFormattedDate = [fullyFormattedDate stringByAppendingString:@"September"];
                        break;
                    case 10:
                        fullyFormattedDate = [fullyFormattedDate stringByAppendingString:@"October"];
                        break;
                    case 11:
                        fullyFormattedDate = [fullyFormattedDate stringByAppendingString:@"November"];
                        break;
                    case 12:
                        fullyFormattedDate = [fullyFormattedDate stringByAppendingString:@"December"];
                        break;
                    default:
                        fullyFormattedDate = [fullyFormattedDate stringByAppendingString:@"You messed UP"];
                        break;
                }
               
                fullyFormattedDate = [fullyFormattedDate stringByAppendingString:alreadyFormatted];
                return fullyFormattedDate;
                
                
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
