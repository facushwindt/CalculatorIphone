//
//  CalculatorViewController.m
//  Calculator
//
//  Created by facundo schwindt on 27/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "Control.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfTypingANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSDictionary *testVariableValues;
@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize descriptionOfProgramDisplay = _descriptionOfProgramDisplay;
@synthesize descriptionOfVariablesDisplay = _descriptionOfVariablesDisplay;
@synthesize userIsInTheMiddleOfTypingANumber = _userIsInTheMiddleOfTypingANumber;
@synthesize testVariableValues = _testVariableValues;
@synthesize brain = _brain;

-(CalculatorBrain *)brain{
    if (!_brain) {
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"GraphicSegue"]){
        [segue.destinationViewController DrawInView:[self.brain program]];
    }
    
}

-(Control*)SplitViewControl{
    id c = [self.splitViewController.viewControllers lastObject];
    if([c isKindOfClass:[Control class]]){
        return c;
    }
    return nil;
}

- (IBAction)ButtonGrafics:(UIButton *)sender {
    //tengo que saber si estoy en Ipad o Iphone por
    if([self SplitViewControl]){ //ipad
        [[self SplitViewControl]DrawInView:[self.brain program]];
    } else{
        [self performSegueWithIdentifier:@"GraphicSegue" sender:self];
    }
}

-(void)updateDescriptionOfProgram{
    self.descriptionOfProgramDisplay.text = [CalculatorBrain descriptionOfProgram:[self.brain program]];
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    //NSLog(@"presiono: %@", digit);
    
    // llenar el display
    if (self.userIsInTheMiddleOfTypingANumber) {
       
        NSRange range = [self.display.text rangeOfString:@"."];
        if (!([digit isEqualToString:@"."] && (range.location != NSNotFound))){
            self.display.text =  [self.display.text stringByAppendingString:digit];  
        }
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfTypingANumber = YES;
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfTypingANumber = NO;
    [self updateDescriptionOfProgram];
}

- (IBAction)operationPressed:(UIButton *)sender {
    if(self.userIsInTheMiddleOfTypingANumber)[self enterPressed];
    double result = [self.brain performOperation:[sender currentTitle]];
    NSString *resultText = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultText;
    [self updateDescriptionOfProgram];
}
- (IBAction)variablePressed:(UIButton *)sender {
    [self.brain pushVariable:sender.currentTitle];
    [self updateDescriptionOfProgram];
}

- (IBAction)controlPressed:(UIButton *)sender {
    if ([[sender currentTitle] isEqualToString:@"C"]) {
        [self.brain clearStack];
        self.display.text = @"";
    } else if ([[sender currentTitle] isEqualToString:@"+/-"]){
        if (self.userIsInTheMiddleOfTypingANumber){
            double displayValue = [self.display.text doubleValue];
            displayValue *= -1;
            self.display.text = [NSString stringWithFormat:@"%g", displayValue];            
        } else {
            [self operationPressed:sender];            
        }
    } else if ([[sender currentTitle] isEqualToString:@"⇦"]){
        if (self.userIsInTheMiddleOfTypingANumber){
            NSString *displayText = self.display.text;
            displayText = [displayText substringToIndex:[displayText length] -1];
            if ([displayText length]) self.display.text = displayText;
            else {
                self.display.text = @"0";
                self.userIsInTheMiddleOfTypingANumber = NO;
            }
        } else {
            [self.brain removeLastObject];
        } 
    }
    [self updateDescriptionOfProgram];
}

- (void)viewDidUnload {
    [self setDescriptionOfProgramDisplay:nil];
    [self setDescriptionOfVariablesDisplay:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


@end
