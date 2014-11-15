//
//  PTRXLandscapeViewController.m
//  StoreSearch
//
//  Created by Wang Long on 11/14/14.
//  Copyright (c) 2014 Wang Long. All rights reserved.
//

#import "PTRXLandscapeViewController.h"

@interface PTRXLandscapeViewController ()

@end

@implementation PTRXLandscapeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"dealloc %@", self);
}

@end
