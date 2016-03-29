//
//  TutorialController.m
//  Linkage
//
//  Created by Mac mini on 16/2/25.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "TutorialController.h"
#import "LoginViewController.h"

@interface TutorialController ()<ICETutorialControllerDelegate>
@property (nonatomic, strong, readonly) UIButton *centerButton;

@end

@implementation TutorialController

+(instancetype)shareViewController
{
    // Init the pages texts, and pictures.
    ICETutorialPage *layer1 = [[ICETutorialPage alloc] initWithTitle:@"Picture 1"
                                                            subTitle:@"第一页"
                                                         pictureName:@"tutorial_background_00@2x.jpg"
                                                            duration:3.0];
    ICETutorialPage *layer2 = [[ICETutorialPage alloc] initWithTitle:@"Picture 2"
                                                            subTitle:@"第二页"
                                                         pictureName:@"tutorial_background_01@2x.jpg"
                                                            duration:3.0];
    ICETutorialPage *layer3 = [[ICETutorialPage alloc] initWithTitle:@"Picture 3"
                                                            subTitle:@"第三页"
                                                         pictureName:@"tutorial_background_02@2x.jpg"
                                                            duration:3.0];
    ICETutorialPage *layer4 = [[ICETutorialPage alloc] initWithTitle:@"Picture 4"
                                                            subTitle:@"第四页"
                                                         pictureName:@"tutorial_background_03@2x.jpg"
                                                            duration:3.0];
    NSArray *tutorialLayers = @[layer1,layer2,layer3,layer4];
    
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
    TutorialController *controller = [[self alloc] initWithPages:tutorialLayers];
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
    [self.centerButton setBackgroundColor:[UIColor darkGrayColor]];
    [self.centerButton setTitle:@"跳过" forState:UIControlStateNormal];
    [self.centerButton addTarget:self
                          action:@selector(skipAction:)
                forControlEvents:UIControlEventTouchUpInside];
    self.centerButton.frame = CGRectMake(((self.pages.count - 1) * self.view.frame.size.width),
                                                                      self.view.frame.size.height - 65,
                                                                      self.view.frame.size.width,
                                                                      TUTORIAL_LABEL_HEIGHT);
    
    
    [self.scrollView addSubview:self.centerButton];

}

#pragma mark - ICETutorialController delegate
- (void)tutorialController:(ICETutorialController *)tutorialController scrollingFromPageIndex:(NSUInteger)fromIndex toPageIndex:(NSUInteger)toIndex {
    NSLog(@"Scrolling from page %lu to page %lu.", (unsigned long)fromIndex, (unsigned long)toIndex);
}

- (void)tutorialControllerDidReachLastPage:(ICETutorialController *)tutorialController {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)skipAction:(id)sender
{
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    [self presentViewController:loginVC animated:YES completion:^{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UserDefault_hasShowIntroduce];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
}

@end
