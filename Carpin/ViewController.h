//
//  ViewController.h
//  Carpin
//
//  Created by Stuart Farmer on 4/16/15.
//  Copyright (c) 2015 Stuart Farmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *setPin;
@property (strong, nonatomic) IBOutlet UIButton *locateCar;
@property (strong, nonatomic) IBOutlet UIButton *resetPin;

- (IBAction)setPinPressed:(id)sender;
- (IBAction)locateCarPressed:(id)sender;
- (IBAction)resetPinPressed:(id)sender;


@end

