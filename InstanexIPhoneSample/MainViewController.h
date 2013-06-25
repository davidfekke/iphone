//
//  MainViewController.h
//  InstanexIPhoneSample
//
//  Created by David P Fekke on 3/16/13.
//  Copyright (c) 2013 David Fekke L.L.C. All rights reserved.
//

#import "FlipsideViewController.h"
#import "LoginViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, LoginViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *UserIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *UserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *FirstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *LastNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) NSString *apiToken;

@end
