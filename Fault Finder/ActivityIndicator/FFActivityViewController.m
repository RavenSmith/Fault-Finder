//
//  FFActivityViewController.m
//  Fault Finder
//
//  Created by Raven Smith on 6/5/15.
//  Copyright (c) 2015 Raven Smith. All rights reserved.
//

#import "FFActivityViewController.h"

@interface FFActivityViewController ()

@end

@implementation FFActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"initiating loading...");
    _ai.hidden = NO;
    _ai.center = self.view.center;
    [_ai startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)stopLoading {
    [_ai stopAnimating];
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
