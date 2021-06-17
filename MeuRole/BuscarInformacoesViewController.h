//
//  BuscarInformacoesViewController.h
//  MeuRole
//
//  Created by Filipe de Souza on 20/11/14.
//  Copyright (c) 2014 Filipe de Souza. All rights reserved.
//
#import "RMPickerViewController.h"
#import "BKCurrencyTextField.h"
#import <UIKit/UIKit.h>
@import CoreLocation;
@import MapKit;

@interface BuscarInformacoesViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, CLLocationManagerDelegate, RMPickerViewControllerDelegate>

@property (nonatomic) int nota;

@property (nonatomic) CLLocationManager *gerenciador;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;

@property (nonatomic) NSMutableArray *resultadoSQLite;

@property (nonatomic) NSString *tipoEscolhido;
@property (nonatomic) NSString *TipoescolhidoEspecialidade;

@property (nonatomic) NSTimer *timerVaiLogo;

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

@property (weak, nonatomic) IBOutlet UILabel *labelTipoRole;
@property (weak, nonatomic) IBOutlet UILabel *labelEspecialidadeRole;

- (IBAction)openPickerController:(UIButton *)sender;

@property (nonatomic) int pickerEscolhido;

@property (weak, nonatomic) IBOutlet UIButton *btTipoRole;
@property (weak, nonatomic) IBOutlet UIButton *btEspecialidadeRole;

@property (nonatomic) int selectedEscolhido;
@property (nonatomic) NSString *selectedRowTextoEscolhido;

@property (nonatomic) NSArray *tipo;
@property (nonatomic) NSArray *tipoDoRole;
@property (nonatomic) NSArray *tipoEscolhidoRole;

@property (nonatomic) NSArray *tipoRestaurante;
@property (nonatomic) NSArray *tipoBalada;
@property (nonatomic) NSArray *tipoCasaShows;
@property (nonatomic) NSArray *tipoBarzinho;
@property (nonatomic) NSArray *tipoTeatro;
@property (nonatomic) NSArray *tipoCinema;
@property (nonatomic) NSArray *tipoMuseu;

- (IBAction)buscarInformacoes:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet BKCurrencyTextField *currencyTextFieldValorInicial;

@property (weak, nonatomic) IBOutlet BKCurrencyTextField* currencyTextFieldValorFinal;

@property (nonatomic) int numeroRandom;

@property (weak, nonatomic) IBOutlet UILabel *labelFundoGasto;
@property (weak, nonatomic) IBOutlet UILabel *labelFundoNotas;
@property (weak, nonatomic) IBOutlet UILabel *labelPretencaodeGastos;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewTelaBuscar;

@property (weak, nonatomic) IBOutlet UIButton *buscarRole;
@property (weak, nonatomic) IBOutlet UILabel *labelBuscar;

@property (nonatomic) float valorInicial;
@property (nonatomic) float valorFinal;

- (IBAction)btLimpaTuto:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btLimpaTUTO;
@property (weak, nonatomic) IBOutlet UILabel *labelLimpaTuto;

@property (nonatomic) NSBundle *bundle;
@property (nonatomic) NSString *pathArquivo;
@property (nonatomic) NSDictionary *dadosArquivo;

@end
