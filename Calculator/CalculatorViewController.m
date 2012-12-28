//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Thomas Ituarte on 11/26/12.
//
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL userHasInputHistory;
@property (nonatomic) int16_t numberOfPreviousInputs;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize inputHistory = _inputHistory;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}


- (IBAction)dotPressed:(id)sender {
    NSRange dotCheck = [self.display.text rangeOfString:@"."];
    
    if (self.userIsInTheMiddleOfEnteringANumber){
        if(dotCheck.location == NSNotFound){
            self.display.text = [self.display.text stringByAppendingString:@"."];
        }
    } else {
        if (dotCheck.location == NSNotFound){
            self.display.text = @".";
            self.userIsInTheMiddleOfEnteringANumber = YES;
        }
    }
}
- (IBAction)clearValues:(UIButton *)sender {
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userHasInputHistory = NO;
    self.numberOfPreviousInputs = 0;
    self.display.text = @"0";
    self.inputHistory.text = @"";
    [self.brain emptyOperandStack];
    
}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = [sender currentTitle];
    if (self.userIsInTheMiddleOfEnteringANumber){
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)enterPressed
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    
    if (self.userHasInputHistory){
        self.numberOfPreviousInputs++;
        self.inputHistory.text = [self.inputHistory.text stringByAppendingString:self.display.text];
        self.inputHistory.text = [self.inputHistory.text stringByAppendingString:@" "];

    } else {
        self.userHasInputHistory = YES;
        self.numberOfPreviousInputs = 1;
        self.inputHistory.text = [self.inputHistory.text stringByAppendingString:self.display.text];
        self.inputHistory.text = [self.inputHistory.text stringByAppendingString:@" "];

    }

    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)operationPressed:(UIButton *)sender
{


    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    
    if (self.userHasInputHistory){
        
        self.numberOfPreviousInputs++;
        if (self.numberOfPreviousInputs > 4){
            self.inputHistory.text = [self.inputHistory.text stringByAppendingString:[sender currentTitle]];
            self.inputHistory.text = [self.inputHistory.text stringByAppendingString:@" "];
            
        }
        self.inputHistory.text = [self.inputHistory.text stringByAppendingString:[sender currentTitle]];
        self.inputHistory.text = [self.inputHistory.text stringByAppendingString:@" "];
        
    } else {
        self.userHasInputHistory = YES;
        self.numberOfPreviousInputs = 1;
        self.inputHistory.text = [self.inputHistory.text stringByAppendingString:[sender currentTitle]];
        self.inputHistory.text = [self.inputHistory.text stringByAppendingString:@" "];
    }
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    
}


@end
