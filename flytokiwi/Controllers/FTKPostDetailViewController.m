//
//  FTKPostDetailViewController.m
//  flytokiwi
//
//  Created by Q on 14-10-6.
//  Copyright (c) 2014年 zwq. All rights reserved.
//

#import "FTKPostDetailViewController.h"

@interface FTKPostDetailViewController ()

@property (nonatomic,strong) UIWebView *postDetailWebView;

@end

@implementation FTKPostDetailViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"init nib called");
//        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"收藏" style:UIBarButtonItemStylePlain target:self action:nil];
//        self.navigationItem.rightBarButtonItem = bbi;
    }
    return self;
}

- (void)loadView {
    self.postDetailWebView = [[UIWebView alloc] init];
    self.view = self.postDetailWebView;
//    self.postDetailWebView.scalesPageToFit = YES;
}

//- (void)setPostURL:(NSURL *)postURL {
//    _postURL = postURL;
//    if (_postURL) {
//        NSURLRequest *req = [NSURLRequest requestWithURL:_postURL];
//        [self.postDetailWebView loadRequest:req];
//    }
//}

//- (void)setPostContent:(NSString *)postContent {
//    _postContent = postContent;
//    if (_postContent) {
//        [self.postDetailWebView loadHTMLString:postContent baseURL:nil];
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.postDetailWebView loadHTMLString:self.postContent baseURL:nil];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:_postURL];
    [self.postDetailWebView loadRequest:req];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
