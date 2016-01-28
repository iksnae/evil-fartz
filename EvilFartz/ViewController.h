//
//  ViewController.h
//  EvilFartz
//
//  Created by Khalid on 1/27/16.
//  Copyright © 2016 iksnae. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *soundsTableView;

@end

