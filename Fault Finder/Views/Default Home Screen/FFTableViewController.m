//
//  FFTableViewController.m
//  Fault Finder
//
//  Created by Raven Smith on 6/2/15.
//  Copyright (c) 2015 Raven Smith. All rights reserved.
//

#import "FFTableViewController.h"
#import "LocationManager.h"




@interface FFTableViewController ()

@end

@implementation FFTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _actionSheet = [UIAlertController alertControllerWithTitle:@"Order Earthquakes By" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction*mag = [UIAlertAction actionWithTitle:@"Largest Magnitude" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   
                                                   [self changeView:1];
                                                   
                                               }];
    
    UIAlertAction* time = [UIAlertAction actionWithTitle:@"✓ Most Recent" style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                     
                                                     [self changeView:2];
                                                     
                                                 }];
    
    UIAlertAction* proximity = [UIAlertAction actionWithTitle:@"Proximity" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          
                                                          [self changeView:3];
                                                          
                                                      }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * action) {}];
    
    [_actionSheet addAction:proximity];
    [_actionSheet addAction:mag];
    [_actionSheet addAction:time];
    [_actionSheet addAction:cancel];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateTable"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkRes:) name:@"updateTable" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateTableFailed"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkRes:) name:@"updateTableFailed" object:nil];
    
    _waiting = [[FFActivityViewController alloc]init];
    _waiting.view.center = self.tableView.center;
    [self.tableView addSubview:_waiting.view];
    
    EarthquakeDataParser *parser = [EarthquakeDataParser sharedEarthquakeDataParser];
    parser.delegate = self;
    [parser fetchEarthquakeData];
    
    LocationManager *locationManager = [LocationManager sharedInstance];
    [locationManager addObserver:self forKeyPath:@"currentLocation" options:NSKeyValueObservingOptionNew context:nil];
    [locationManager startUpdatingLocation];
    
    [self.tableView registerClass:[FFTableViewCell class] forCellReuseIdentifier:@"ffCell"];
}

-(void)viewDidAppear:(BOOL)animated {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *currentDate = [[NSDate alloc]init];
    
    EarthquakeDataParser *parser = [EarthquakeDataParser sharedEarthquakeDataParser];
    parser.delegate = self;
    [parser editHistory:[dateFormatter stringFromDate:currentDate]];
    [parser editMagnitudes:@"1"];
    [parser fetchEarthquakeData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([_quakes count] < 1) {
        return 1;
    } else {
        return [_quakes count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ffCell"];
    
    if (cell == nil) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"ffCell"];
        
    }
    
    if ([_quakes count] > 0) {
        NSDictionary *properties = [_quakes[indexPath.row ]  objectForKey:@"properties"];
        NSDictionary *locale = [_quakes [indexPath.row] objectForKey:@"geometry"];
        [cell configureCell:properties :locale];
        
    }
    
        
    return cell;
}

-(void)checkRes:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"updateTable"])
    {
        EarthquakeDataParser *sharedEarthquakeDataParser = [EarthquakeDataParser sharedEarthquakeDataParser];
        _quakes = sharedEarthquakeDataParser.earthquakes;
        
        [self.tableView reloadData];
    } else if ([[notification name] isEqualToString:@"updateTableFailed"]) {
        NSLog(@"failed to update");
    }
    
    [_waiting.view removeFromSuperview];
}


- (IBAction)actionBtnPressed:(UIBarButtonItem *)sender {
    
    [self presentViewController:_actionSheet animated:YES completion:nil];
    
}

