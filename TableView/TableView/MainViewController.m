//
//  MainViewController.m
//  TableView
//
//  Created by CPU11716 on 12/9/19.
//  Copyright © 2019 CPU11716. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
{
    NSArray * data;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    data=[NSArray arrayWithObjects:@"phuc",@"thuong", @"thanh",@"Hoai",@"Hong",@"Ngoc",nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* tableIdentifier= @"tableViewCellGirl";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if(cell==nil){
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    
    UIImage *img=[UIImage imageNamed:@"girl.jpg"];
    
    cell.textLabel.text=[data objectAtIndex:indexPath.row];
    cell.imageView.image=img;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * mes=[NSString stringWithFormat:@"you selected : %ld",indexPath.row];
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"notify"	 message:mes delegate:nil cancelButtonTitle:@"hehe, ok" otherButtonTitles:nil, nil];
    
    [alert show];
                        
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"ok3...");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"arrayDetail"]){
        NSIndexPath *i= [self.tableView indexPathForSelectedRow];
        SecondTableViewController *second=segue.destinationViewController;
        second.animalName= [data objectAtIndex:i.row];
        second.title=second.animalName;
        NSLog(@"ok...");
    }
    NSLog(@"ok2...");
}
@end
