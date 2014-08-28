//
//  DetailViewController.h
//  AppLinks
//
//  Created by Christine Abernathy on 4/23/14.
//  Copyright (c) 2014 Facebook Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Bolts/BFAppLink.h>
@interface DetailViewController : UIViewController
@property (strong, nonatomic) NSDictionary *detailData;
@property (strong, nonatomic) BFAppLink *appLink;
@end
