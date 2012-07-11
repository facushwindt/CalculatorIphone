//
//  RPNCalculatorViewController.m
//  RPNCalculator
//
//  Created by facundo schwindt on 26/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RPNCalculatorViewController.h"
#import "RPNCalculatorBrain.h"

@interface RPNCalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfTypingANumber;
@property (nonatomic, strong) RPNCalculatorBrain *brain;
@end

@implementation RPNCalculatorViewController
@synthesize display = _display;
@synthesize pressedDisplay = _pressedDisplay; 
@synthesize userIsInTheMiddleOfTypingANumber = _userIsInTheMiddleOfTypingANumber;
@synthesize brain = _brain;

- (RPNCalculatorBrain *) brain{
    if(!_brain){
        _brain = [[RPNCalculatorBrain alloc] init];
    }
    return _brain;
}

- (IBAction)digitPress:(UIButton *) sender {
    NSString *digit = [sender currentTitle];
    NSLog(@"presiono: %@",digit); 
    self.pressedDisplay.text= [self.pressedDisplay.text stringByAppendingString:digit];

    // llenar el display
    if (self.userIsInTheMiddleOfTypingANumber) {
        self.display.text= [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text= digit;
        self.userIsInTheMiddleOfTypingANumber=YES;
    }
    
}

- (IBAction)operationPressed:(id)sender {
    if(self.userIsInTheMiddleOfTypingANumber)[self enterPressed];
    double result= [self.brain performOperation:[sender currentTitle]];
    NSString *resulText = [NSString stringWithFormat:@"%g", result];//double->String
    self.display.text= resulText;
    if (![[sender currentTitle]isEqual:@"π"] ) {
        self.pressedDisplay.text= [self.pressedDisplay.text stringByAppendingString:[[sender currentTitle] stringByAppendingString: [@" = " stringByAppendingString:[resulText stringByAppendingString:@" "]]]];
    }else {
        self.pressedDisplay.text= [self.pressedDisplay.text stringByAppendingString:[[sender currentTitle] stringByAppendingString:@" "]];
    }
    
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfTypingANumber=NO;
    self.pressedDisplay.text= [ self.pressedDisplay.text stringByAppendingString:@" " ];
}
- (IBAction)dotPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    NSLog(@"presiono: %@",digit);
    NSRange a = [self.display.text rangeOfString:@"."];
    if( a.length == 0 ){
            // llenar el display
            if (self.userIsInTheMiddleOfTypingANumber) {
                self.display.text= [self.display.text stringByAppendingString:digit];
                self.pressedDisplay.text= [self.pressedDisplay.text stringByAppendingString:digit];
                
            } else {
                self.display.text= [@"0" stringByAppendingString:digit];
                self.pressedDisplay.text= [@"0" stringByAppendingString:digit];
                self.userIsInTheMiddleOfTypingANumber=YES;
            }
    }
}
- (IBAction)deletePressed {
    self.pressedDisplay.text = @" ";
    [self.brain deleteStack];
    self.display.text = @"0";
    self.userIsInTheMiddleOfTypingANumber=NO;
}
- (IBAction)BackPressed {
    if (self.userIsInTheMiddleOfTypingANumber) {
        if([self.display.text length] > 0){
            NSUInteger lengthDisplay =  [self.display.text length];
            NSUInteger lengthPressedDisplay =  [self.pressedDisplay.text length];
            
            self.display.text= [self.display.text substringToIndex:lengthDisplay -1];
            self.pressedDisplay.text= [self.pressedDisplay.text substringToIndex:lengthPressedDisplay -1];
            
            if (lengthDisplay==1) {
                self.display.text=@"0";
                self.userIsInTheMiddleOfTypingANumber=NO;
            }
            if (lengthPressedDisplay==1) {
                self.pressedDisplay.text=@"";
                }
        }
    }
}


- (void)viewDidUnload {
    [self setPressedDisplay:nil];
    [super viewDidUnload];
}
@end
