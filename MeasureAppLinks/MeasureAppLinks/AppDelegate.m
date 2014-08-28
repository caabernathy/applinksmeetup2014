//
//  AppDelegate.m
//  AppLinksEventsFrameworkTest
//
//  Created by Christine Abernathy on 8/11/14.
//  Copyright (c) 2014 Facebook Inc. All rights reserved.
//

#import "AppDelegate.h"

#import <Parse/Parse.h>
#import <Bolts/Bolts.h>
#import <ParseAppLinksAnalytics/ParseAppLinksAnalytics.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [Parse setApplicationId:@"bPz84xBZAOsxy2DnOWMkpYbJBWJKk8ywgIEIsaXd"
                  clientKey:@"ypZ4SDy32Ot4vpf1MwWN2Ku43fRbOVoEhN5aKiG8"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Enable Parse Analytics for App Links
    [PAAnalytics enableTracking];
    
    return YES;
}
							
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // To trigger inbound event measurement
    [BFURL URLWithInboundURL:url sourceApplication:sourceApplication];
    return YES;
}

@end
