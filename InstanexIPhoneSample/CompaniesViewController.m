//
//  CompaniesViewController.m
//  InstanexIPhoneSample
//
//  Created by David P Fekke on 3/16/13.
//  Copyright (c) 2013 David Fekke L.L.C. All rights reserved.
//

#import "CompaniesViewController.h"

@interface CompaniesViewController ()

@end

@implementation CompaniesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor]; //[UIColor colorWithRed:117/255.0f green:4/255.0f blue:32/255.0f alpha:1];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    NSString *appKey = [[NSUserDefaults standardUserDefaults] stringForKey:@"AccessKey"];
    NSString *ServerURL = [[NSUserDefaults standardUserDefaults] stringForKey:@"ServerURL"];
    NSString *SecretKey = [[NSUserDefaults standardUserDefaults] stringForKey:@"SecretKey"];
    NSString *apiToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"ApiToken"];
    
    //self.companies = [[NSMutableArray alloc] initWithArray:nil];
    if (appKey && apiToken)
    {
        dispatch_queue_t myQueue = dispatch_queue_create("get company list", NULL);
        dispatch_async(myQueue, ^{
            InstanexAccess *dataAccess = [[InstanexAccess alloc] initWithAccessKey:appKey andSecretKey:SecretKey andBaseURL:ServerURL];
            self.companies = [dataAccess getCompanies];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            // Ending main queue
        });
        // End myQueue
        
    }
        // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.companies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSMutableDictionary *dict = [self.companies objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict valueForKey:@"Name"];
    cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"Id: %@", [dict valueForKey:@"Id"]];
    
    return cell;
}

- (void)tableView: (UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    cell.backgroundColor = [UIColor darkGrayColor];
    cell.contentView.backgroundColor = [UIColor darkGrayColor];
    //indexPath.row % 2
    //? [UIColor colorWithRed: 0.0 green: 0.0 blue: 1.0 alpha: 1.0]
    //: [UIColor darkGrayColor];
    //cell.textLabel.backgroundColor = [UIColor whiteColor];
    //cell.detailTextLabel.backgroundColor = [UIColor lightGrayColor];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
