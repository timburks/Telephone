//
//  TranslateViewController.h
//  Telephone
//
//  Created by Timothy P Miller on 8/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TranslateViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate> {
	IBOutlet id phrase;
	IBOutlet UITextView *inputPhrase;
	IBOutlet id targetLanguage;
	IBOutlet UIPickerView *languagePicker;
	IBOutlet UIButton *submitButton;
	IBOutlet UIButton *googleTranslateButton;
	IBOutlet UITextView *phraseTextView;
	NSInteger selectedRow;
	id languages;
}

@property (nonatomic, retain) id phrase;
@property (nonatomic, retain) UITextView *inputPhrase;
@property (nonatomic, retain) id targetLanguage;
@property (nonatomic, retain) UIPickerView *languagePicker;
@property (nonatomic, retain) UIButton *submitButton;
@property (nonatomic, retain) UIButton *googleTranslateButton;
@property (nonatomic, retain) UITextView *phraseTextView;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, retain) id languages;

- (IBAction)submitButtonSelected:(id)sender;
- (IBAction)googleTranslateButtonSelected:(id)sender;

@end
