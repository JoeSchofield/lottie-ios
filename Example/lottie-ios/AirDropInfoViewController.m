//
//  AirDropInfoViewController.m
//  lottie-ios
//
//  Created by Joe Schofield on 4/26/17.
//  Copyright © 2017 Brandon Withrow. All rights reserved.
//

#import "AirDropInfoViewController.h"
#import "AnimationExplorerViewController.h"
#import <Lottie/Lottie.h>

@interface AirDropInfoViewController ()
@property (nonatomic, strong) LOTAnimationView *lottieLogo;
@property (nonatomic, strong) UIButton *lottieButton;
@property (strong, nonatomic) IBOutlet UILabel *lottieLabel;
@property (nonatomic, assign) CGRect lottieRect;
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;
@end

@implementation AirDropInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lottieLogo = [LOTAnimationView animationNamed:@"LottieLogo1"];
    self.lottieLogo.contentMode = UIViewContentModeScaleAspectFill;
    [self.lottieLabel addSubview:self.lottieLogo];
    
    self.lottieRect = self.lottieLabel.bounds;
    self.lottieLogo.frame = self.lottieRect;
    
    self.versionLabel.text = @"Using version 1.5.1";
    
    self.lottieLogo.animationProgress = 0;
    [self.lottieLogo playWithCompletion:^(BOOL animationFinished) {
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.lottieLogo play];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.lottieLogo pause];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.lottieLogo.frame = self.lottieRect;
}

- (IBAction)tappedViewPrevious:(id)sender {
    AnimationExplorerViewController *vc = [[AnimationExplorerViewController alloc] init];
    vc.showExplorerOnStart = YES;
    [self presentViewController:vc animated:YES completion:^{
        NSLog(@"presented");
    }];
}

- (IBAction)tappedSomethingNewer:(id)sender {
        NSURL *url = [NSURL URLWithString:@"https://github.com/airbnb/lottie-ios/releases"];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
}

@end
