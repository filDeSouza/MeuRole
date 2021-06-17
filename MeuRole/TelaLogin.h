//
//  TelaLogin.h
//  MeuRole
//
//  Created by Filipe de Souza on 13/01/15.
//  Copyright (c) 2015 Filipe de Souza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TelaLogin : UIView <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *login;

- (IBAction)cadastreUmLogin:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *cadastreLoginBt;

- (IBAction)cadastrar:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btCadastrar;

@property (nonatomic) NSTimer *timerVaiLogo;

@property (nonatomic) NSString *loginWS;

@property (weak, nonatomic) IBOutlet UILabel *labelCadastreUmLogin;
@property (weak, nonatomic) IBOutlet UILabel *labelCadastrar;

@property (weak, nonatomic) IBOutlet UIButton *btGravarRole;
@property (weak, nonatomic) IBOutlet UIButton *btBuscarRole;
@property (weak, nonatomic) IBOutlet UILabel *labelGravarLocal;
@property (weak, nonatomic) IBOutlet UILabel *labelBuscarLocal;

@property (weak, nonatomic) IBOutlet UIImageView *imagemFundoViewLogin;

@property (nonatomic) int numeroRandom;

@property (weak, nonatomic) IBOutlet UILabel *tituloApp1;
@property (weak, nonatomic) IBOutlet UILabel *tituloApp2;

@property (weak, nonatomic) IBOutlet UILabel *labelCadastrarDepois;

@property (weak, nonatomic) IBOutlet UIButton *btCadastrarDepois;

@end
