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
@property (nonatomic,copy) NSAttributedString *attributedText;
@property (weak, nonatomic) IBOutlet UIImageView *movieDetailView;
@property (weak, nonatomic) IBOutlet UILabel *movieDetailLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *textScrollView;
@property (weak, nonatomic) IBOutlet UIView *labelImageView;

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
    
    //initialize and allocate your scroll view
    self.textScrollView = [[UIScrollView alloc]
                         initWithFrame:CGRectMake(0, 0,
                                                  self.view.frame.size.width,
                                                  self.view.frame.size.height)];
    
    //set the scroll view delegate to self so that we can listen for changes
    self.textScrollView.delegate = self;
    //add the subview to the scroll view
    //[self.textScrollView addSubview:movieDetailLabel];
    // Do any additional setup after loading the view from its nib.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *movieUrl = [defaults stringForKey:@"movieUrl"];
    NSString *movieDetail = [defaults stringForKey:@"movieDetail"];
    NSString *movieTitle = [defaults stringForKey:@"movieTitle"];
    
    NSURL *url = [NSURL URLWithString:movieUrl];
    UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    [self.movieDetailView addSubview:[[UIImageView alloc] initWithImage:image]];
    
    NSString *detail = movieTitle;
    detail = [detail stringByAppendingFormat:@"\n\n %@",movieDetail];
    NSLog(@"detail: %@", detail);
    //self.movieDetailLabel.text = detail;
    self.title = movieTitle;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:detail];
    
    //NSAttributedString *title;
    UIFont *titleFont = [UIFont fontWithName:@"Helvetica-Bold" size:24];
    [attributedString addAttribute:NSFontAttributeName value:titleFont range:NSMakeRange(0, [movieTitle length])];
    
    self.movieDetailLabel.attributedText = attributedString;
    //self.scrollView.contentSize = self.labelImageView.image.size;
}

- (void)viewWillAppear:(BOOL)animated {

   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
