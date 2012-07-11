//
//  RPNCalculatorBrain.m
//  RPNCalculator
//
//  Created by facundo schwindt on 27/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RPNCalculatorBrain.h"
#import "math.h"

@interface RPNCalculatorBrain()
// esto es la declaracion de una variable "mutableArray" llamada operand stack.
@property (nonatomic,strong) NSMutableArray * 
operandStack;
@end

@implementation RPNCalculatorBrain
@synthesize operandStack = _operandStack;

//este es el getter
-(NSMutableArray*) operandStack{
    //inicializo el stack cuando lo voy a usar
    if (!_operandStack) {
        _operandStack=[[NSMutableArray alloc] init];
    }
    return _operandStack;
}

//este es el setter
-(void) setOperandStack:(NSMutableArray *)operandStack{
    _operandStack= operandStack;
}

// agrego un elemento al stack
//tengo que convertir el tipo primitivo a un Objeto
-(void)pushOperand:(double)operand{
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

-(double)popOperand{
    NSNumber *operadorObject = [self.operandStack lastObject];
    if(operadorObject)
        [self.operandStack removeLastObject];
    return [operadorObject doubleValue];
}

-(double)performOperation:(NSString*) operation{
    double result;
    if([operation isEqualToString:@"+"]){
        result = [self popOperand] + [self popOperand];
    }else if([operation isEqualToString:@"-"]){
        double substractor= [self popOperand];
        double subs= [self popOperand];
        result = subs - substractor;
        
    }else if([operation isEqualToString:@"*"]){
        result = [self popOperand] * [self popOperand];
    
    }else if([operation isEqualToString:@"/"]){
        double divisor= [self popOperand];
        result = [self popOperand] / divisor;
    
    }else if([operation isEqualToString:@"cos"]){
        result = cos([self popOperand]);
    
    }else if([operation isEqualToString:@"sin"]){
        result = sin([self popOperand]);
    }
    
    else if([operation isEqualToString:@"sqrt"]){
        result = sqrt([self popOperand]);
    } 
    
    else if([operation isEqualToString:@"π"]){
        result= 3.1416;
    } 
    
    else if([operation isEqualToString:@"+ / -"]){
        result= [self popOperand] * -1;
    } 
    
    [self pushOperand:result];
    return result;
}

-(void)deleteStack{
    [self.operandStack removeAllObjects];
}

@end
