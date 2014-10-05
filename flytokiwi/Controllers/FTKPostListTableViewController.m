//
//  FTKPostListTableViewController.m
//  flytokiwi
//
//  Created by Q on 14-10-5.
//  Copyright (c) 2014年 zwq. All rights reserved.
//

#import "FTKPostListTableViewController.h"
#import "FTKDataManager.h"

@interface FTKPostListTableViewController () <NSURLSessionDataDelegate>
{
    UIRefreshControl *refreshControl;
}

@property (strong,nonatomic) NSArray *posts;

@property (strong,nonatomic) NSURLSession *session;

@end

@implementation FTKPostListTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.navigationItem.title = @"文章列表";
        self.posts = [NSArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(pullToRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    [self fetchData];
    
}

- (void)fetchData
{
    __block NSArray *jsonObject;
    //    NSString *requestSting = @"http://flytokiwi.com/blog/wp-json/posts";
    NSString *requestSting = @"http://flytokiwi.com/blog/wp-json/posts";
    
    NSURL *url = [NSURL URLWithString:requestSting];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([jsonObject isKindOfClass:[NSArray class]]) {
            NSLog(@"%lu jsonObj",jsonObject.count);
            NSLog(@"array");
            self.posts = jsonObject;

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
            //            NSLog(@"%@",jsonObject);
        }
        
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            NSLog(@"%@",jsonObject);
            NSLog(@"dict");
        }
    }];
    [dataTask resume];
//    return jsonObject;
}

- (void)pullToRefresh
{
//    self.posts = [[FTKDataManager sharedData] fetchData];
//    [self.posts arrayByAddingObjectsFromArray:[[FTKDataManager sharedData] fetchData]];

    [self.tableView reloadData];
    [refreshControl endRefreshing];
}

# pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%lu",(unsigned long)self.posts.count);
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *post = self.posts[indexPath.row];
    cell.textLabel.text = post[@"title"];
    cell.textLabel.numberOfLines = 0;
    
    cell.detailTextLabel.text = post[@"excerpt"];
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    NSLog(@"%@",post[@"excerpt"]);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

@end
