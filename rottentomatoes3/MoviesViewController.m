//
//  MoviesViewController.m
//  rottentomatoes3
//
//  Created by Bharti Agrawal on 6/15/14.
//  Copyright (c) 2014 Yahoo Inc. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "MovieDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"

@interface MoviesViewController ()
{
    UIRefreshControl *refreshControl;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

@end

@implementation MoviesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Movies";
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self loadMovies];
        [self addPullToRefresh];
        //adding sleep to show the loading icon.
        sleep(1);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
    
    
    //[self setRefreshControl:refreshControl];
    
    // Do any additional setup after loading the view from its nib.
}

- (void) loadMovies
{
    NSLog(@"loadMovies");
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=g9au4hv6khv6wzvzgt55gpqs";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError){
            //self.headerLabel.text = @"network error";
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.text = @"network error";
            label.backgroundColor = [UIColor clearColor];
            [label sizeToFit];
            
            //could not get this to work.
            //[self.tableView.viewForHeaderInSection label];
        }
        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        //NSLog(@"%@", object);
        self.movies = object[@"movies"];
        
        [self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
        
        self.tableView.rowHeight = 150;
        
        [self.tableView reloadData];
    }];
}

- (void) addPullToRefresh
{
    NSLog(@"addPullToRefresh");
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshView) forControlEvents:UIControlEventValueChanged];
    
    NSMutableAttributedString *refreshString = [[NSMutableAttributedString alloc] initWithString:@"Pull To Refresh"];
    [refreshString addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:NSMakeRange(0, refreshString.length)];
    refreshControl.attributedTitle = refreshString;
    
    [self.tableView addSubview:refreshControl];
    
}

- (void) refreshView
{
    NSLog(@"refreshView");
    [self loadMovies];
    [refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View methods
- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"cellForRowAtIndexPath: %d", indexPath.row);
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    NSDictionary *movie = self.movies[indexPath.row];
    
    cell.movieTitleLabel.text = movie[@"title"];
    cell.movieSynopsisLabel.text = movie[@"synopsis"];
    
    NSString *imageUrl = movie[@"posters"][@"thumbnail"];
    NSURL *url = [NSURL URLWithString:imageUrl];
    
    [cell.posterView setImageWithURL:url];
    //UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];

    //[cell.posterView setImage:image];
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath: %d", indexPath.row); // you can see selected row number in your console;
    
    NSDictionary *movie = self.movies[indexPath.row];
    NSString *movieUrl = movie[@"posters"][@"original"];
    NSString *movieDetail = movie[@"synopsis"];
    NSString *movieTitle = movie[@"title"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:movieUrl forKey:@"movieUrl"];
    [defaults setObject:movieDetail forKey:@"movieDetail"];
    [defaults setObject:movieTitle forKey:@"movieTitle"];
    [defaults synchronize];
    
    [self.navigationController pushViewController:[[MovieDetailViewController alloc] init] animated:YES];
}

@end
