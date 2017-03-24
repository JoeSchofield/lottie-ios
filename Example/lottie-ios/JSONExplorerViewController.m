//
//  LAJSONExplorerViewController.m
//  LottieAnimator
//
//  Created by Brandon Withrow on 12/15/15.
//  Copyright © 2015 Brandon Withrow. All rights reserved.
//

#import "JSONExplorerViewController.h"

@interface JSONExplorerViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *jsonExampleFiles;
@property (nonatomic, strong) NSArray *jsonAirdropFiles;

@end

@implementation JSONExplorerViewController
-(NSArray *)listOfFilesOfType:(NSString *)type {
    NSMutableArray *matches = [[NSMutableArray alloc]init];
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//    NSString *inboxDirectory = [documentsDirectory stringByAppendingPathComponent:@"Inbox"];
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:nil];
    
    for (NSString *item in contents){
        if ([[item pathExtension] isEqualToString:type]) {
            NSString *itemPath = [documentsDirectory stringByAppendingPathComponent:item];
            [matches addObject:itemPath];
//            [[NSFileManager defaultManager] removeItemAtPath:itemPath error:nil];
        }
    }
    return matches;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  
  self.jsonExampleFiles = [[NSBundle mainBundle] pathsForResourcesOfType:@"json" inDirectory:nil];
  self.jsonAirdropFiles = [self listOfFilesOfType:@"json"];
    
  self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
  [self.view addSubview:self.tableView];
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                                           style:UIBarButtonItemStyleDone
                                                                          target:self
                                                                          action:@selector(_closePressed)];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  self.tableView.frame = self.view.bounds;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @[@"Airdrop files", @"Examples"][section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.jsonAirdropFiles.count == 0 ? 1 : self.jsonAirdropFiles.count;
    } else {
        return self.jsonExampleFiles.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSString *fileURL;
    if (indexPath.section == 0) {
        if (self.jsonAirdropFiles.count == 0) {
            cell.textLabel.text = @"No files, Airdrop some!";
        } else {
            fileURL = self.jsonAirdropFiles[indexPath.row];
            NSArray *components = [fileURL componentsSeparatedByString:@"/"];
            cell.textLabel.text = components.lastObject;
            cell.detailTextLabel.text = @"test";
        }
    } else {
        fileURL = self.jsonExampleFiles[indexPath.row];
        NSArray *components = [fileURL componentsSeparatedByString:@"/"];
        cell.textLabel.text = components.lastObject;
    }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *fileURL;// = self.jsonExampleFiles[indexPath.row];
    
    
    if (indexPath.section == 0) {
        if (self.jsonAirdropFiles.count == 0) {
            return;
        } else {
            fileURL = self.jsonAirdropFiles[indexPath.row];
        }
    } else {
        fileURL = self.jsonExampleFiles[indexPath.row];
    }
    
   if (self.completionBlock) {
    self.completionBlock(fileURL);
  }
}

- (void)_closePressed {
  if (self.completionBlock) {
    self.completionBlock(nil);
  }
}

@end
