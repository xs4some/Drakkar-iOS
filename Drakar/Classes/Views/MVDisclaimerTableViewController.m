//
//  MVDisclaimerTableViewController.m
//  Mobile Vikings
//
//  Created by Hendrik Bruinsma on 18/03/14.
//  Copyright (c) 2014 XS4some. All rights reserved.
//

#import "MVDisclaimerTableViewController.h"

#import "MVAppDelegate.h"

@interface MVDisclaimerTableViewController ()

@property (nonatomic, strong) NSDictionary *tableData;

- (void)loadData;

@end

@implementation MVDisclaimerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadData];
    
    self.title = self.tableData[@"Title"];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Menu", @"Menu button caption") style:UIBarButtonItemStylePlain target:self action:@selector(showMenu)];
    self.navigationItem.leftBarButtonItem = menuButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *itemDictionary = [self.tableData[@"PreferenceSpecifiers"] objectAtIndex:indexPath.section];
    
    NSString *textForCell = [itemDictionary objectForKey:@"FooterText"];
    CGSize constraintSize = CGSizeMake(280.0f, CGFLOAT_MAX);
    
    CGRect rect = [textForCell boundingRectWithSize:constraintSize
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]}
                                            context:nil];
    
    return rect.size.height + 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.tableData[@"PreferenceSpecifiers"] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *itemDictionary = [self.tableData[@"PreferenceSpecifiers"] objectAtIndex:section];
    return [itemDictionary objectForKey:@"Title"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"DisclaimerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *itemDictionary = [self.tableData[@"PreferenceSpecifiers"] objectAtIndex:indexPath.section];
    
    cell.textLabel.text = [itemDictionary objectForKey:@"FooterText"];
    
    return cell;
}

#pragma mark - class methods

- (void)showMenu {
    [ApplicationDelegate.deckController toggleLeftViewAnimated:YES];
}

- (void)loadData {
    self.tableData = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Acknowledgements" ofType:@"plist"]];
}

@end
