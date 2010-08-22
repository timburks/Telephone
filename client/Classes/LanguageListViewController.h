//
//  LanguageListViewController.h
//  Telephone
//
//  Created by Timothy P Miller on 8/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhraseListViewController.h"
#import "APIController.h"

@interface LanguageListViewController : UITableViewController {
	PhraseListViewController *phraseListViewController;
	id languages;
	APIController *apiController;
}

@property (nonatomic, retain) PhraseListViewController *phraseListViewController;
@property (nonatomic, retain) id languages;
@property (nonatomic, retain) APIController *apiController;

@end
