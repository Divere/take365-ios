//
//  SDEViewController.m
//  SDE SmartHome
//
//  Created by Evgeniy Eliseev on 10.12.14.
//  Copyright (c) 2014 Evgeniy Eliseev. All rights reserved.
//

#import "PMBaseViewController.h"
#import <objc/runtime.h>

@interface PMBaseViewController ()

@end

@implementation PMBaseViewController
{
    NSMutableArray *maTextFields;
    double currentMovement;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    //[self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    maTextFields = [NSMutableArray new];
    
    for(NSString *prop in [self allPropertyNames])
    {
        id value = [self valueForKey:prop];
        if([value isKindOfClass:[UITextField class]])
        {
            UITextField *tf = (UITextField*)value;
            [tf setDelegate:self];
            [self applyBorderLessStyleForTextField:tf WithColor:[UIColor blackColor]];
            [self applyBorderLessStyleForTextField:tf WithColor:[UIColor blackColor]];
            [maTextFields addObject:tf];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismissKeyboard];
}

-(void)dismissKeyboard {
    for(UITextField *tf in maTextFields)
    {
        [tf endEditing:YES];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self applyBorderLessStyleForTextField:textField WithColor:[UIColor redColor]];
    [self animateTextField: textField up: YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self applyBorderLessStyleForTextField:textField WithColor:[UIColor blackColor]];
    [self animateTextFieldDown];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    double ypos = [textField convertPoint:textField.frame.origin toView:nil].y;
    double delta = self.view.frame.size.height + 35 - textField.frame.size.height*2 - ypos;
    
    if(delta < 0)
    {
        currentMovement = -delta;
    }
    else
        currentMovement = 0;

    [UIView animateWithDuration:0.3f animations:^{
        self.view.bounds = CGRectOffset(self.view.bounds, 0, currentMovement);
    }];
}

-(void)animateTextFieldDown
{
    if(currentMovement > 0)
    {
        [UIView animateWithDuration:0.3f animations:^{
            self.view.bounds = CGRectOffset(self.view.bounds, 0, -currentMovement);
        }];
    }
}

- (NSArray *)allPropertyNames
{
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableArray *rv = [NSMutableArray array];
    
    unsigned i;
    for (i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        [rv addObject:name];
    }
    
    free(properties);
    
    
    return rv;
}

- (void)applyBorderLessStyleForTextField:(UITextField*)tf WithColor:(UIColor*)color
{
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, tf.frame.size.height - 1, tf.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = color.CGColor;
    [tf.layer addSublayer:bottomBorder];
}

@end
