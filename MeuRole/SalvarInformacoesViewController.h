//
//  SalvarInformacoesViewController.h
//  MeuRole
//
//  Created by Filipe de Souza on 13/11/14.
//  Copyright (c) 2014 Filipe de Souza. All rights reserved.
//

#import "RMPickerViewController.h"
#import "BKCurrencyTextField.h"
#import <UIKit/UIKit.h>
@import CoreLocation;
@import MapKit;

@interface SalvarInformacoesViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, CLLocationManagerDelegate, RMPickerViewControllerDelegate, UIScrollViewDelegate>


// Arrays do pickerView
@property (nonatomic) NSBundle *bundle;
@property (nonatomic) NSString *pathArquivo;
@property (nonatomic) NSDictionary *dadosArquivo;
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

// Variavel recebida do Webservice
@property (nonatomic) NSString *nomeLocal;

@property (nonatomic) int pickerEscolhido;

@property (nonatomic) int nota;

@property (nonatomic) CLLocationManager *gerenciador;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;

@property (nonatomic) NSMutableArray *resultadoSQLite;

@property (nonatomic) NSString *tipoEscolhido;

@property (nonatomic) NSTimer *timerVaiLogo;

-(void)abrir;


@property (weak, nonatomic) IBOutlet UITextField *campoTextoLocal;
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

@property (weak, nonatomic) IBOutlet UILabel *labelEstacionamento;



- (IBAction)sanvarInformacoes:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UILabel *labelTipoRole;
@property (weak, nonatomic) IBOutlet UILabel *labelEspecialidadeRole;
@property (weak, nonatomic) IBOutlet UILabel *labelValorGasto;




-(void)resultadoDoBanco;

-(void)naoTemNoBanco;

@property (nonatomic) int aux;


- (IBAction)openPickerController:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *btTipoRole;
@property (weak, nonatomic) IBOutlet UIButton *btEspecialidadeRole;


+(void)novoProduto:(NSString *)nome tipo:(NSString *)tipo quantidade:(NSNumber *)quantidade completion:(void(^)(BOOL ok))block;

@property (nonatomic) int selectedEscolhido;
@property (nonatomic) NSString *selectedRowTextoEscolhido;

@property (weak, nonatomic) IBOutlet BKCurrencyTextField *currencyTextFieldValorInicial;

@property (weak, nonatomic) IBOutlet BKCurrencyTextField* currencyTextFieldValorFinal;
@property (nonatomic) int numeroRandom;


@property (weak, nonatomic) IBOutlet UIImageView *imageViewFundoSalvarRole;

@property (weak, nonatomic) IBOutlet UIButton *btGravarInformacoes;
@property (weak, nonatomic) IBOutlet UILabel *labelGravarInformcoes;

@property (nonatomic) float valorInicial;
@property (nonatomic) float valorFinal;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)tapou:(UITapGestureRecognizer *)sender;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapou;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedEstacionamento;


@end
