//
//  PhraseListViewController.h
//  Telephone
//
//  Created by Timothy P Miller on 8/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TranslateViewController.h"

@interface PhraseListViewController : UITableViewController {
	TranslateViewController *translateViewController;
}

@property (nonatomic, retain) TranslateViewController *translateViewController;

@end
