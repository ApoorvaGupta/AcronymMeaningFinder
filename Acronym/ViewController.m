//
//  ViewController.m
//  Acronym
//
//  Created by Apoorva Gupta on 5/1/16.
//  Copyright © 2016 Apoorva Gupta. All rights reserved.
//

#import "ViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "AFNetworking.h"

#define apiURL @"http://www.nactem.ac.uk/software/acromine/dictionary.py"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchDisplayController.searchBar.placeholder = @"Enter Acronym";
    resultsArray = [[NSMutableArray alloc]init];
    self.acronymTableView.delegate = self;
    self.acronymTableView.dataSource = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (void)handleSearchForSearchString:(NSString *)searchString {
//    [self fetchMeaningsForAcronym:searchString];
//    
//   }

-(void) fetchMeaningsForAcronym: (NSString *) acronym {
    
    NSDictionary *parameters = @{@"sf": acronym};
    
    AFHTTPSessionManager *operation1 = [AFHTTPSessionManager manager];
    operation1.securityPolicy.allowInvalidCertificates = YES;
    operation1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    operation1.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    [operation1 GET:apiURL parameters:parameters progress:nil success:^(NSURLSessionTask *operation, id responseObject)
     {
         NSLog(@"response: %@",responseObject);
         if([responseObject isKindOfClass:[NSArray class]] && [[responseObject valueForKey:@"lfs"] count] > 0 ){
             for(NSDictionary *dict in responseObject){
                 
                 NSLog(@"%u",[[[dict [@"lfs"] allObjects] valueForKey:@"lf"] count ]);
                 for(int i =0; i< [[[dict [@"lfs"] allObjects] valueForKey:@"lf"] count ] ; i++)
                 {
                     [resultsArray addObject:[NSString stringWithFormat:@"%@",[[[dict [@"lfs"] allObjects] valueForKey:@"lf"]objectAtIndex:i]]];
                 }
                 
                 [self.searchDisplayController.searchResultsTableView reloadData];
            }
             
         }
         NSLog(@"%@",resultsArray);
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }failure:^(NSURLSessionTask *operation, NSError *error) {
         NSLog(@"error %@",error);
         NSLog(@"%@",operation.response);
         
     }];
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [resultsArray removeAllObjects];
    [self.searchDisplayController.searchResultsTableView reloadData];
    [self fetchMeaningsForAcronym:searchBar.text];
    
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    [resultsArray removeAllObjects];
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
  //  [self handleSearchForSearchString:searchString];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [resultsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if([resultsArray count ] > 0)
    cell.textLabel.text = [resultsArray objectAtIndex:indexPath.row];
    
    // Display recipe in the table cell
        return cell;
}

@end
