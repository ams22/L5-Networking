//
//  MGRListViewController.m
//  MerryGoRound2
//
//  Created by Nikolay Morev on 23/03/16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRListViewController.h"
#import <DropboxSDK/DropboxSDK.h>
#import "AppDelegate.h"
#import "MGRMetadataTableViewCell.h"

@interface MGRListViewController () <DBRestClientDelegate, UITableViewDataSource>

@property (nonatomic, strong) DBRestClient *client;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) DBMetadata *metadata;

@end

@implementation MGRListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"app-logo"]
                        forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.client = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.client.delegate = self;
    [self.client loadMetadata:@"/"];

    [self requestMovies];
}

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    NSLog(@"%@ contents: %@", metadata, metadata.contents);
    self.metadata = metadata;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.metadata.contents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBMetadata *metadata = self.metadata.contents[indexPath.row];

    MGRMetadataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Metadata" forIndexPath:indexPath];
    cell.nameLabel.text = metadata.filename;
    cell.sizeLabel.text = [NSString stringWithFormat:@"%lli", metadata.totalBytes];

    return cell;
}

- (void)requestMovies {
    NSDictionary *parameters = @{ @"s" : @"Batman",
                                  @"page" : @2 };

    NSURLComponents *components = [[NSURLComponents alloc] initWithString:@"http://www.omdbapi.com/"];

    NSMutableArray *queryItems = [NSMutableArray array];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:[NSString stringWithFormat:@"%@", obj]]];
    }];
    components.queryItems = queryItems;

//    components.queryItems = @[ [NSURLQueryItem queryItemWithName:@"s" value:@"Batman"],
//                               [NSURLQueryItem queryItemWithName:@"page" value:@"2"] ];

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];

    NSURL *URL = components.URL;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"GET";

    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@", obj);
        });
    }];
    [task resume];
}

@end
