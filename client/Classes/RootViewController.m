//
//  RootViewController.m
//  Telephone
//
//  Created by Timothy P Miller on 8/21/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "globals.h"

#import "RootViewController.h"
#import "APIController.h"

@implementation RootViewController

@synthesize translateViewController;
@synthesize phraseListViewController;
@synthesize languageListViewController;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Telephone";
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	if (indexPath.section == 0) {
		cell.textLabel.text = @"Sign in";
	} else if (indexPath.section == 1) {
		cell.textLabel.text = @"Translate a phrase";
	} else if (indexPath.section == 2) {
		cell.textLabel.text = @"Create a phrase";
	} else if (indexPath.section == 3) {
		cell.textLabel.text = @"Check a phrase";
	}
	
}

static APIController *apiController = nil;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (!apiController) {
		apiController = [[APIController alloc] init];
	}

    if (indexPath.section == 0) {
	} else if (indexPath.section == 1) {
		
		NSString *path = [NSString stringWithFormat:@"%@/api/languages", SERVER];
		NSLog(@"calling %@", path);
		NSURL *URL = [NSURL URLWithString:path];
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];		
		[apiController connectWithRequest:request 
								   target:self 
								 selector:@selector(processLanguageResults:)];		
	} else if (indexPath.section == 2) {
		NSString *path = [NSString stringWithFormat:@"%@/api/languages", SERVER];
		NSLog(@"calling %@", path);
		NSURL *URL = [NSURL URLWithString:path];
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];		
		[apiController connectWithRequest:request 
								   target:self 
								 selector:@selector(processTranslateResults:)];		

	} else if (indexPath.section == 3) {
	}
}

- (void) processLanguageResults:(NSString *) resultString {
	
	NSLog(@"received results %@", resultString);
	
	id results = [resultString JSONValue];
	NSLog(@"%@", [results description]);
	
	NSArray *languages = [results objectForKey:@"languages"];
	
	languageListViewController = [[LanguageListViewController alloc] init];
	// Pass the selected object to the new view controller.
	languageListViewController.title = @"Select a language";
	languageListViewController.languages = languages;
	
	[self.navigationController pushViewController:languageListViewController animated:YES];
	[languageListViewController release];
}

- (void) processTranslateResults:(NSString *) resultString {
	
	NSLog(@"received results %@", resultString);
	
	id results = [resultString JSONValue];
	NSLog(@"%@", [results description]);
	
	NSArray *languages = [results objectForKey:@"languages"];
	
	createPhraseViewController = [[CreatePhraseViewController alloc] init];
	// Pass the selected object to the new view controller.
	createPhraseViewController.title = @"Create a phrase";
	createPhraseViewController.languages = languages;
	
	[self.navigationController pushViewController:createPhraseViewController animated:YES];
	[createPhraseViewController release];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

