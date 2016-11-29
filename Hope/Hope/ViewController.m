//
//  ViewController.m
//  Hope
//
//  Created by Jingui Wang on 11/21/16.
//  Copyright © 2016 jinguiwang. All rights reserved.
//

#import "ViewController.h"
#import "CalculatorBrain.h"

// This is a space where you can create private variables.
@interface ViewController ()
@property (nonatomic) BOOL enteringNumber;
@property (nonatomic) BOOL decimalPointEntered;
@property (nonatomic, strong) NSMutableArray *exprStack;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation ViewController

@synthesize display = _display;
@synthesize clearButton = _clearButton;
@synthesize enteringNumber = _enteringNumber;
@synthesize decimalPointEntered = _decimalPointEntered;

- (NSMutableArray *)exprStack
{
    // We use the getter for a lazy instantiation (we wait until the last moment for initializing something)
    if(_exprStack == nil)
    {
        _exprStack = [[NSMutableArray alloc] init];
    }
    return _exprStack;
}

- (CalculatorBrain *)brain
{
    // Lazy initialization (instead of creating a constructor)
    if(_brain == nil)
    {
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.display.text = @"0";
    self.enteringNumber = NO;
    self.decimalPointEntered = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clearPressed:(UIButton *)sender
{
    if (![self.display.text isEqualToString:@"0"])
    {
        self.display.text = @"0";
        [self.clearButton setTitle:@"AC" forState:UIControlStateNormal];
        self.enteringNumber = NO;
    }
    else
    {
        self.brain.currentOperation = NONE;
        self.decimalPointEntered = NO;
        [self.brain resetCalculator];
    }
}

- (IBAction)decimalPointPressed:(UIButton *)sender
{
    if (!self.decimalPointEntered)
    {
        if (self.enteringNumber == NO) {
            self.display.text = @"0";
        }
        self.enteringNumber = YES;
        self.decimalPointEntered = YES;
        self.display.text = [self.display.text stringByAppendingString:@"."];
        [self.clearButton setTitle:@"C" forState:UIControlStateNormal];
    }
    
    NSLog(@"Decimal point pressed");
}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = sender.currentTitle; // [sender currentTitle];
    
    // Debugging trick: send to the console, %i integer %d double, etc. %@ for objects
    // @"" this is a constant string.
    // This is how you call functions (don't get confused with methods or messages). In general, you use Objective-C methods when talking to objects and function when working with straight C goop.
    
    NSLog(@"Digit pressed = %@", digit); //This is calling a C function like; that's why it is not as a message.
    
    // the "text" property (in this case the getter) for any UILabel will return the string of the title.
    // USE dot notation when calling properties. And message notation when calling methods of an object with arguments.
    if (self.enteringNumber)
    {
        self.display.text = [self.display.text stringByAppendingString:digit]; // [myDisplay setText:newText];
    }
    else
    {   // Avoid leadig zeroes in integer numbers
        if (![digit isEqualToString:@"0"])
        {
            self.display.text = digit;
            self.enteringNumber = YES;
        }
        else
        {
            self.display.text = digit;
            
        }
        [self.clearButton setTitle:@"C" forState:UIControlStateNormal];
    }
}

- (IBAction)enterPressed:(UIButton *)sender
{
    if (self.enteringNumber)
    {
        // Reseting calculator for a new operation
        [self.brain pushNumber:[self.display.text floatValue]];
        self.enteringNumber = NO;  // [self setEnteringNumber:NO]; as a message it calls the hidden setter created by @synthesize
        self.display.text =  [NSString stringWithFormat:@"%g", self.brain.performOperation];
        self.brain.currentOperation = NONE;
        self.decimalPointEntered = NO;
        [self.brain resetCalculator];
    }
}

- (IBAction)operationPressed:(UIButton *)sender
{
    [self.brain pushNumber:[self.display.text floatValue]];
    self.enteringNumber = NO;
    self.decimalPointEntered = NO;
    [self.clearButton setTitle:@"C" forState:UIControlStateNormal];
    
    if (self.brain.currentOperation != NONE)
    {
        // If there was already a previous operation in progress retrieve the result of that.
        self.display.text =  [NSString stringWithFormat:@"%g", self.brain.performOperation];
    }
    
    
    if ([sender.currentTitle isEqualToString:@"+"])
    {
        self.brain.currentOperation = ADD;
    }
    else if ([sender.currentTitle isEqualToString:@"-"])
    {
        self.brain.currentOperation = SUB;
    }
    else if ([sender.currentTitle isEqualToString:@"/"])
    {
        self.brain.currentOperation = DIV;
    }
    else if ([sender.currentTitle isEqualToString:@"x"])
    {
        self.brain.currentOperation = MUL;
    }
    
    /* NSLog(@"Operation pressed = %@", sender.currentTitle);
     double result = [self.brain performOperation:sender.currentTitle];
     NSString *resultString = [NSString stringWithFormat:@"%g", result];
     self.display.text = resultString; */
}

@end
