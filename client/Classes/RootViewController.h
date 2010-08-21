//
//  RootViewController.h
//  Telephone
//
//  Created by Timothy P Miller on 8/21/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TranslateViewController.h"
#import "PhraseListViewController.h"
#import "LanguageListViewController.h"

@interface RootViewController : UITableViewController {
	TranslateViewController *translateViewController;
	PhraseListViewController *phraseListViewController;
	LanguageListViewController *languageListViewController;
}

@property (nonatomic, retain) TranslateViewController *translateViewController;
@property (nonatomic, retain) PhraseListViewController *phraseListViewController;
@property (nonatomic, retain) LanguageListViewController *languageListViewController;

@end
