//
//  FTKPostListTableViewController.m
//  flytokiwi
//
//  Created by Q on 14-10-5.
//  Copyright (c) 2014年 zwq. All rights reserved.
//

#import "FTKPostListTableViewController.h"
#import "FTKDataManager.h"
#import "FTKPostDetailViewController.h"

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
        self.posts = [NSArray array];
        self.navigationItem.title = @"文章列表";
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

// refactor:需要解耦至Models，待修改
- (void)fetchData
{
    __block NSArray *jsonObject;
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
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.text = post[@"excerpt"];
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    NSLog(@"%@",post[@"excerpt"]);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *post = self.posts[indexPath.row];
    FTKPostDetailViewController *postDetailVC = [[FTKPostDetailViewController alloc] init];
//    postDetailVC.postContent = post[@"content"];
//    postDetailVC.postURL = [NSURL URLWithString:post[@"link"]];
    postDetailVC.postURL = [NSURL URLWithString:@"http://bbs.jjwxc.net/showmsg.php?board=20&boardpagemsg=1&id=233263"];
    postDetailVC.navigationItem.title = post[@"title"];
    [self.navigationController pushViewController:postDetailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

@end
