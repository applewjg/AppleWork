//
//  CalculatorBrain.m
//  Hope
//
//  Created by Jingui Wang on 11/22/16.
//  Copyright © 2016 jinguiwang. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *numberStack;
@end

@implementation CalculatorBrain

@synthesize numberStack = _numberStack;
@synthesize currentOperation = _currentOperation;
- (NSMutableArray *)numberStack
{
    // We use the getter for a lazy instantiation (we wait until the last moment for initializing something)
    if(_numberStack == nil)
    {
        _numberStack = [[NSMutableArray alloc] init];
    }
    return _numberStack;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.currentOperation = NONE;
    }
    
    return self;
}

- (void)pushNumber:(float)number
{
    NSNumber *numberObjectWrapper = [NSNumber numberWithFloat:number];
    [self.numberStack addObject:numberObjectWrapper];
}

- (void)resetCalculator
{
    // Removes anything from the stack
    [self.numberStack removeAllObjects];
}

-(float)popNumber
{
    // returns zero if there is no object
    NSNumber *operandNumber = [self.numberStack lastObject];
    if(operandNumber != nil)
    {
        [self.numberStack removeLastObject];
    }
    return [operandNumber floatValue];
}

- (float)performOperation
{
    float result = self.popNumber;
    switch (self.currentOperation) {
        case ADD:
            //Asking for 1 cos' that means there is another number to operate with.
            if (self.numberStack.count == 1)
            {
                result = [self performSumA:self.popNumber plusB:result];
            }
            break;
        case SUB:
            if (self.numberStack.count == 1)
            {
                result = [self performSubstractionA:self.popNumber minusB:result];
            }
            break;
        case DIV:
        {
            result = [self performDivisionA:self.popNumber byB:result];
        }
            break;
        case MUL:
        {
            result = [self performMultiplicationA:self.popNumber byB:result];
        }
            break;
        case NONE:
            // no operation selected yet
            break;
    }
    
    // We push the result in our stack because we want to continue operating over that number when another operation comes in
    [self pushNumber:result];
    return result;
}

- (float)performSumA:(float)a plusB:(float)b
{
    return a + b;
}

- (float)performSubstractionA:(float)a minusB:(float)b
{
    return a - b;
}

- (float)performMultiplicationA:(float)a byB:(float)b
{
    return a * b;
}

- (float)performDivisionA:(float)a byB:(float)b
{
    if(b == 0)
    {
        // reset calculator state then raise exception. Error must be handled by external view.
        [NSException raise:@"Div by zero" format:@"Can not divide by zero"];
    }
    return a / b;
}

@end