-(void) changeView: (int) option {
    
    UIAlertController* newController = [UIAlertController alertControllerWithTitle:@"Order Earthquakes By" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * action) {}];
    
    EarthquakeDataParser *sharedEarthquakeDataParser = [EarthquakeDataParser sharedEarthquakeDataParser];
    if (option == 1) {
        
        
        UIAlertAction*mag = [UIAlertAction actionWithTitle:@"✓ Largest Magnitude" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                       [self changeView:1];
                                                       
                                                   }];
        UIAlertAction* time = [UIAlertAction actionWithTitle:@"Most Recent" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         
                                                         [self changeView:2];
                                                         
                                                     }];
        
        UIAlertAction* proximity = [UIAlertAction actionWithTitle:@"Proximity" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              
                                                              [self changeView:3];
                                                              
                                                          }];
        
        [newController addAction:proximity];
        [newController addAction:mag];
        [newController addAction:time];
        [newController addAction:cancel];
        _actionSheet = newController;
    
       
        [sharedEarthquakeDataParser editParams:@"magnitude"];
        [sharedEarthquakeDataParser fetchEarthquakeData];

        
        
    } else if (option == 2) {
        
        UIAlertAction*mag = [UIAlertAction actionWithTitle:@"Largest Magnitude" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                       [self changeView:1];
                                                       
                                                   }];
        
        UIAlertAction* time = [UIAlertAction actionWithTitle:@"✓ Most Recent" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         
                                                         [self changeView:2];
                                                         
                                                     }];
        
        UIAlertAction* proximity = [UIAlertAction actionWithTitle:@"Proximity" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              
                                                              [self changeView:3];
                                                              
                                                          }];
        [newController addAction:proximity];
        [newController addAction:mag];
        [newController addAction:time];
        [newController addAction:cancel];
        _actionSheet = newController;
        
        
        [sharedEarthquakeDataParser editParams:@"time"];
        [sharedEarthquakeDataParser fetchEarthquakeData];

        
    } else {
        
        UIAlertAction*mag = [UIAlertAction actionWithTitle:@"Largest Magnitude" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                       [self changeView:1];
                                                       
                                                   }];
        
        UIAlertAction* time = [UIAlertAction actionWithTitle:@"Most Recent" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         
                                                         [self changeView:2];
                                                         
                                                     }];
        
        UIAlertAction* proximity = [UIAlertAction actionWithTitle:@"✓ Proximity" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              
                                                              [self changeView:3];
                                                              
                                                          }];
        [newController addAction:proximity];
        [newController addAction:mag];
        [newController addAction:time];
        [newController addAction:cancel];
        _actionSheet = newController;
        
        [self sortQuakesByProximity];
    }
    
    
}

-(void)sortQuakesByProximity {
    
    
    LocationManager *locationManager = [LocationManager sharedInstance];
    
    
    CLLocation *current = [[CLLocation alloc] initWithLatitude:locationManager.currentLocation.coordinate.latitude longitude:locationManager.currentLocation.coordinate.longitude];
    
    _quakes = [_quakes sortedArrayUsingComparator: ^(id a, id b) {
        
        NSDictionary *localeA = [a objectForKey:@"geometry"];
        NSDictionary *localeB = [b objectForKey:@"geometry"];
        
        NSArray *coordinatesA = (NSArray *) [localeA objectForKey:@"coordinates"];
        NSArray *coordinatesB = (NSArray *) [localeB objectForKey:@"coordinates"];

        double latitudeA = [coordinatesA[1] doubleValue];
        double longitudeA = [coordinatesA[0] doubleValue];
        
        double latitudeB = [coordinatesB[1] doubleValue];
        double longitudeB = [coordinatesB[0] doubleValue];
        
        CLLocation *itemLocA = [[CLLocation alloc] initWithLatitude:latitudeA longitude:longitudeA];
        CLLocation *itemLocB = [[CLLocation alloc] initWithLatitude:latitudeB longitude:longitudeB];
        
        
        CLLocationDistance dist_a= [itemLocA distanceFromLocation: current];
        CLLocationDistance dist_b= [itemLocB distanceFromLocation: current];

        if ( dist_a < dist_b ) {
            return (NSComparisonResult)NSOrderedAscending;
        } else if ( dist_a > dist_b) {
            return (NSComparisonResult)NSOrderedDescending;
        } else {
            return (NSComparisonResult)NSOrderedSame;
        }
    }];
    
    [self.tableView reloadData];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object  change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"currentLocation"]) {

        NSLog(@"location updated");
        
    }
}

//- (void) locationManagerDidUpdateLocation:(CLLocation *)location {
//    NSLog(@"location was updated in FFTableViewController.m");
//    LocationManager *locationManager = [LocationManager sharedInstance];
//    locationManager.currentLocation = location;
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
