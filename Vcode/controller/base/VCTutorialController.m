//
//  VCTutorialController.m
//  Linkage
//
//  Created by Mac mini on 2017/1/3.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCTutorialController.h"
#import "VCTabBarController.h"
@interface VCTutorialController ()<ICETutorialControllerDelegate>
@property (nonatomic, strong, readonly) UIButton *centerButton;

@end

@implementation VCTutorialController

+(instancetype)shareViewController
{
    // Init the pages texts, and pictures.
    ICETutorialPage *layer1 = [[ICETutorialPage alloc] initWithTitle:@""
                                                            subTitle:@""
                                                         pictureName:@"start1"
                                                            duration:3.0];
    ICETutorialPage *layer2 = [[ICETutorialPage alloc] initWithTitle:@""
                                                            subTitle:@""
                                                         pictureName:@"start2"
                                                            duration:3.0];
    ICETutorialPage *layer3 = [[ICETutorialPage alloc] initWithTitle:@""
                                                            subTitle:@""
                                                         pictureName:@"start3"
                                                            duration:3.0];
    NSArray *tutorialLayers = @[layer1,layer2,layer3];
    
    // Set the common style for the title.
    ICETutorialLabelStyle *titleStyle = [[ICETutorialLabelStyle alloc] init];
    [titleStyle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0f]];
    [titleStyle setTextColor:[UIColor whiteColor]];
    [titleStyle setLinesNumber:1];
    [titleStyle setOffset:180];
    [[ICETutorialStyle sharedInstance] setTitleStyle:titleStyle];
    
    // Set the subTitles style with few properties and let the others by default.
    [[ICETutorialStyle sharedInstance] setSubTitleColor:[UIColor whiteColor]];
    [[ICETutorialStyle sharedInstance] setSubTitleOffset:150];
    
    // Init tutorial.
    VCTutorialController *controller = [[self alloc] initWithPages:tutorialLayers];
    [controller setDelegate:controller];
    return controller;
}

-(instancetype)initWithPages:(NSArray *)pages
{
    self = [super initWithPages:pages];
    if (self) {
        _centerButton = [[UIButton alloc] init];
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
}

-(void)setupUI
{
}

#pragma mark - ICETutorialController delegate
- (void)tutorialController:(ICETutorialController *)tutorialController scrollingFromPageIndex:(NSUInteger)fromIndex toPageIndex:(NSUInteger)toIndex {
    NSLog(@"Scrolling from page %lu to page %lu.", (unsigned long)fromIndex, (unsigned long)toIndex);
}

- (void)tutorialControllerDidReachLastPage:(ICETutorialController *)tutorialController {
    [self skipAction:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)skipAction:(id)sender
{
    VCTabBarController *controller = [[VCTabBarController alloc]init];
    [self presentViewController:controller animated:YES completion:^{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UserDefault_hasShowIntroduce];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
}

@end
