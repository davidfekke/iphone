//
//  MainViewController.m
//  InstanexIPhoneSample
//
//  Created by David P Fekke on 3/16/13.
//  Copyright (c) 2013 David Fekke L.L.C. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //
    //self.logoutButton.enabled = NO;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];

    self.apiToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"ApiToken"];
    NSString *accessKey = [[NSUserDefaults standardUserDefaults] stringForKey:@"AccessKey"];
    //NSString *expireDateString = [[NSUserDefaults standardUserDefaults] stringForKey:@"expDate"];
    //NSDate *expireDate = [expireDateString da]
    
    //NSDate *start = [NSDate date];
    //NSTimeInterval timeInterval = [start timeIntervalSinceNow];
    //double tokenExp = [[[NSUserDefaults standardUserDefaults] stringForKey:@"tokenExp"] doubleValue];
    
    //if the tokenExp count is smaller than the current timeInterval then revoke the token.
    //if (([expireDate compare:start]) == NSOrderedDescending ) {
    //    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"ApiToken"];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    //    self.apiToken = nil;
    //}
    
    if (self.apiToken) {
        NSError *myErr = nil;
        NSArray *tokenArray = [self.apiToken componentsSeparatedByString:@"."];
        NSString *bas64Payload = tokenArray[1];
        NSData *payloadData = [NSData dataWithBase64EncodedString:bas64Payload];
        NSDictionary *payloadDict = [NSJSONSerialization JSONObjectWithData:payloadData options:NSJSONReadingMutableContainers error:&myErr];
        
        self.UserIDLabel.text = [payloadDict valueForKey:@"http://schemas.instanext.services.api/identity/claims/userid"];
        self.UserNameLabel.text = [payloadDict valueForKey:@"http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"];
        self.FirstNameLabel.text = [payloadDict valueForKey:@"http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname"];
        self.LastNameLabel.text = [payloadDict valueForKey:@"http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname"];
    } else if (accessKey) {
        //[self performSegueWithIdentifier:@"loginSegue" sender:self];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [vc setModalPresentationStyle:UIModalPresentationFullScreen];
        
        //[self presentViewController:vc animated:YES completion:NULL];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)resetUserDefaults:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"ApiToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.apiToken = nil;
    self.UserIDLabel.text = nil;
    self.UserNameLabel.text = nil;
    self.FirstNameLabel.text = nil;
    self.LastNameLabel.text = nil;
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginViewControllerDidFinish:(LoginViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    } else if ([[segue identifier] isEqualToString:@"loginSegue"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

@end
