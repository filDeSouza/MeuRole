//
//  TelaDetalhesViewController.h
//  MeuRole
//
//  Created by Filipe de Souza on 15/12/14.
//  Copyright (c) 2014 Filipe de Souza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKCurrencyTextField.h"
#import "HMFCurrencyFormatter.h"
@import CoreLocation;
@import MapKit;

@interface TelaDetalhesViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UIScrollViewDelegate>

@property (nonatomic) NSString *nome;

@property (nonatomic) NSString *nomeWebS;

@property (nonatomic) int nota;
@property (nonatomic) int numeroAvaliacoes;


@property (weak, nonatomic) IBOutlet UILabel *labelNomeLocal;
@property (weak, nonatomic) IBOutlet UILabel *labelTipo;
@property (weak, nonatomic) IBOutlet UILabel *labelEspecialidade;
@property (weak, nonatomic) IBOutlet UILabel *labelValorInicial;
@property (weak, nonatomic) IBOutlet UILabel *labelValorFinal;
@property (weak, nonatomic) IBOutlet UILabel *endereco;
@property (weak, nonatomic) IBOutlet UILabel *labelDistancia;



@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;
@property (weak, nonatomic) IBOutlet UIImageView *img4;
@property (weak, nonatomic) IBOutlet UIImageView *img5;


@property (nonatomic) NSString *estacionamento;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic) CLLocation *origem;
@property (nonatomic) CLLocation *destino;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)tracarRota:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *imagemFundo;
@property (nonatomic) int numeroRandom;



@property (nonatomic, readwrite) CGFloat blurRadius; // default is 20.0f
@property (nonatomic, readwrite) CGFloat saturationDelta; // default is 1.5
@property (nonatomic, readwrite) UIColor *tintColor; // default nil
@property (nonatomic, weak) UIView *viewToBlur; // default is superview

@property (nonatomic) NSTimer *timerVaiLogo;

@property (weak, nonatomic) IBOutlet UILabel *textoFixoTipo;
@property (weak, nonatomic) IBOutlet UILabel *textoFixoEspecialidade;
@property (weak, nonatomic) IBOutlet UILabel *textoFixoMediaGasta;
@property (weak, nonatomic) IBOutlet UILabel *textoFixoDe;
@property (weak, nonatomic) IBOutlet UILabel *textoFixoA;
@property (weak, nonatomic) IBOutlet UILabel *textoFixoNota;
@property (weak, nonatomic) IBOutlet UILabel *textoFixoEndereco;
@property (weak, nonatomic) IBOutlet UILabel *textoFixoDistancia;

@property (weak, nonatomic) IBOutlet UIButton *btRotaWaze;
@property (weak, nonatomic) IBOutlet UILabel *labelWaze;

@property (weak, nonatomic) IBOutlet UITextField *campoTextoValorInicial;
@property (weak, nonatomic) IBOutlet UITextField *campoTextoValorFinal;

@property (nonatomic) float valorInicial;
@property (nonatomic) float valorFinal;

@property (nonatomic, retain) HMFCurrencyFormatter *priceFormatter;

@property (weak, nonatomic) IBOutlet UILabel *labelEstacionamento;

@property (weak, nonatomic) IBOutlet UILabel *labelTemEstacionamentoOuNao;


@end
