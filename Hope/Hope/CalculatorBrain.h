//
//  CalculatorBrain.h
//  Hope
//
//  Created by Jingui Wang on 11/22/16.
//  Copyright © 2016 jinguiwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

typedef enum
{
    ADD,
    SUB,
    DIV,
    MUL,
    NONE
} operation;

@property (nonatomic) operation currentOperation;

- (void)resetCalculator;
- (void)pushNumber:(float)number;
- (float)popNumber;
- (float)performOperation;
- (float)performSumA:(float)a
               plusB:(float)b;
- (float)performSubstractionA:(float)a
                       minusB:(float)b;
- (float)performDivisionA:(float)a
                      byB:(float)b;
- (float)performMultiplicationA:(float)a
                            byB:(float)b;

@end
