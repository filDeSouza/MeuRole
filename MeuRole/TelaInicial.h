//
//  TelaInicial.h
//  MeuRole
//
//  Created by Filipe de Souza on 08/04/15.
//  Copyright (c) 2015 Filipe de Souza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TelaInicial : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imgTelaInicial;

@property (nonatomic) NSTimer *timerVaiLogo;
@property (weak, nonatomic) IBOutlet UILabel *labelMeuRole;
@property (weak, nonatomic) IBOutlet UILabel *labelRole;

@end
