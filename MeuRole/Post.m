//
//  Post.m
//  MeuRole
//
//  Created by Filipe de Souza on 23/02/15.
//  Copyright (c) 2015 Filipe de Souza. All rights reserved.
//

#import "Post.h"
#import <AFNetworking.h>

#define HOME NSHomeDirectory()
#define DOCUMENTS [HOME stringByAppendingPathComponent:@"Documents"]
#define PATH_LOCALIGUAL [DOCUMENTS stringByAppendingPathComponent:@"pickerLocalIgual.plist"]

@implementation Post

+(void)listarPostCompletion:(void (^)(NSArray *))block{

    Post *novoPost = [Post new];
    
    
    NSString *auxValor = [NSString stringWithFormat:@"0"];
    NSDictionary *dicAux = @{@"pickerLocalIgual": auxValor};
    [dicAux writeToFile:PATH_LOCALIGUAL atomically:YES];
    
    novoPost.locationManager = [[CLLocationManager alloc] init];
    novoPost.locationManager.distanceFilter = kCLDistanceFilterNone;
    novoPost.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [novoPost.locationManager startUpdatingLocation];
    
    [[AFHTTPSessionManager manager] GET:@"http://45.55.178.46:3000/produtos"
                             parameters:nil
                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                    
                                    NSMutableArray *listaPosts = [NSMutableArray new];
                                    
                                    for ( NSDictionary *dicionario in responseObject ) {
                                        
                                        Post *local = [Post new];
                                        local.latitude = [[dicionario objectForKey:@"latitude"] floatValue];
                                        local.longitude = [[dicionario objectForKey:@"longitude"] floatValue];
                                        
                                        NSString *stringLat = [NSString stringWithFormat:@"%.4f", novoPost.locationManager.location.coordinate.latitude];
                                        float latitude = [stringLat floatValue];
                                        
                                        NSString *stringLong = [NSString stringWithFormat:@"%.4f", novoPost.locationManager.location.coordinate.longitude];
                                        float longitude = [stringLong floatValue];
                                        
                                        NSLog(@"Latitude do server %.4f", local.latitude);
                                        NSLog(@"Longitude do server %.4f", local.longitude);
                                        NSLog(@"Latitude local %.4f", latitude);
                                        NSLog(@"Longitude local %.4f", longitude);
                                        
                                        
                                        if ((((local.latitude - 0.0050) < latitude) && ((local.latitude + 0.0020) > latitude) && ((local.longitude - 0.0020) < longitude) && ((local.longitude + 0.0050) > longitude)) || ((local.latitude == latitude) && (local.longitude == longitude))) {
                                            
                                            NSLog(@"Era pra gravar aqui");
                                            
                                            local.identificador = [dicionario objectForKey:@"_id"];
                                            local.nome = [dicionario objectForKey:@"nome"];
                                            local.tipo = [dicionario objectForKey:@"tipo"];
                                            NSString *encontrou = local.nome;
                                            NSLog(@"é pra salvar esse %@", encontrou);
                                            
                                            [listaPosts addObject:local];
                                            
                                            
                                            
                                            NSString *auxValor = [NSString stringWithFormat:@"1"];
                                            NSDictionary *dicAux = @{@"pickerLocalIgual": auxValor};
                                            [dicAux writeToFile:PATH_LOCALIGUAL atomically:YES];
                                            
                                            
                                        }
                                        //NSLog(@"E o array cadê: %@", listaPosts);
                                        
                                        block(listaPosts);
                                    }

                                    
                                    
                                    NSDictionary *dicionarioLocal = [NSDictionary dictionaryWithContentsOfFile:PATH_LOCALIGUAL];
                                    NSString *auxLocal = [dicionarioLocal objectForKey:@"pickerLocalIgual"];
                                    NSLog(@"Variavel auxiliar depois %@", auxLocal);

 
                                    
                                }failure:^(NSURLSessionDataTask *task, NSError *error) {
                                    
                                    UIAlertView *alertaSemConexao = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                                                               message:@"Desculpe, mas não foi possível conexão com o servidor.\nTente mais tarde!"
                                                                                              delegate:self
                                                                                     cancelButtonTitle:@"Ok"
                                                                                     otherButtonTitles:nil, nil];
                                    
                                    [alertaSemConexao show];
                                    
                                    
                                }];
    
}


+(void)postRole:(NSString *)nome Tipoescolhido:(NSString *)Tipoescolhido TipoescolhidoEspecialidade:(NSString *)TipoescolhidoEspecialidade valorInicialString:(NSString *)valorInicialString valorFinalString:(NSString *)valorFinalString notaString:(NSString *)notaString latitudeString:(NSString *)latitudeString longitudeString:(NSString *)longitudeString avaliacoes:(NSString *)avaliacoes loginPicker:(NSString *)loginPicker estacionamento:(NSString *)estacionamento terminou:(void(^)(BOOL sucesso))block{
    
    // Criar o dicionario de dados
    NSDictionary *dados = @{@"nome": nome, @"Tipoescolhido": Tipoescolhido, @"TipoescolhidoEspecialidade":TipoescolhidoEspecialidade, @"valorInicialString":valorInicialString, @"valorFinalString":valorFinalString, @"notaString":notaString, @"latitudeString":latitudeString, @"longitudeString":longitudeString, @"avaliacoes":avaliacoes, @"loginPicker":loginPicker, @"estacionamento":estacionamento,};
    
    [[AFHTTPSessionManager manager] POST:@"http://45.55.178.46:3000/produtos" parameters:dados success:^(NSURLSessionDataTask *task, id responseObject) {
        
        block(YES);

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        UIAlertView *alertaSemConexao = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                                   message:@"Desculpe, mas não foi possível conexão com o servidor.\nTente mais tarde!"
                                                                  delegate:self
                                                         cancelButtonTitle:@"Ok"
                                                         otherButtonTitles:nil, nil];
        
        alertaSemConexao.tag = 3;
        
        [alertaSemConexao show];
        
    }];
    
}


@end















