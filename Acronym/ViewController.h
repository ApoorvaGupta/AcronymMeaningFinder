//
//  ViewController.h
//  Acronym
//
//  Created by Apoorva Gupta on 5/1/16.
//  Copyright © 2016 Apoorva Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *resultsArray;
}

@property (weak, nonatomic) IBOutlet UITableView *acronymTableView;


@end

