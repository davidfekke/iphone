//
//  LoginViewController.h
//  InstanexIPhoneSample
//
//  Created by David P Fekke on 3/16/13.
//  Copyright (c) 2013 David Fekke L.L.C. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstanexAccess.h"

@class LoginViewController;

@protocol LoginViewControllerDelegate
- (void)loginViewControllerDidFinish:(LoginViewController *)controller;
@end

@interface LoginViewController : UIViewController

@property (weak, nonatomic) id <LoginViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *UsernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *PasswordTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressIndicator;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end
