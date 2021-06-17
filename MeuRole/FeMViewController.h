//
//  FeMViewController.h
//  MeuRole
//
//  Created by Filipe de Souza on 29/08/14.
//  Copyright (c) 2014 Filipe de Souza. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;
@import MapKit;


@interface FeMViewController : UIViewController <UITextFieldDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITextField *login;

- (IBAction)cadastreUmLogin:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *cadastreLoginBt;

- (IBAction)cadastrar:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btCadastrar;

@property (nonatomic) NSTimer *timerVaiLogo;

@property (nonatomic) NSString *loginWS;

@property (weak, nonatomic) IBOutlet UIImageView *imagemBackGround;

@property (nonatomic) int numeroRandom;


@property (weak, nonatomic) IBOutlet UIView *telaLogin;
@property (weak, nonatomic) IBOutlet UITextField *campoTextoLogin;
@property (weak, nonatomic) IBOutlet UIButton *btCadastrarUmLogin;
@property (weak, nonatomic) IBOutlet UIButton *btCadastraTelaView;

@property (weak, nonatomic) IBOutlet UILabel *labelCadastreUmLogin;
@property (weak, nonatomic) IBOutlet UILabel *labelCadastrar;

- (IBAction)btGravar:(UIButton *)sender;
- (IBAction)btBuscar:(UIButton *)sender;

@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic) NSString *nome;


@property (nonatomic) NSMutableArray *lugaresEncontradosArray;


@property (weak, nonatomic) IBOutlet UILabel *labelGravarLocal;
@property (weak, nonatomic) IBOutlet UILabel *labelBuscarLocal;

@property (weak, nonatomic) IBOutlet UIButton *btGravarRole;
@property (weak, nonatomic) IBOutlet UIButton *btBuscarRole;

@property (nonatomic) NSString *conectado;

@property (weak, nonatomic) IBOutlet UILabel *tituloApp1;
@property (weak, nonatomic) IBOutlet UILabel *tituloApp2;

@property (nonatomic) int numeroRandom2;

@property (weak, nonatomic) IBOutlet UIImageView *imagemFundoViewLogin;

@property (weak, nonatomic) IBOutlet UIButton *btCadastrarDepois;
- (IBAction)CadastrarDepois:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *labelCadastrarDepois;


@end
