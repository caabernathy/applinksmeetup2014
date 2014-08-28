//
//  DetailViewController.m
//  AppLinks
//
//  Created by Christine Abernathy on 4/23/14.
//  Copyright (c) 2014 Facebook Inc. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "DetailViewController.h"
#import <Bolts/BFAppLinkReturnToRefererView.h>
#import <Bolts/BFAppLinkReturnToRefererController.h>

@interface DetailViewController () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *selectionImageView;
@property (weak, nonatomic) IBOutlet UILabel *selectionLabel;
@property (strong, nonatomic) IBOutlet BFAppLinkReturnToRefererView *appLinkReturnToRefererView;
@property (strong, nonatomic) BFAppLinkReturnToRefererController *appLinkReturnToRefererController;
@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.selectionLabel.text = self.detailData[@"title"];
    self.selectionImageView.image = [UIImage imageNamed:self.detailData[@"imageName"]];

    // Set up the App Links back link controller
    self.appLinkReturnToRefererController = [[BFAppLinkReturnToRefererController alloc] init];
    self.appLinkReturnToRefererController.view = self.appLinkReturnToRefererView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Show the App Links back link if necessary
    if (self.appLink) {
        self.appLinkReturnToRefererView.hidden = NO;
        [self.appLinkReturnToRefererController showViewForRefererAppLink:self.appLink];
    } else {
        self.appLinkReturnToRefererView.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonAction:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareButtonAction:(id)sender {
    // Check if the Facebook app is installed and we can present the share dialog
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];    
    params.link = [NSURL URLWithString:self.detailData[@"url"]];
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        // Present the share dialog
        [FBDialogs presentShareDialogWithLink:params.link
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              NSLog(@"Error publishing story: %@", error.description);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];
    } else {
        // Present the feed dialog
        NSLog(@"Should present the feed dialog, but I won't");
    }
}
@end
