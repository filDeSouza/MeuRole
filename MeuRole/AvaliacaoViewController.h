//
//  AvaliacaoViewController.h
//  MeuRole
//
//  Created by Filipe de Souza on 12/02/15.
//  Copyright (c) 2015 Filipe de Souza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKCurrencyTextField.h"
#import <Social/Social.h>


@import CoreLocation;
@import MapKit;

@interface AvaliacaoViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, CLLocationManagerDelegate>

@property (nonatomic) NSArray *tipoRestaurante;
@property (nonatomic) NSArray *tipoBalada;
@property (nonatomic) NSArray *tipoCasaShows;
@property (nonatomic) NSArray *tipoBarzinho;
@property (nonatomic) NSArray *tipoTeatro;
@property (nonatomic) NSArray *tipoCinema;
@property (nonatomic) NSArray *tipoMuseu;

@property (nonatomic) NSArray *tipo;
@property (nonatomic) NSArray *tipoDoRole;
@property (nonatomic) NSArray *tipoEscolhidoRole;



@property (nonatomic) int nota;

@property (nonatomic) CLLocationManager *gerenciador;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;



@property (nonatomic) NSTimer *timerVaiLogo;

-(void)abrir;


@property (weak, nonatomic) IBOutlet UITextField *campoValorInicial;
@property (weak, nonatomic) IBOutlet UITextField *campoValorFinal;




@property (weak, nonatomic) IBOutlet UIButton *estrela1;
@property (weak, nonatomic) IBOutlet UIButton *estrela2;
@property (weak, nonatomic) IBOutlet UIButton *estrela3;
@property (weak, nonatomic) IBOutlet UIButton *estrela4;
@property (weak, nonatomic) IBOutlet UIButton *estrela5;
- (IBAction)estrelasQualidade:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UIImageView *imgEstrela1;
@property (weak, nonatomic) IBOutlet UIImageView *imgEstrela2;
@property (weak, nonatomic) IBOutlet UIImageView *imgEstrela3;
@property (weak, nonatomic) IBOutlet UIImageView *imgEstrela4;
@property (weak, nonatomic) IBOutlet UIImageView *imgEstrela5;


- (IBAction)salvarAvaliacao:(UIButton *)sender;




@property (nonatomic) int aux;


+(void)novoProduto:(NSString *)nome tipo:(NSString *)tipo quantidade:(NSNumber *)quantidade completion:(void(^)(BOOL ok))block;


@property (nonatomic) int avaliacoes;

// Valores recebidos da tableview
@property (nonatomic) NSString *textoRecebido;
@property (nonatomic) NSString *ident;

//Variaveis a serem salvas do web service
@property (nonatomic) NSString *identWebService;
@property (nonatomic) float valorInicial;
@property (nonatomic) float valorFinal;
@property (nonatomic) int notaWebService;
@property (nonatomic) int numeroAvaliacoes;

// Variavel recebida do Webservice
@property (nonatomic) NSString *nomeLocal;


@property (weak, nonatomic) IBOutlet BKCurrencyTextField *currencyTextFieldValorInicial;
@property (weak, nonatomic) IBOutlet BKCurrencyTextField* currencyTextFieldValorFinal;

@property (nonatomic) float valorInicialCampoTexto;
@property (nonatomic) float valorFinalCampoTexto;


@property (weak, nonatomic) IBOutlet UILabel *labelLocal;

@property (nonatomic) int numeroRandom;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewTelaAvaliacao;

@property (weak, nonatomic) IBOutlet UILabel *labelGravarAvaliacao;
@property (weak, nonatomic) IBOutlet UILabel *labelValorGasto;
@property (weak, nonatomic) IBOutlet UIButton *btGravar;

@property (weak, nonatomic) IBOutlet UILabel *labelEstacionamento;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedEstacionamento;

@property (nonatomic) SLComposeViewController *mySLComposerSheet;


@end
