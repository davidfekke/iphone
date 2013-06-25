//
//  FlipsideViewController.m
//  InstanexIPhoneSample
//
//  Created by David P Fekke on 3/16/13.
//  Copyright (c) 2013 David Fekke L.L.C. All rights reserved.
//

#import "FlipsideViewController.h"

@interface FlipsideViewController ()

@end

@implementation FlipsideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.accessKey.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"AccessKey"];
    self.serverURL.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"ServerURL"];
    self.secretKey.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"SecretKey"];
    if (!self.accessKey.text) {
        self.accessKey.text = @"";
    }
    if (!self.serverURL.text) {
        self.serverURL.text = @"https://api.instanexdev.com";
    }
    if (!self.secretKey.text) {
        self.secretKey.text = @"";
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self setFieldsToUserDefaults];
    [self.delegate flipsideViewControllerDidFinish:self];
    
}
- (IBAction)saveHandler:(id)sender {
    [self setFieldsToUserDefaults];
}

- (void)setFieldsToUserDefaults {
    [[NSUserDefaults standardUserDefaults] setValue:self.accessKey.text forKey:@"AccessKey"];
	[[NSUserDefaults standardUserDefaults] setValue:self.serverURL.text forKey:@"ServerURL"];
	[[NSUserDefaults standardUserDefaults] setValue:self.secretKey.text forKey:@"SecretKey"];
	
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.accessKey resignFirstResponder];
        [self.serverURL resignFirstResponder];
        [self.secretKey resignFirstResponder];
    }
}

@end
