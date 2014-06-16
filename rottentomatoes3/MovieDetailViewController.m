//
//  MovieDetailViewController.m
//  rottentomatoes3
//
//  Created by Bharti Agrawal on 6/15/14.
//  Copyright (c) 2014 Yahoo Inc. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "MovieCell.h"

@interface MovieDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *movieDetailView;
@property (weak, nonatomic) IBOutlet UILabel *movieDetailLabel;
- (IBAction)onDrag:(id)sender;

@end

@implementation MovieDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *movieUrl = [defaults stringForKey:@"movieUrl"];
    NSString *movieDetail = [defaults stringForKey:@"movieDetail"];
    NSString *movieTitle = [defaults stringForKey:@"movieTitle"];
    
    NSURL *url = [NSURL URLWithString:movieUrl];
    UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    [self.movieDetailView addSubview:[[UIImageView alloc] initWithImage:image]];
    self.movieDetailLabel.text = movieDetail;
    self.title = movieTitle;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onDrag:(id)sender {
    NSLog(@"onDrag");
}
@end
