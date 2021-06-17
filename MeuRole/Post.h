//
//  Post.h
//  MeuRole
//
//  Created by Filipe de Souza on 23/02/15.
//  Copyright (c) 2015 Filipe de Souza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import CoreLocation;
@import MapKit;


@interface Post : NSObject <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic) NSString *nomeLocal;

    
@property (nonatomic) CLLocationManager *locationManager;


+(void)listarPostCompletion:(void(^)(NSArray *listaPosts))block;

@property (nonatomic) NSMutableArray *lugaresEncontradosArray;

@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic) NSString *nome;
@property (nonatomic) NSString *tipo;
@property (nonatomic) NSString *identificador;

+(void)listarCompletion:(void(^)(NSString *getToken))block;

+(void)postRole:(NSString *)nome Tipoescolhido:(NSString *)Tipoescolhido TipoescolhidoEspecialidade:(NSString *)TipoescolhidoEspecialidade valorInicialString:(NSString *)valorInicialString valorFinalString:(NSString *)valorFinalString notaString:(NSString *)notaString latitudeString:(NSString *)latitudeString longitudeString:(NSString *)longitudeString avaliacoes:(NSString *)avaliacoes loginPicker:(NSString *)loginPicker estacionamento:(NSString *)estacionamento terminou:(void(^)(BOOL TUDOBEM))block;




@end
