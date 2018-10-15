//
//  ViewController.m
//  SCoreData
//
//  Created by Superman on 2018/10/11.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import "ViewController.h"
#import "People.h"
#import "SCoredata.h"


@interface ViewController ()

@property (readonly, nonatomic) NSManagedObjectContext *managedObjectContext;

@property(nonatomic,strong)UILabel *showLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CGFloat wid=[UIScreen mainScreen].bounds.size.width;
    CGFloat hei=[UIScreen mainScreen].bounds.size.height;

    _showLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 80, wid-50*2, 25)];
    [self.view addSubview:_showLabel];
    
    UIButton *showBtn=[[UIButton alloc]initWithFrame:CGRectMake(80, 120, wid-80*2, 25)];
    [showBtn setTitle:@"show" forState:UIControlStateNormal];
    [showBtn addTarget:self action:@selector(showAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showBtn];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"People"];
    People *people=[[self.managedObjectContext executeFetchRequest:request error:nil]firstObject];
    if (people) {
        _showLabel.text = people.name;
    }

}
-(void)showAction{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"People"];
    People *people = [[self.managedObjectContext executeFetchRequest:request error:nil] firstObject];
    if (people) {
        self.showLabel.text = people.name;
    }
}
- (NSManagedObjectContext *)managedObjectContext
{
    return [[SCoredata shareInstance] mainManagedObjectContext];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end





















