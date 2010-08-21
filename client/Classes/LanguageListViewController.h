//
//  LanguageListViewController.h
//  Telephone
//
//  Created by Timothy P Miller on 8/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhraseListViewController.h"

@interface LanguageListViewController : UITableViewController {
	PhraseListViewController *phraseListViewController;
}

@property (nonatomic, retain) PhraseListViewController *phraseListViewController;

@end
