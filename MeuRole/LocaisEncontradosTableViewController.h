//
//  LocaisEncontradosTableViewController.h
//  MeuRole
//
//  Created by Filipe de Souza on 26/02/15.
//  Copyright (c) 2015 Filipe de Souza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocaisEncontradosTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSDictionary *locais;

@property (nonatomic) NSMutableArray *locaisArray;

@property (nonatomic) UIRefreshControl *rodero;

@property (nonatomic) NSArray *listaPosts;

@property (nonatomic) int numeroRandom;

@property (weak, nonatomic) IBOutlet UIView *viewProBotao;

@property (weak, nonatomic) IBOutlet UIButton *btNaoTa;

@property (weak, nonatomic) IBOutlet UILabel *labelNaoTa;



@end
