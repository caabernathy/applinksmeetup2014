//
//  ViewController.m
//  AppLinksEventsFrameworkTest
//
//  Created by Christine Abernathy on 8/11/14.
//  Copyright (c) 2014 Facebook Inc. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import <Bolts/Bolts.h>

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)linkClickAction:(id)sender {
    NSURL *link;
    NSDictionary *backLink;
    // Bird
    if ([sender tag] == 200) {
        link = [NSURL URLWithString:@"https://fb.me/643486985725899"];
        backLink = @{
                     @"target_url": @"https://myapplinktest.parseapp.com/bird",
                     @"url": @"measureapplinks://bird",
                     @"app_name": @"Measure App Links"
                     };
    }
    // Dog
    else {
        link = [NSURL URLWithString:@"https://fb.me/643402985734299"];
        backLink = @{
                     @"target_url": @"https://myapplinktest.parseapp.com/dog",
                     @"url": @"measureapplinks://dog",
                     @"app_name": @"Measure App Links"
                     };
    }
    
    
    // Navigate to the app's URL and pass in the return info
    [self _navigateToLink:link backLink:backLink];
}

- (void)_navigateToLink:(NSURL *)url backLink:(NSDictionary*)backLink {
    [[BFAppLinkNavigation resolveAppLinkInBackground:url] continueWithSuccessBlock:^id(BFTask *task) {
        BFAppLink *link = task.result;
        // Add referer and back link info
        NSDictionary *appLinkData =
        @{
          @"referer_app_link": backLink
          };
        
        BFAppLinkNavigation *navigation
        = [BFAppLinkNavigation navigationWithAppLink:link
                                              extras:nil
                                         appLinkData:appLinkData];
        
        NSError *error = nil;
        [navigation navigate:&error];
        return task;
    }];
}

@end
