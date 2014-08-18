//
//  TweetViewController.m
//  TweetSearch
//
//  Created by Ruthwick Pathireddy on 8/16/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "TweetViewController.h"
#import "AppDelegate.h"
#import "Tweet.h"

@interface TweetViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
// Outlets to UIControls
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UISlider *batchSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortSegmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TweetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    // Creates fetchedResultsController and performs fetch
    [self initializeFetchResultsController];
    self.fetchedResultsController.delegate = self;
    [self performFetchOnDifferentQueue];
}

// Lazy instantiation
- (NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        _managedObjectContext = appDelegate.managedObjectContext;
    }
    return _managedObjectContext;
}

#pragma mark - Control Buttons

// Displays only tweets located in a certain map area
- (IBAction)filterByMapButtonPressed {
}

// Get called when slider moves to certain value
// Controls batch value for the fetchedResultsController
- (IBAction)movedBatchSlider:(UISlider *)sender {
    [NSFetchedResultsController deleteCacheWithName:self.fetchedResultsController.cacheName];
    [self.fetchedResultsController.fetchRequest setFetchBatchSize:sender.value];
    [self performFetchOnDifferentQueue];
}

// Action when user returns textField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Removes keyboard when return is pressed
    [textField resignFirstResponder];
    
    // Displays tweets containing the string
    [NSFetchedResultsController deleteCacheWithName:self.fetchedResultsController.cacheName];
    NSString *searchText = [[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""] ? @"" : textField.text;
    NSPredicate *predicate = ![searchText isEqualToString:@""] ? [NSPredicate predicateWithFormat:@"content CONTAINS %@", searchText] : nil;
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    [self performFetchOnDifferentQueue];
    return YES;
}

// Action determines whether to sort Tweets by newest or oldest
- (IBAction)sortTweetsChanged:(UISegmentedControl *)sender
{
    [NSFetchedResultsController deleteCacheWithName:self.fetchedResultsController.cacheName];
    BOOL ascending = sender.selectedSegmentIndex == 0 ? NO : YES;
    self.fetchedResultsController.fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"timestamp"
                                                                                                 ascending:ascending]];
    [self performFetchOnDifferentQueue];

}

// Performs the fetch on a different queue
- (void)performFetchOnDifferentQueue
{
    dispatch_queue_t fetchQ = dispatch_queue_create("fetchQ", NULL);
    dispatch_async(fetchQ, ^{
        [self performFetch];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Tweet Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    self.detailViewController.detailItem = object;
}

// Configures cell for tableview
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Tweet *tweet = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = tweet.content;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", tweet.timestamp];
}


#pragma mark - Fetched results controller

// Initializes the NSFetchedResultsController to the following request
- (void)initializeFetchResultsController
{
    // Makes a request for the given entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tweet"];
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"timestamp"
                                                              ascending:NO]];
    request.fetchBatchSize = self.batchSlider.value;

    // Creates a fetchedResultsController
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

// Performs fetch for the fetchedResultsController
- (void)performFetch
{
    if (self.fetchedResultsController) {
        NSError *error;
        BOOL success = [self.fetchedResultsController performFetch:&error];
        if (!success) NSLog(@"[%@ %@] performFetch: failed", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        if (error) NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
    }
}



#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex
	 forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}



@end
