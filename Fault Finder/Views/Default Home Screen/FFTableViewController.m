//
//  FFTableViewController.m
//  Fault Finder
//
//  Created by Raven Smith on 6/2/15.
//  Copyright (c) 2015 Raven Smith. All rights reserved.
//

#import "FFTableViewController.h"




@interface FFTableViewController ()

@end

@implementation FFTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateTable"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkRes:) name:@"updateTable" object:nil];
    
    EarthquakeDataParser *parser = [EarthquakeDataParser sharedEarthquakeDataParser];
    parser.delegate = self;
    [parser fetchEarthquakeData];


    
    [self.tableView registerClass:[FFTableViewCell class] forCellReuseIdentifier:@"ffCell"];
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
    
    NSLog(@"what got imported? %u quakes", [_quakes count]);
    
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
        [cell configureCell:properties];
        
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
    }
}


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
