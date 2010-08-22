//
//  TranslateViewController.m
//  Telephone
//
//  Created by Timothy P Miller on 8/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "globals.h"
#import "TranslateViewController.h"
#import "APIController.h"


@implementation TranslateViewController

@synthesize phrase;
@synthesize targetLanguage;
@synthesize languagePicker;
@synthesize submitButton;
@synthesize googleTranslateButton;
@synthesize phraseTextView;
@synthesize selectedRow;
@synthesize languages;

static APIController *apiController = nil;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSLog(@"phrase %@", phrase);
	NSLog(@"languages %@", languages);
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done:)]autorelease];
	
}

- (void)viewWillAppear:(BOOL)animated {
	phraseTextView.text = [phrase objectForKey:@"text"];
}

- (void)done:(id)sender {
	[inputPhrase resignFirstResponder];

}

// UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [languages count];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	NSLog(@"picker row %d component %@", row, component);	
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [[languages objectAtIndex:row] objectForKey:@"name"];
}

- (IBAction)submitButtonSelected:(id)sender {
	NSLog(@"submitButtonSelected");
	selectedRow = [languagePicker selectedRowInComponent:0];
	
	UITextView *inputView = inputPhrase;
	NSLog(@"input phrase: %@", inputView.text);
	
	NSMutableDictionary *translationDict = [NSMutableDictionary dictionary];
	[translationDict setObject:inputView.text forKey:@"text"];
	
	if (!apiController) {
		apiController = [[APIController alloc] init];
	}
	
	NSDictionary *lang = [languages objectAtIndex:selectedRow];
	NSString *code = [lang objectForKey:@"code"];
	
	NSString *path = [NSString stringWithFormat:@"%@/api/translate/%@/%@", SERVER, 
					  [phrase objectForKey:@"id"],
					  code];
	
	NSURL *URL = [NSURL URLWithString:path];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
	
	[request setHTTPMethod:@"POST"];	
	NSData *bodyData = [[translationDict urlQueryString] dataUsingEncoding:NSUTF8StringEncoding];
	[request setHTTPBody:bodyData];

	[apiController connectWithRequest:request 
							   target:self 
							 selector:@selector(processTranslatePostResults:)];
}

- (void)processTranslatePostResults:(NSString *) resultString {
	NSLog(@"received results %@", resultString);
}

- (IBAction)googleTranslateButtonSelected:(id)sender {
	NSLog(@"googleTranslateButtonSelected");
	selectedRow = [languagePicker selectedRowInComponent:0];
	NSLog(@"row: %d", selectedRow);
	
	UITextView *inputView = inputPhrase;
	NSLog(@"input phrase: %@", inputView.text);

	if (!apiController) {
		apiController = [[APIController alloc] init];
	}
	
	NSDictionary *lang = [languages objectAtIndex:selectedRow];
	NSString *code = [lang objectForKey:@"code"];
	NSLog(@"code %@", code);
		
	NSString *path = [NSString stringWithFormat:@"%@/api/translate/%@/%@", SERVER, 
					  [phrase objectForKey:@"id"],
					  code];
	
	NSLog(@"calling %@", path);
	NSURL *URL = [NSURL URLWithString:path];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];		
	[apiController connectWithRequest:request 
							   target:self 
							 selector:@selector(processGoogleTranslateResults:)];		
}

- (void) processGoogleTranslateResults:(NSString *) resultString {
	
	NSLog(@"received results %@", resultString);
	
	id results = [resultString JSONValue];
	NSLog(@"%@", [results description]);
	NSDictionary *resultsDict = [results objectForKey:@"google"];
	NSLog(@"resultsDict %@", resultsDict);
	NSString *translatedText = [resultsDict objectForKey:@"destination_text"];
	NSLog(@"text %@", translatedText);
	inputPhrase.text = translatedText;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
