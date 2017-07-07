//
//  FCViewController.m
//  FCImageEditor
//
//  Created by FlyCatkin on 07/07/2017.
//  Copyright (c) 2017 FlyCatkin. All rights reserved.
//

#import "FCViewController.h"
#import "FCImageEditorViewController.h"

@interface FCViewController ()<FCImageEditorViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation FCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)click:(id)sender {
    FCImageEditorViewController *imgaeEditorVC = [[FCImageEditorViewController alloc] initWith:self.imageView.image];
    imgaeEditorVC.delegate = self;
    [self presentViewController:imgaeEditorVC animated:YES completion:^{
        
        
    }];
}

#pragma mark - FCImageEditorViewControllerDelegate

- (void)imageEditorViewControllerDidCancel:(FCImageEditorViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageEditorViewControllerDidFinish:(FCImageEditorViewController *)viewController image:(UIImage *)image
{
    self.imageView.image = image;
    [viewController dismissViewControllerAnimated:YES completion:nil];
    
}

@end
