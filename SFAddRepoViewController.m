//
//  SFAddRepoViewController.m
//  GithubToGo
//
//  Created by Spencer Fornaciari on 2/12/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SFAddRepoViewController.h"

@interface SFAddRepoViewController ()
@property (strong, nonatomic) IBOutlet UITextField *repoNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *repoDescriptionTextfield;
@property (strong, nonatomic) IBOutlet UIButton *createRepoButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;


- (IBAction)createRepoAction:(id)sender;
- (IBAction)repoNameAction:(id)sender;
- (IBAction)repoDescriptionAction:(id)sender;
- (IBAction)cancelButton:(id)sender;

@property (nonatomic) SFNetworkController *networkController;
@property (nonatomic) NSString *repoName;
@property (nonatomic) NSString *repoDescription;
@property (nonatomic) BOOL readyToCreate;

@end

@implementation SFAddRepoViewController

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
    self.networkController = [SFNetworkController new];
    self.repoNameTextField.delegate = self;
    self.repoDescriptionTextfield.delegate = self;
    self.readyToCreate = FALSE;
    
    self.cancelButton.backgroundColor = [UIColor redColor];
    self.cancelButton.tintColor = [UIColor whiteColor];
    self.cancelButton.enabled = TRUE;
    
    self.createRepoButton.hidden = TRUE;
    self.createRepoButton.enabled = NO;
    self.createRepoButton.backgroundColor = [UIColor redColor];
    self.createRepoButton.tintColor = [UIColor whiteColor];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createRepoAction:(id)sender {
    
    [self.repoNameTextField resignFirstResponder];
    [self.repoDescriptionTextfield resignFirstResponder];
    NSLog(@"%@ %@", self.repoName, self.repoDescription);

    [self.networkController createRepo:self.repoName withDescription:self.repoDescription];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)repoNameAction:(id)sender {

   // self.repoName = self.repoNameTextField.text;
}

- (IBAction)repoDescriptionAction:(id)sender {
    //self.repoDescription = self.repoDescriptionTextfield.text;
}

- (IBAction)cancelButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.repoNameTextField resignFirstResponder];
    [self.repoDescriptionTextfield resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self.repoNameTextField resignFirstResponder];
    [self.repoDescriptionTextfield resignFirstResponder];
    
    return TRUE;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.repoName = self.repoNameTextField.text;
    self.repoDescription = self.repoDescriptionTextfield.text;
    [self.repoNameTextField resignFirstResponder];
    [self.repoDescriptionTextfield resignFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger nameLength = textField.text.length - range.length + string.length;
    
    if (nameLength > 0 && textField == self.repoNameTextField) {
        self.readyToCreate = TRUE;
    } else
    
    if (nameLength == 0 && textField == self.repoNameTextField) {
        self.readyToCreate = FALSE;
    }
    
    if (self.readyToCreate) {
        self.createRepoButton.hidden = NO;
        self.createRepoButton.enabled = YES;
        
        self.cancelButton.hidden = TRUE;
        self.cancelButton.enabled = FALSE;
    } else {
       self.createRepoButton.enabled = NO;
        self.createRepoButton.hidden = TRUE;
        
        self.cancelButton.hidden = FALSE;
        self.cancelButton.enabled = TRUE;
    }
    
    return YES;
}
@end
