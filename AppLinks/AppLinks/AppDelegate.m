//
//  AppDelegate.m
//  AppLinks
//
//  Created by Christine Abernathy on 4/23/14.
//  Copyright (c) 2014 Facebook Inc. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Bolts/Bolts.h>
#import "ViewController.h"

@interface AppDelegate()
@property (strong, nonatomic) NSString *deepLinkInfo;
@property (strong, nonatomic) BFURL *parsedUrl;
@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Parse the incoming link to check for deep link info
    self.deepLinkInfo = nil;
    BFURL *parsedUrl = [BFURL URLWithInboundURL:url
                              sourceApplication:sourceApplication];
    self.parsedUrl = parsedUrl;
    NSString *targetUrlString = [url absoluteString];
    // Use the target URL from the App Link to locate content.
    // This app's URL is in the format:
    // applinktest://<animal>?target_url=<target_url_encoded>
    // Example:
    // applinktest://cat?target_url=https%3A%2F%2Fmyapplinktest.parseapp.com%2Fcat.html
    if ([targetUrlString.pathComponents[0] isEqualToString:@"applinktest:"]) {
        // Look
        if (targetUrlString.pathComponents[1]) {
            NSArray *info = [targetUrlString.pathComponents[1] componentsSeparatedByString:@"?"];
            self.deepLinkInfo = info[0];
        }
    }
    // Handle any Facebook-related incoming links, ex: from
    // login or the share dialog
    BOOL urlWasHandled =
    [FBAppCall handleOpenURL:url
           sourceApplication:sourceApplication
             fallbackHandler:nil];
    return urlWasHandled;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FBLoginView class];
    [BFAppLinkReturnToRefererView class];
    
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBAppCall handleDidBecomeActive];
    
    // Handle deep link from 3rd party apps
    if (self.deepLinkInfo) {
        // Find the root view controller (ViewController)
        ViewController *vc = (ViewController *) self.window.rootViewController;
        // Dismiss any view controller currently being presented
        if (vc.presentedViewController) {
            [vc dismissViewControllerAnimated:NO completion:nil];
        }
        // Call the deep linking method
        [vc goToDetail:self.deepLinkInfo backAppLink:[self.parsedUrl appLinkReferer]];
    }
    self.deepLinkInfo = nil;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [FBSession.activeSession close];
}

@end
