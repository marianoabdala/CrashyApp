//
//  CRSViewController.m
//  CrashyApp
//
//  Created by Mariano Abdala on 7/21/13.
//  Copyright (c) 2013 Zerously.com. All rights reserved.
//

#import "CRSViewController.h"

@interface CRSViewController ()

- (IBAction)crashButtonTapped:(id)sender;

@end

@implementation CRSViewController

- (IBAction)crashButtonTapped:(id)sender {
    
    abort();
}

@end
