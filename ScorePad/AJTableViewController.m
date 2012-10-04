//
//  AJTableViewController.m
//  ScorePad
//
//  Created by Anca Calugar on 10/4/12.
//  Copyright (c) 2012 Anca Julean. All rights reserved.
//

#import "AJTableViewController.h"

@interface AJTableViewController ()

- (void)addKeyboardNotifications;
- (void)removeKeyboardNotifications;

@end


@implementation AJTableViewController

@synthesize tableView = _tableView;

- (id)initWithStyle:(UITableViewStyle)tableViewStyle
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:tableViewStyle];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:_tableView];
        [_tableView release];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addKeyboardNotifications];
}

- (void)dealloc {
    [_tableView setDelegate:nil];
    [_tableView setDataSource:nil];
    
    [self removeKeyboardNotifications];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark -
#pragma mark Keyboard State Management

- (void)addKeyboardNotifications {
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification
											   object:nil];
    
    /*[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardDidShow:)
												 name:UIKeyboardDidShowNotification
											   object:nil];*/
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
}


- (void)keyboardWillShow:(NSNotification *)aNotif {
    NSDictionary *userInfo = [aNotif userInfo];
	NSTimeInterval keyboardAnimDuration = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	UIViewAnimationCurve keyboardAnimCurve = [[userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntValue];
	CGRect keyboardFrameBegin = [self.view convertRect:[[userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue] fromView:nil];
	CGRect keyboardFrameEnd = [self.view convertRect:[[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    
	// If the keyboard will slide horizontally then we don't want any animation to be done.
	// We only want animation when the keyboard will slide to/from bottom
	BOOL keyboardSlidesVeritcally = (keyboardFrameBegin.origin.y != keyboardFrameEnd.origin.y);
	
	if (keyboardSlidesVeritcally) {
        
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationCurve:keyboardAnimCurve];
		[UIView setAnimationDuration:keyboardAnimDuration];
		[UIView setAnimationBeginsFromCurrentState:YES];
        
	}
    
    CGRect tableViewBounds = self.tableView.frame;
	tableViewBounds.size.height = self.view.bounds.size.height - keyboardFrameEnd.size.height;
    self.tableView.frame = tableViewBounds;
    
    if (keyboardSlidesVeritcally) {
		[UIView commitAnimations];
	}
}

- (void)keyboardWillHide:(NSNotification *)aNotif {
    NSDictionary *userInfo = [aNotif userInfo];
	NSTimeInterval keyboardAnimDuration = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	UIViewAnimationCurve keyboardAnimCurve = [[userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntValue];
	CGRect keyboardFrameBegin = [self.view convertRect:[[userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue] fromView:nil];
	CGRect keyboardFrameEnd = [self.view convertRect:[[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
	
	// If the keyboard will slide horizontally then we don't want any animation to be done.
	// We only want animation when the keyboard will slide to/from bottom
	BOOL keyboardSlidesVeritcally = (keyboardFrameBegin.origin.y != keyboardFrameEnd.origin.y);
	
	if (keyboardSlidesVeritcally) {
        
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationCurve:keyboardAnimCurve];
		[UIView setAnimationDuration:keyboardAnimDuration];
    }
    
    CGRect tableViewBounds = self.tableView.frame;
	tableViewBounds.size.height = self.view.bounds.size.height;
    self.tableView.frame = tableViewBounds;
    
    [UIView commitAnimations];
}

- (void)removeKeyboardNotifications {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

@end
