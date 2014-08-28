//
//  ViewController.m
//  AppLinks
//
//  Created by Christine Abernathy on 4/23/14.
//  Copyright (c) 2014 Facebook Inc. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "ViewController.h"
#import "DetailViewController.h"

@interface ViewController ()
@property (strong, nonatomic) NSArray *selectionData;
@property (strong, nonatomic) BFAppLink *backAppLink;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // The data that's used to set up the detail view
    self.selectionData = @[@{@"title": @"Cat",  @"imageName": @"cat",  @"url": @"https://myapplinktest.parseapp.com/cat.html"},
                           @{@"title": @"Dog",  @"imageName": @"dog",  @"url": @"https://fb.me/643402985734299"},
                           @{@"title": @"Bird", @"imageName": @"bird", @"url": @"https://fb.me/643486985725899"}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailViewController *detailViewController = (DetailViewController*) segue.destinationViewController;
    NSInteger selectionIndex = [[segue identifier] integerValue];
    // Set up the detail view data
    [detailViewController setDetailData:self.selectionData[selectionIndex]];
    if (nil != self.backAppLink) {
        // Set up the detail view app link
        [detailViewController setAppLink:self.backAppLink];
        // Only one shot at seeing the back link view
        self.backAppLink = nil;
    }    
}

/*
 * Method to initiate a deep link to the detail view controller
 */
- (void)goToDetail:(NSString*)selection backAppLink:(BFAppLink *)backAppLink {
    // Save any incoming back app link
    self.backAppLink = backAppLink;
    // Look for the proper segue to trigger, based on the incoming
    // "selection" string.
    for (NSInteger i=0; i < [self.selectionData count]; i++) {
        if ([[self.selectionData[i][@"title"] lowercaseString] isEqualToString:[selection lowercaseString]]) {
            NSString *segueId = [NSString stringWithFormat:@"%ld", (long)i];
            [self performSegueWithIdentifier:segueId sender:self];
            break;
        }
    }
}

@end
