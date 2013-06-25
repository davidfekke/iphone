//
//  FlipsideViewController.h
//  InstanexIPhoneSample
//
//  Created by David P Fekke on 3/16/13.
//  Copyright (c) 2013 David Fekke L.L.C. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *accessKey;
@property (weak, nonatomic) IBOutlet UITextField *serverURL;
@property (weak, nonatomic) IBOutlet UITextField *secretKey;

- (IBAction)done:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *saveHandler;

@end
