//
//  MoreViewController.m
//  news
//
//  Created by Perry Xiong on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MoreViewController.h"
#import "AboutViewController.h"
#import "TestServerViewController.h"

@interface MoreViewController()
@property (nonatomic, retain) ASIHTTPRequest *request;

@end


@implementation MoreViewController
@synthesize request = _request;
#pragma mark -
#pragma mark Initialization

/*
 - (id)initWithStyle:(UITableViewStyle)style {
 // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 self = [super initWithStyle:style];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}


/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return  YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (cAdmin) {
        return 3;
    }
    
    return 2;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (!cAdmin) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"About Stylesight News";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 1:
                cell.textLabel.textAlignment = UITextAlignmentCenter;
                cell.textLabel.text = @"Log Out";
                break;    
            default:
                break;
        }
    }else {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"About Stylesight News";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 1:
                cell.textLabel.text = @"Server";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 2:{
				cell.textLabel.textAlignment = UITextAlignmentCenter;
				cell.textLabel.text = @"Log Out";
			}
                break;    
            default:
                break;
        }
    }
    
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!cAdmin) {
        switch (indexPath.row) {
            case 0:{
                AboutViewController *controller = [[AboutViewController alloc] init];
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
            }
                break;
            case 1:
                break;    
            default:
                break;
        }
    }else {
        switch (indexPath.row) {
            case 0:{
                AboutViewController *controller = [[AboutViewController alloc] initWithNibName:@"AboutViewController_iPhone" bundle:nil];
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
            }
                break;
            case 1:{
                TestServerViewController *controller = [[TestServerViewController alloc] initWithNibName:@"TestServerViewController_iPhone" bundle:nil];
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
            }
                break;
            case 2:{
				UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil 
																delegate:self 
													   cancelButtonTitle:@"Cancel" 
												  destructiveButtonTitle:@"Log Out" 
													   otherButtonTitles:nil];
				[as showInView:self.tabBarController.view];
				[as release];
			}
                break;    
            default:
                break;
        }
    }
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark <UIActionSheetDelegate> Methods
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
	switch (buttonIndex) {
		case 0:{
			NSString *urlString = [NSString stringWithFormat:@"%@%@", kServerURL, kLogout];
			self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
			self.request.delegate = self;
			[self.request startSynchronous];
			NSDictionary *result = [[self.request responseString] JSONValue];
			if (nil != result) {
				if ([result objectForKey:@"success"]) {
					//log out successfully
					[[NSNotificationCenter defaultCenter] postNotificationName:kLogOutNotification object:nil];
				}
			}
		}
			break;
		default:
			break;
	}
}
@end
