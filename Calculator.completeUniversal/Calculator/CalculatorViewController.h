//
//  CalculatorViewController.h
//  Calculator
//
//  Created by facundo schwindt on 27/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *descriptionOfProgramDisplay;
@property (weak, nonatomic) IBOutlet UILabel *descriptionOfVariablesDisplay;

@end
