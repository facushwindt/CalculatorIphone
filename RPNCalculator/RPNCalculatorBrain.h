//
//  RPNCalculatorBrain.h
//  RPNCalculator
//
//  Created by facundo schwindt on 27/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPNCalculatorBrain : NSObject

-(void)pushOperand:(double)operand;
-(double)performOperation:(NSString*) operation;
-(void)deleteStack;


@end
