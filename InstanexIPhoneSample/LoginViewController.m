//
//  LoginViewController.m
//  InstanexIPhoneSample
//
//  Created by David P Fekke on 3/16/13.
//  Copyright (c) 2013 David Fekke L.L.C. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.progressIndicator.hidden = YES;
    self.cancelButton.titleLabel.text = @"Cancel";
	// Do any additional setup after loading the view.
    self.UsernameTextField.text = @"";
    self.PasswordTextField.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginAction:(id)sender
{
    NSString *appKey = [[NSUserDefaults standardUserDefaults] stringForKey:@"AccessKey"];
    NSString *ServerURL = [[NSUserDefaults standardUserDefaults] stringForKey:@"ServerURL"];
    NSString *SecretKey = [[NSUserDefaults standardUserDefaults] stringForKey:@"SecretKey"];
    
    if (appKey)
    {
        self.progressIndicator.hidden = NO;
        [self.progressIndicator startAnimating];
        dispatch_queue_t myQueue = dispatch_queue_create("get auth", NULL);
        dispatch_async(myQueue, ^{
            InstanexAccess *dataAccess = [[InstanexAccess alloc] initWithAccessKey:appKey andSecretKey:SecretKey andBaseURL:ServerURL];
            NSData *dataResult = [dataAccess getAuthorizationWithUsername:self.UsernameTextField.text password:self.PasswordTextField.text];
            NSError *myErr = nil;
            
            NSDictionary *myDict = [NSJSONSerialization JSONObjectWithData:dataResult options:NSJSONReadingMutableContainers error:&myErr];

            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSUserDefaults standardUserDefaults] setValue:[myDict valueForKey:@"ApiToken"] forKey:@"ApiToken"];

                [[NSUserDefaults standardUserDefaults] synchronize];
                [self.progressIndicator stopAnimating];
                self.progressIndicator.hidden = YES;
                if ([myDict valueForKey:@"ApiToken"]) {
                    [self dismissViewControllerAnimated:YES completion:NULL];
                    [self.delegate loginViewControllerDidFinish:self];
                } else {
                    self.warningLabel.text = @"User name or password was incorrect!";
                }
                
                
            });
            // Ending main queue
        });
        // End myQueue
        //dispatch_release(myQueue);
        
    }
    
}
- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self.delegate loginViewControllerDidFinish:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.UsernameTextField resignFirstResponder];
        [self.PasswordTextField resignFirstResponder];
    }
}

@end
