//
//  MGRLoginViewController.m
//  MerryGoRound2
//
//  Created by Nikolay Morev on 23/03/16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRLoginViewController.h"
#import <DropboxSDK/DropboxSDK.h>

@interface MGRLoginViewController ()

@end

@implementation MGRLoginViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    DBSession *session = [[DBSession alloc] initWithAppKey:@"yoykfhbr69abubo" appSecret:@"jzgj6imeiop5t6w" root:kDBRootDropbox];
    [DBSession setSharedSession:session];

    if ([[DBSession sharedSession] isLinked]) {
        [self performSegueWithIdentifier:@"ShowUI" sender:nil];
    }
}

- (IBAction)loginButtonTapped:(id)sender {
    if ([[DBSession sharedSession] isLinked]) {
        [self performSegueWithIdentifier:@"ShowUI" sender:nil];
    }
    else {
        [[DBSession sharedSession] linkFromController:self];
    }
}


@end
