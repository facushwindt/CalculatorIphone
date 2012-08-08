//
//  CalculatorBrain.h
//  Calculator
//
//  Created by facundo schwindt on 27/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define OPERATION_PREFIX @“#”
#define VARIABLE_PREFIX @“$”

@interface CalculatorBrain : NSObject
@property (readonly) id program;

-(void)pushOperand:(double)operand;
-(void)pushVariable:(NSString *)variable;
-(double)performOperation:(NSString *)operation;
-(void)clearStack;
-(void)removeLastObject;

+(double)runProgram:(id)program;
+(double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;

+(NSSet *)variablesUsedInProgram:(id)program;

+(NSString *)descriptionOfProgram:(id)program;


@end
