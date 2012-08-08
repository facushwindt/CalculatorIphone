//
//  CalculatorBrain.m
//  Calculator
//
//  Created by facundo schwindt on 27/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain
@synthesize programStack = _programStack;

+ (BOOL)isOperationWithOneOperand:(NSString *)operation{
    NSSet *set=[NSSet setWithObjects:@"sin",@"cos",@"sqrt", @"+/-", nil];
    return [set containsObject:operation];
}

+(BOOL)noArgumentsOperation:(NSString *)operation{
    NSSet *noArgumentsOperation=[NSSet setWithObjects:@"π", nil];
    if ([noArgumentsOperation containsObject:operation]) return YES;
    return NO;
}

+(BOOL)isUnaryOperation:(NSString *)operation{
    NSSet *unaryOperation=[NSSet setWithObjects:@"sin",@"cos",@"sqrt", @"+/-", nil];
    if ([unaryOperation containsObject:operation]) return YES;
    return NO;
}

+(BOOL)isBinaryOperation:(NSString *)operation{
    NSSet *binaryOperation=[NSSet setWithObjects:@"+",@"-",@"*", @"/", nil];
    if ([binaryOperation containsObject:operation]) return YES;
    return NO;
}

+(BOOL)isOperation:(NSString *)operation{
    if ([self isOperationWithOneOperand:operation] ||
        [self isUnaryOperation:operation] ||
        [self isBinaryOperation:operation]){
        return YES;
    }
    return NO;
}

+(BOOL)isVariable:(NSString*)variable{
    if (![self isOperation:variable]) return YES;
    return NO;
}

+(double)popStack:(NSMutableArray*)stack{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    }else if ([topOfStack isKindOfClass:[NSString class]]){
        if ([self isOperation:topOfStack]) {
            // its an operation!
            NSString *operation = topOfStack;
            if ([operation isEqualToString:@"+"]) {
                result = [self popStack:stack] + [self popStack:stack];
            } else if ([@"-" isEqualToString:operation]){
                double temp = [self popStack:stack];
                result = [self popStack:stack] - temp;        
            } else if ([@"*" isEqualToString:operation]){
                result = [self popStack:stack] * [self popStack:stack];        
            } else if ([@"/" isEqualToString:operation]){
                double temp = [self popStack:stack];
                result = [self popStack:stack] / temp;        
            } else if ([@"+/-" isEqualToString:operation]){
                result = ([self popStack:stack] * -1);        
            } else if ([@"sin" isEqualToString:operation]){
                result = sin([self popStack:stack]);        
            } else if ([@"cos" isEqualToString:operation]){
                result = cos([self popStack:stack]);        
            } else if ([@"sqrt" isEqualToString:operation]){
                result = sqrt([self popStack:stack]);        
            } 
        }
    }
    return result;
}

-(NSMutableArray *)programStack{
    if (!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

-(id)program{
    return [self.programStack copy];
}

-(void)pushOperand:(double)operand{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

-(void)pushVariable:(NSString *)variable{
    [self.programStack addObject:variable];
}

-(double)performOperation:(NSString *)operation{
    [self.programStack addObject:operation];
    return  [CalculatorBrain runProgram:self.program];
}

-(void)clearStack{
    self.programStack = nil;
}

-(void)removeLastObject{
    id topOfStack = [self.programStack lastObject];
    if (topOfStack) [self.programStack removeLastObject];
}

+(double)runProgram:(id)program{
    NSMutableArray *stack;
    
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popStack:stack];    
}

+(double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues{
    NSMutableArray *stack;
    
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
        for (int i=0; i<stack.count; i++) {
            id obj = [stack objectAtIndex:i];
            if ([obj isKindOfClass:[NSString class]]) {
                if ([self isVariable:obj]) {
                    if([variableValues objectForKey:obj]){
                        [stack replaceObjectAtIndex:i withObject:[variableValues objectForKey:obj]];
                    } else {
                        [stack replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:0.0]];
                    }
                }
            }
        }    
    }
    
    return [self popStack:stack];    
}

+(NSSet *)variablesUsedInProgram:(id)program{
	BOOL isNull = YES;
	NSMutableSet *mset = [NSMutableSet set];
	
    if ([program isKindOfClass:[NSArray class]]) {
        for (id obj in program){
            if ([obj isKindOfClass:[NSString class]]) {
                if ([self isVariable:obj]) {
                    [mset addObject:obj];
                    isNull = NO;                
                }
            }
        }
    }
	if (isNull) mset=nil;
	return mset;
}

+(NSString *)removeExtraneousParenthesis:(NSString *)expr{
    NSString *result = expr;
    if ([expr hasPrefix:@"("] && [expr hasSuffix:@")"]) {
        result = [expr substringWithRange:NSMakeRange(1, [expr length]-2)];
        if ([result rangeOfString:@"("].location > [result rangeOfString:@")"].location)
            return expr;
    }
    return result;
}

+(NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack{
    NSString *result;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack description];
    } else if ([topOfStack isKindOfClass:[NSString class]]){
        if ([self isOperation:topOfStack]) {
            // its an operation!
            NSString *operation = topOfStack;
            if ([self noArgumentsOperation:operation]) {
                result = operation;
            } else if ([self isUnaryOperation:operation]){
                result = [NSString stringWithFormat: @"%@(%@)", operation, 
                          [self removeExtraneousParenthesis:[self descriptionOfTopOfStack:stack]]];
            } else if ([self isBinaryOperation:operation]){
                NSString *oper2 = [self descriptionOfTopOfStack:stack];
                NSString *oper1 = [self descriptionOfTopOfStack:stack];
                if ([operation isEqualToString:@"*"] || [operation isEqualToString:@"/"]){
                    result = [NSString stringWithFormat: @"%@ %@ %@", oper1, operation, oper2];                    
                } else {
                    result = [NSString stringWithFormat: @"(%@ %@ %@)",   
                    [self removeExtraneousParenthesis:oper1], operation, [self removeExtraneousParenthesis:oper2]];                    

                }
            }
        } else if ([self isVariable:topOfStack]){
            result = topOfStack;
        }
    }
    return result;
}
 
+(NSString *)descriptionOfProgram:(id)program{
    NSMutableArray *stack;
    NSMutableArray *multipleGroup = [NSMutableArray array];
    
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    while (stack.count > 0) {
        [multipleGroup addObject:[self removeExtraneousParenthesis:[self descriptionOfTopOfStack:stack]]];
    }
    
    return [multipleGroup componentsJoinedByString:@", "];    
}

@end
