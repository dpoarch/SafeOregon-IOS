//
//  ListViewController.h
//  Sprigeo
//
//  Created by Krunal Doshi on 16/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UITableViewController
{
    IBOutlet UISearchDisplayController *searchDisplayController;
    IBOutlet UISearchBar *searchBar;
    NSArray *allItems;
    NSArray *searchResults;
}

@property (nonatomic,retain) NSArray *allItems;
@property (nonatomic,retain) NSArray *searchResults;

- (void)filterContentForSearchText:(NSString*)searchText
                             scope:(NSString*)scope;
@end
