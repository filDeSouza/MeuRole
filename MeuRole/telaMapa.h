//
//  telaMapa.h
//  MeuRole
//
//  Created by Filipe de Souza on 13/10/14.
//  Copyright (c) 2014 Filipe de Souza. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;
@import MapKit;

@interface telaMapa : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic) NSString *nome;
@property (nonatomic) NSString *nomeFiltro;


@property (nonatomic) float latitude;
@property (nonatomic) float latitudeFiltro;

@property (nonatomic) float longitude;
@property (nonatomic) float longitudeFiltro;


@property (nonatomic) NSString *tipo;
@property (nonatomic) NSString *tipoFiltro;

@property (nonatomic) NSString *especialidade;
@property (nonatomic) NSString *especialidadeFiltro;


@property (nonatomic) int nota;
@property (nonatomic) int numeroAvaliacoes;
@property (nonatomic) int notaFiltro;


@property (nonatomic) float valorInicial;
@property (nonatomic) float valorInicialFiltro;

@property (nonatomic) float valorFinal;
@property (nonatomic) float valorFinalFiltro;


@property (weak, nonatomic) IBOutlet MKMapView *mapa;
@property (nonatomic) CLLocationManager *gerenciador;

@property (nonatomic) NSString *subtitulo;

- (IBAction)btSatelite:(UIButton *)sender;
- (IBAction)btHibrido:(UIButton *)sender;
- (IBAction)localizar:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *btSatelite;
@property (weak, nonatomic) IBOutlet UIButton *btHibrido;
@property (weak, nonatomic) IBOutlet UIButton *btIcone;


@end
