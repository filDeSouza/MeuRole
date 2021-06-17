//
//  telaMapa.m
//  MeuRole
//
//  Created by Filipe de Souza on 13/10/14.
//  Copyright (c) 2014 Filipe de Souza. All rights reserved.
//

#import "telaMapa.h"
#import <AFNetworking/AFNetworking.h>
#import "TelaDetalhesViewController.h"
#import "DejalActivityView.h"


#define HOME NSHomeDirectory()
#define DOCUMENTS [HOME stringByAppendingPathComponent:@"Documents"]
#define PATH_NOME [DOCUMENTS stringByAppendingPathComponent:@"nome.plist"]
#define PATH_PICKERVIEW [DOCUMENTS stringByAppendingPathComponent:@"pickerView.plist"]
#define PATH_PICKERVIEWESPECIALIDADES [DOCUMENTS stringByAppendingPathComponent:@"pickerViewEspecialidades.plist"]
#define PATH_PICKERVIEWVALORINI [DOCUMENTS stringByAppendingPathComponent:@"pickerViewValorIni.plist"]
#define PATH_PICKERVIEWVALORFINI [DOCUMENTS stringByAppendingPathComponent:@"pickerViewValorFini.plist"]
#define PATH_PICKERVIEWNOTA [DOCUMENTS stringByAppendingPathComponent:@"pickerViewNota.plist"]


@interface telaMapa ()

@end

@implementation telaMapa

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self.btSatelite layer] setBorderWidth:2.0f];
    [[self.btSatelite layer] setCornerRadius:10.0f];
    [[self.btSatelite layer] setBorderColor:[UIColor blackColor].CGColor];
    self.btSatelite.backgroundColor = [UIColor whiteColor];
    
    [[self.btHibrido layer] setBorderWidth:2.0f];
    [[self.btHibrido layer] setCornerRadius:10.0f];
    [[self.btHibrido layer] setBorderColor:[UIColor blackColor].CGColor];
    self.btHibrido.backgroundColor = [UIColor whiteColor];
    
    [[self.btIcone layer] setBorderWidth:2.0f];
    [[self.btIcone layer] setCornerRadius:10.0f];
    [[self.btIcone layer] setBorderColor:[UIColor blackColor].CGColor];
    self.btIcone.backgroundColor = [UIColor whiteColor];
    
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    [backButton setTintColor:[UIColor whiteColor]];

    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    label.textAlignment = UITextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumFontSize = 10.0;
    [label setFont:[UIFont fontWithName:@"Prototype" size:25.0]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    [label setText:@"Encontre seu Rolê"];
    [self.navigationItem setTitleView:label];
    
    NSLog(@"Resultado do filtro %@", self.tipoFiltro);
    
    self.mapa.delegate = self;
    self.gerenciador = [CLLocationManager new];
    self.gerenciador.desiredAccuracy = kCLLocationAccuracyBest;
    self.gerenciador.delegate = self;
    
    [self.gerenciador requestWhenInUseAuthorization];
    
    self.mapa.showsUserLocation = YES;
    self.mapa.delegate = self;
    [self.mapa setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    

    
//    CLLocationCoordinate2D coordenadas = self.mapa.userLocation.coordinate;
//    
//    MKCoordinateSpan zoom = MKCoordinateSpanMake(0.3, 0.3);
//    
//    MKCoordinateRegion regiao = MKCoordinateRegionMake(coordenadas, zoom);
//    
//    [self.mapa setRegion:regiao animated:YES];
    
    //[self.mapa setCenterCoordinate:self.mapa.userLocation.coordinate animated:YES];
    
    
    //NSLog(@"Essas eram para aparecer   %f", coordenadas.longitude);
    
    NSDictionary *dicionario = [NSDictionary dictionaryWithContentsOfFile:PATH_PICKERVIEW];
    NSString *Tipoescolhido = [dicionario objectForKey:@"pickerView"];

    NSDictionary *dicionarioEspecialidade = [NSDictionary dictionaryWithContentsOfFile:PATH_PICKERVIEWESPECIALIDADES];
    NSString *TipoescolhidoEspecialidade = [dicionarioEspecialidade objectForKey:@"pickerViewEspecialidades"];
    
    NSDictionary *dicionarioValorIni = [NSDictionary dictionaryWithContentsOfFile:PATH_PICKERVIEWVALORINI];
    NSString *ValorIni = [dicionarioValorIni objectForKey:@"pickerViewValorIni"];
    
    NSDictionary *dicionarioValorFini = [NSDictionary dictionaryWithContentsOfFile:PATH_PICKERVIEWVALORFINI];
    NSString *ValorFini = [dicionarioValorFini objectForKey:@"pickerViewValorFini"];
    
    NSDictionary *dicionarioNota = [NSDictionary dictionaryWithContentsOfFile:PATH_PICKERVIEWNOTA];
    NSString *nota = [dicionarioNota objectForKey:@"pickerViewNota"];
    
    NSLog(@"Tipo %@  , Especialidade   %@   , ValorIni   %@   , ValorFinbi   %@   , Nota   %@ ", Tipoescolhido, TipoescolhidoEspecialidade, ValorIni, ValorFini, nota);
    
    NSMutableArray *pinos = [[NSMutableArray alloc]init];
    
    
    
    
    
    
    if ([Tipoescolhido isEqualToString:@"Todos"]) {

        [[AFHTTPSessionManager manager] GET:@"http://45.55.178.46:3000/produtos"
                                 parameters:nil
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        
                                        NSMutableArray *listaProdutos = [NSMutableArray new];
                                        
                                        for ( NSDictionary *dicionario in responseObject ) {
                                            telaMapa *local = [telaMapa new];
                                            
                                            local.numeroAvaliacoes = [[dicionario objectForKey:@"avaliacoes"] intValue];
                                            local.nome = [dicionario objectForKey:@"nome"];
                                            local.tipo = [dicionario objectForKey:@"tipo"];
                                            local.especialidade = [dicionario objectForKey:@"especialidade"];
                                            local.valorInicial = [[dicionario objectForKey:@"valorInicial"]floatValue];
                                            local.valorFinal = [[dicionario objectForKey:@"valorFinal"] floatValue];
                                            local.latitude = [[dicionario objectForKey:@"latitude"] floatValue];
                                            local.longitude = [[dicionario objectForKey:@"longitude"] floatValue];
                                            local.nota = [[dicionario objectForKey:@"nota"] intValue]/local.numeroAvaliacoes;
                                            
                                            if (local.nota > 0 && local.nota < 1.5) {
                                                
                                                local.nota = 1;
                                                
                                            }else if(local.nota >= 1.5 && local.nota < 2.5) {
                                                
                                                local.nota = 2;
                                                
                                            }else if(local.nota >= 2.5 && local.nota < 3.5) {
                                                
                                                local.nota = 3;
                                                
                                            }else if(local.nota >= 2.5 && local.nota < 3.5) {
                                                
                                                local.nota = 3;
                                                
                                            }else if(local.nota >= 3.5 && local.nota < 4.5) {
                                                
                                                local.nota = 4;
                                                
                                            }else if(local.nota >= 4.5 && local.nota <= 5) {
                                                
                                                local.nota = 5;
                                                
                                            }
                                            
                                            MKPointAnnotation *pinoMapa = [[MKPointAnnotation alloc] init];
                                            pinoMapa.coordinate = CLLocationCoordinate2DMake(local.latitude, local.longitude);
                                            pinoMapa.title = local.nome;
                                            pinoMapa.subtitle = local.tipo;
                                            
                                            
                                            [pinos addObject:pinoMapa];
                                            [self.mapa addAnnotation:pinoMapa];
    
                                    }
                                         [DejalBezelActivityView removeView];
                                    }

                                    failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        
                                        UIAlertView *alertaSemConexao = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                                                                   message:@"Desculpe, mas não foi possível conexão com o servidor.\nTente mais tarde!"
                                                                                                  delegate:self
                                                                                         cancelButtonTitle:@"Ok"
                                                                                         otherButtonTitles:nil, nil];
                                        
                                        alertaSemConexao.tag = 1;
                                        
                                        [alertaSemConexao show];
                                        
                                    }];
    }
    else if (![Tipoescolhido isEqualToString:@"Tipo do Rolê"] && ![TipoescolhidoEspecialidade isEqualToString:@"Especialidade"] && ![ValorIni isEqualToString:@"0.00"] && ![ValorFini isEqualToString:@"0.00"] && ![nota isEqualToString:@"0"]){
        
        [[AFHTTPSessionManager manager] GET:@"http://45.55.178.46:3000/produtos"
                                 parameters:nil
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        
                                        NSMutableArray *listaProdutos = [NSMutableArray new];
                                        
                                        for ( NSDictionary *dicionario in responseObject ) {
                                            telaMapa *local = [telaMapa new];
                                            
                                            local.numeroAvaliacoes = [[dicionario objectForKey:@"avaliacoes"] intValue];
                                            local.nome = [dicionario objectForKey:@"nome"];
                                            local.tipo = [dicionario objectForKey:@"tipo"];
                                            local.especialidade = [dicionario objectForKey:@"especialidade"];
                                            local.valorInicial = [[dicionario objectForKey:@"valorInicial"]floatValue]/local.numeroAvaliacoes;
                                            local.valorFinal = [[dicionario objectForKey:@"valorFinal"] floatValue]/local.numeroAvaliacoes;
                                            local.latitude = [[dicionario objectForKey:@"latitude"] floatValue];
                                            local.longitude = [[dicionario objectForKey:@"longitude"] floatValue];
                                            local.nota = [[dicionario objectForKey:@"nota"] intValue]/local.numeroAvaliacoes;
                                            
                                            if (local.nota > 0 && local.nota < 1.5) {
                                                
                                                local.nota = 1;
                                                
                                            }else if(local.nota >= 1.5 && local.nota < 2.5) {
                                                
                                                local.nota = 2;
                                                
                                            }else if(local.nota >= 2.5 && local.nota < 3.5) {
                                                
                                                local.nota = 3;
                                                
                                            }else if(local.nota >= 2.5 && local.nota < 3.5) {
                                                
                                                local.nota = 3;
                                                
                                            }else if(local.nota >= 3.5 && local.nota < 4.5) {
                                                
                                                local.nota = 4;
                                                
                                            }else if(local.nota >= 4.5 && local.nota <= 5) {
                                                
                                                local.nota = 5;
                                                
                                            }
                                            
                                            [listaProdutos addObject:local];
                                            
                                            NSLog(@"Aparece filho duma puta filtro 1   %@    %@  ", local.tipo, Tipoescolhido);


                                             if (([local.tipo isEqualToString:Tipoescolhido] && [local.especialidade isEqualToString:TipoescolhidoEspecialidade] &&  local.valorInicial >= [ValorIni floatValue] && local.valorFinal <= [ValorFini floatValue] && local.nota == [nota intValue])) {
                                                
                                                
                                                MKPointAnnotation *pinoMapa = [[MKPointAnnotation alloc] init];
                                                pinoMapa.coordinate = CLLocationCoordinate2DMake(local.latitude, local.longitude);
                                                pinoMapa.title = local.nome;
                                                pinoMapa.subtitle = local.tipo;
                                                
                                                
                                                [pinos addObject:pinoMapa];
                                                [self.mapa addAnnotation:pinoMapa];
                                                NSLog(@"E esses pinos aqui???   %@", pinos);
                                            }
                                            

                                        }
                                    }
                                    failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        
                                        UIAlertView *alertaSemConexao = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                                                                   message:@"Desculpe, mas não foi possível conexão com o servidor.\nTente mais tarde!"
                                                                                                  delegate:self
                                                                                         cancelButtonTitle:@"Ok"
                                                                                         otherButtonTitles:nil, nil];
                                        
                                        alertaSemConexao.tag = 1;
                                        
                                        [alertaSemConexao show];
                                        
                                    }];
        

        
    }
    
    else if (![Tipoescolhido isEqualToString:@"Tipo do Rolê"] && ![TipoescolhidoEspecialidade isEqualToString:@"Especialidade"] && ![ValorIni isEqualToString:@"0.00"] && ![ValorFini isEqualToString:@"0.00"]){
        
        [[AFHTTPSessionManager manager] GET:@"http://45.55.178.46:3000/produtos"
                                 parameters:nil
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        
                                        NSMutableArray *listaProdutos = [NSMutableArray new];
                                        
                                        for ( NSDictionary *dicionario in responseObject ) {
                                            telaMapa *local = [telaMapa new];
                                            
                                            local.numeroAvaliacoes = [[dicionario objectForKey:@"avaliacoes"] intValue];
                                            local.nome = [dicionario objectForKey:@"nome"];
                                            local.tipo = [dicionario objectForKey:@"tipo"];
                                            local.especialidade = [dicionario objectForKey:@"especialidade"];
                                            local.valorInicial = [[dicionario objectForKey:@"valorInicial"]floatValue]/local.numeroAvaliacoes;
                                            local.valorFinal = [[dicionario objectForKey:@"valorFinal"] floatValue]/local.numeroAvaliacoes;
                                            local.latitude = [[dicionario objectForKey:@"latitude"] floatValue];
                                            local.longitude = [[dicionario objectForKey:@"longitude"] floatValue];
                                            local.nota = [[dicionario objectForKey:@"nota"] intValue]/local.numeroAvaliacoes;
                                            
                                            if (local.nota > 0 && local.nota < 1.5) {
                                                
                                                local.nota = 1;
                                                
                                            }else if(local.nota >= 1.5 && local.nota < 2.5) {
                                                
                                                local.nota = 2;
                                                
                                            }else if(local.nota >= 2.5 && local.nota < 3.5) {
                                                
                                                local.nota = 3;
                                                
                                            }else if(local.nota >= 2.5 && local.nota < 3.5) {
                                                
                                                local.nota = 3;
                                                
                                            }else if(local.nota >= 3.5 && local.nota < 4.5) {
                                                
                                                local.nota = 4;
                                                
                                            }else if(local.nota >= 4.5 && local.nota <= 5) {
                                                
                                                local.nota = 5;
                                                
                                            }
                                            
                                            [listaProdutos addObject:local];
                                            
                                            NSLog(@"Aparece filho duma puta filtro 2   %@    %@  ", local.tipo, Tipoescolhido);
                                            
                                            if (([local.tipo isEqualToString:Tipoescolhido] && [local.especialidade isEqualToString:TipoescolhidoEspecialidade] &&  local.valorInicial >= [ValorIni floatValue] && local.valorFinal <= [ValorFini floatValue])) {
                                                
                                                
                                                MKPointAnnotation *pinoMapa = [[MKPointAnnotation alloc] init];
                                                pinoMapa.coordinate = CLLocationCoordinate2DMake(local.latitude, local.longitude);
                                                pinoMapa.title = local.nome;
                                                pinoMapa.subtitle = local.tipo;
                                                
                                                
                                                [pinos addObject:pinoMapa];
                                                [self.mapa addAnnotation:pinoMapa];
                                                NSLog(@"E esses pinos aqui???   %@", pinos);
                                            }
                                            
                                            
                                        }
                                    }
                                    failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        
                                        UIAlertView *alertaSemConexao = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                                                                   message:@"Desculpe, mas não foi possível conexão com o servidor.\nTente mais tarde!"
                                                                                                  delegate:self
                                                                                         cancelButtonTitle:@"Ok"
                                                                                         otherButtonTitles:nil, nil];
                                        
                                        alertaSemConexao.tag = 1;
                                        
                                        [alertaSemConexao show];
                                        
                                    }];
        
        
        
    }
    else if (![Tipoescolhido isEqualToString:@"Tipo do Rolê"] && ![TipoescolhidoEspecialidade isEqualToString:@"Especialidade"]&& ![nota isEqualToString:@"0"]){
        
        [[AFHTTPSessionManager manager] GET:@"http://45.55.178.46:3000/produtos"
                                 parameters:nil
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        
                                        NSMutableArray *listaProdutos = [NSMutableArray new];
                                        
                                        for ( NSDictionary *dicionario in responseObject ) {
                                            telaMapa *local = [telaMapa new];
                                            
                                            local.numeroAvaliacoes = [[dicionario objectForKey:@"avaliacoes"] intValue];
                                            local.nome = [dicionario objectForKey:@"nome"];
                                            local.tipo = [dicionario objectForKey:@"tipo"];
                                            local.especialidade = [dicionario objectForKey:@"especialidade"];
                                            local.valorInicial = [[dicionario objectForKey:@"valorInicial"]floatValue]/local.numeroAvaliacoes;
                                            local.valorFinal = [[dicionario objectForKey:@"valorFinal"] floatValue]/local.numeroAvaliacoes;
                                            local.latitude = [[dicionario objectForKey:@"latitude"] floatValue];
                                            local.longitude = [[dicionario objectForKey:@"longitude"] floatValue];
                                            local.nota = [[dicionario objectForKey:@"nota"] intValue]/local.numeroAvaliacoes;
                                            
                                            if (local.nota > 0 && local.nota < 1.5) {
                                                
                                                local.nota = 1;
                                                
                                            }else if(local.nota >= 1.5 && local.nota < 2.5) {
                                                
                                                local.nota = 2;
                                                
                                            }else if(local.nota >= 2.5 && local.nota < 3.5) {
                                                
                                                local.nota = 3;
                                                
                                            }else if(local.nota >= 2.5 && local.nota < 3.5) {
                                                
                                                local.nota = 3;
                                                
                                            }else if(local.nota >= 3.5 && local.nota < 4.5) {
                                                
                                                local.nota = 4;
                                                
                                            }else if(local.nota >= 4.5 && local.nota <= 5) {
                                                
                                                local.nota = 5;
                                                
                                            }
                                            
                                            [listaProdutos addObject:local];
                                            NSLog(@"Aparece filho duma puta filtro 3   %@    %@  ", local.tipo, Tipoescolhido);

                                            
                                            if (([local.tipo isEqualToString:Tipoescolhido] && [local.especialidade isEqualToString:TipoescolhidoEspecialidade] && local.nota == [nota intValue])) {
                                                
                                                
                                                MKPointAnnotation *pinoMapa = [[MKPointAnnotation alloc] init];
                                                pinoMapa.coordinate = CLLocationCoordinate2DMake(local.latitude, local.longitude);
                                                pinoMapa.title = local.nome;
                                                pinoMapa.subtitle = local.tipo;
                                                
                                                
                                                [pinos addObject:pinoMapa];
                                                [self.mapa addAnnotation:pinoMapa];
                                                NSLog(@"E esses pinos aqui???   %@", pinos);
                                            }
                                            
                                            
                                        }
                                    }
                                    failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        
                                        UIAlertView *alertaSemConexao = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                                                                   message:@"Desculpe, mas não foi possível conexão com o servidor.\nTente mais tarde!"
                                                                                                  delegate:self
                                                                                         cancelButtonTitle:@"Ok"
                                                                                         otherButtonTitles:nil, nil];
                                        
                                        alertaSemConexao.tag = 1;
                                        
                                        [alertaSemConexao show];
                                        
                                    }];
        
        
        
    }
    else if (![Tipoescolhido isEqualToString:@"Tipo do Rolê"] && ![TipoescolhidoEspecialidade isEqualToString:@"Especialidade"]){
        
        [[AFHTTPSessionManager manager] GET:@"http://45.55.178.46:3000/produtos"
                                 parameters:nil
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        
                                        NSMutableArray *listaProdutos = [NSMutableArray new];
                                        
                                        for ( NSDictionary *dicionario in responseObject ) {
                                            telaMapa *local = [telaMapa new];
                                            
                                            local.numeroAvaliacoes = [[dicionario objectForKey:@"avaliacoes"] intValue];
                                            local.nome = [dicionario objectForKey:@"nome"];
                                            local.tipo = [dicionario objectForKey:@"tipo"];
                                            local.especialidade = [dicionario objectForKey:@"especialidade"];
                                            local.valorInicial = [[dicionario objectForKey:@"valorInicial"]floatValue]/local.numeroAvaliacoes;
                                            local.valorFinal = [[dicionario objectForKey:@"valorFinal"] floatValue]/local.numeroAvaliacoes;
                                            local.latitude = [[dicionario objectForKey:@"latitude"] floatValue];
                                            local.longitude = [[dicionario objectForKey:@"longitude"] floatValue];
                                            local.nota = [[dicionario objectForKey:@"nota"] intValue]/local.numeroAvaliacoes;
                                            
                                            if (local.nota > 0 && local.nota < 1.5) {
                                                
                                                local.nota = 1;
                                                
                                            }else if(local.nota >= 1.5 && local.nota < 2.5) {
                                                
                                                local.nota = 2;
                                                
                                            }else if(local.nota >= 2.5 && local.nota < 3.5) {
                                                
                                                local.nota = 3;
                                                
                                            }else if(local.nota >= 2.5 && local.nota < 3.5) {
                                                
                                                local.nota = 3;
                                                
                                            }else if(local.nota >= 3.5 && local.nota < 4.5) {
                                                
                                                local.nota = 4;
                                                
                                            }else if(local.nota >= 4.5 && local.nota <= 5) {
                                                
                                                local.nota = 5;
                                                
                                            }
                                            
                                            [listaProdutos addObject:local];
                                            
                                            NSLog(@"Aparece filho duma puta filtro 4   %@    %@  ", local.tipo, Tipoescolhido);
                                            
                                            if (([local.tipo isEqualToString:Tipoescolhido] && [local.especialidade isEqualToString:TipoescolhidoEspecialidade])) {
                                                
                                                
                                                MKPointAnnotation *pinoMapa = [[MKPointAnnotation alloc] init];
                                                pinoMapa.coordinate = CLLocationCoordinate2DMake(local.latitude, local.longitude);
                                                pinoMapa.title = local.nome;
                                                pinoMapa.subtitle = local.tipo;
                                                
                                                
                                                [pinos addObject:pinoMapa];
                                                [self.mapa addAnnotation:pinoMapa];
                                                NSLog(@"E esses pinos aqui???   %@", pinos);
                                            }
                                            
                                            
                                        }
                                    }
                                    failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        
                                        UIAlertView *alertaSemConexao = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                                                                   message:@"Desculpe, mas não foi possível conexão com o servidor.\nTente mais tarde!"
                                                                                                  delegate:self
                                                                                         cancelButtonTitle:@"Ok"
                                                                                         otherButtonTitles:nil, nil];
                                        
                                        alertaSemConexao.tag = 1;
                                        
                                        [alertaSemConexao show];
                                        
                                    }];
        
        
        
    }
    else if (![Tipoescolhido isEqualToString:@"Tipo do Rolê"] && ![ValorIni isEqualToString:@"0.00"] && ![ValorFini isEqualToString:@"0.00"]){
        
        [[AFHTTPSessionManager manager] GET:@"http://45.55.178.46:3000/produtos"
                                 parameters:nil
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        
                                        NSMutableArray *listaProdutos = [NSMutableArray new];
                                        
                                        for ( NSDictionary *dicionario in responseObject ) {
                                            telaMapa *local = [telaMapa new];
                                            
                                            local.numeroAvaliacoes = [[dicionario objectForKey:@"avaliacoes"] intValue];
                                            local.nome = [dicionario objectForKey:@"nome"];
                                            local.tipo = [dicionario objectForKey:@"tipo"];
                                            local.especialidade = [dicionario objectForKey:@"especialidade"];
                                            local.valorInicial = [[dicionario objectForKey:@"valorInicial"]floatValue]/local.numeroAvaliacoes;
                                            local.valorFinal = [[dicionario objectForKey:@"valorFinal"] floatValue]/local.numeroAvaliacoes;
                                            local.latitude = [[dicionario objectForKey:@"latitude"] floatValue];
                                            local.longitude = [[dicionario objectForKey:@"longitude"] floatValue];
                                            local.nota = [[dicionario objectForKey:@"nota"] intValue]/local.numeroAvaliacoes;
                                            
                                            if (local.nota > 0 && local.nota < 1.5) {
                                                
                                                local.nota = 1;
                                                
                                            }else if(local.nota >= 1.5 && local.nota < 2.5) {
                                                
                                                local.nota = 2;
                                                
                                            }else if(local.nota >= 2.5 && local.nota < 3.5) {
                                                
                                                local.nota = 3;
                                                
                                            }else if(local.nota >= 2.5 && local.nota < 3.5) {
                                                
                                                local.nota = 3;
                                                
                                            }else if(local.nota >= 3.5 && local.nota < 4.5) {
                                                
                                                local.nota = 4;
                                                
                                            }else if(local.nota >= 4.5 && local.nota <= 5) {
                                                
                                                local.nota = 5;
                                                
                                            }
                                            
                                            [listaProdutos addObject:local];
                                            
                                            NSLog(@"Aparece filho duma puta filtro 5   %@    %@  ", local.tipo, Tipoescolhido);
                                            
                                            if (([local.tipo isEqualToString:Tipoescolhido] &&  local.valorInicial >= [ValorIni floatValue] && local.valorFinal <= [ValorFini floatValue])) {
                                                
                                                
                                                MKPointAnnotation *pinoMapa = [[MKPointAnnotation alloc] init];
                                                pinoMapa.coordinate = CLLocationCoordinate2DMake(local.latitude, local.longitude);
                                                pinoMapa.title = local.nome;
                                                pinoMapa.subtitle = local.tipo;
                                                
                                                
                                                [pinos addObject:pinoMapa];
                                                [self.mapa addAnnotation:pinoMapa];
                                                NSLog(@"E esses pinos aqui???   %@", pinos);
                                            }
                                            
                                            
                                        }
                                    }
                                    failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        
                                        UIAlertView *alertaSemConexao = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                                                                   message:@"Desculpe, mas não foi possível conexão com o servidor.\nTente mais tarde!"
                                                                                                  delegate:self
                                                                                         cancelButtonTitle:@"Ok"
                                                                                         otherButtonTitles:nil, nil];
                                        
                                        alertaSemConexao.tag = 1;
                                        
                                        [alertaSemConexao show];
                                        
                                    }];
        
        
        
    }
    else if (![Tipoescolhido isEqualToString:@"Tipo do Rolê"] && ![nota isEqualToString:@"0"]){
        
        [[AFHTTPSessionManager manager] GET:@"http://45.55.178.46:3000/produtos"
                                 parameters:nil
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        
                                        NSMutableArray *listaProdutos = [NSMutableArray new];
                                        
                                        for ( NSDictionary *dicionario in responseObject ) {
                                            telaMapa *local = [telaMapa new];
                                            
                                            local.numeroAvaliacoes = [[dicionario objectForKey:@"avaliacoes"] intValue];
                                            local.nome = [dicionario objectForKey:@"nome"];
                                            local.tipo = [dicionario objectForKey:@"tipo"];
                                            local.especialidade = [dicionario objectForKey:@"especialidade"];
                                            local.valorInicial = [[dicionario objectForKey:@"valorInicial"]floatValue]/local.numeroAvaliacoes;
                                            local.valorFinal = [[dicionario objectForKey:@"valorFinal"] floatValue]/local.numeroAvaliacoes;
                                            local.latitude = [[dicionario objectForKey:@"latitude"] floatValue];
                                            local.longitude = [[dicionario objectForKey:@"longitude"] floatValue];
                                            local.nota = [[dicionario objectForKey:@"nota"] intValue]/local.numeroAvaliacoes;
                                            
                                            if (local.nota > 0 && local.nota < 1.5) {
                                                
                                                local.nota = 1;
                                                
                                            }else if(local.nota >= 1.5 && local.nota < 2.5) {
                                                
                                                local.nota = 2;
                                                
                                            }else if(local.nota >= 2.5 && local.nota < 3.5) {
                                                
                                                local.nota = 3;
                                                
                                            }else if(local.nota >= 2.5 && local.nota < 3.5) {
                                                
                                                local.nota = 3;
                                                
                                            }else if(local.nota >= 3.5 && local.nota < 4.5) {
                                                
                                                local.nota = 4;
                                                
                                            }else if(local.nota >= 4.5 && local.nota <= 5) {
                                                
                                                local.nota = 5;
                                                
                                            }
                                            
                                            [listaProdutos addObject:local];
                                            
                                            NSLog(@"Aparece filho duma puta filtro 6   %@    %@  ", local.tipo, Tipoescolhido);
                                            
                                            if (([local.tipo isEqualToString:Tipoescolhido] && local.nota == [nota intValue])) {
                                                
                                                
                                                MKPointAnnotation *pinoMapa = [[MKPointAnnotation alloc] init];
                                                pinoMapa.coordinate = CLLocationCoordinate2DMake(local.latitude, local.longitude);
                                                pinoMapa.title = local.nome;
                                                pinoMapa.subtitle = local.tipo;
                                                
                                                
                                                [pinos addObject:pinoMapa];
                                                [self.mapa addAnnotation:pinoMapa];
                                                NSLog(@"E esses pinos aqui???   %@", pinos);
                                            }
                                            
                                            
                                        }
                                    }
                                    failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        
                                        UIAlertView *alertaSemConexao = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                                                                   message:@"Desculpe, mas não foi possível conexão com o servidor.\nTente mais tarde!"
                                                                                                  delegate:self
                                                                                         cancelButtonTitle:@"Ok"
                                                                                         otherButtonTitles:nil, nil];
                                        
                                        alertaSemConexao.tag = 1;
                                        
                                        [alertaSemConexao show];
                                        
                                    }];
        
        
        
    }
    else if (![ValorIni isEqualToString:@"0.00"] && ![ValorFini isEqualToString:@"0.00"] && ![nota isEqualToString:@"0"]){
        
        [[AFHTTPSessionManager manager] GET:@"http://45.55.178.46:3000/produtos"
                                 parameters:nil
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        
                                        NSMutableArray *listaProdutos = [NSMutableArray new];
                                        
                                        for ( NSDictionary *dicionario in responseObject ) {
                                            telaMapa *local = [telaMapa new];
                                            
                                            local.numeroAvaliacoes = [[dicionario objectForKey:@"avaliacoes"] intValue];
                                            local.nome = [dicionario objectForKey:@"nome"];
                                            local.tipo = [dicionario objectForKey:@"tipo"];
                                            local.especialidade = [dicionario objectForKey:@"especialidade"];
                                            local.valorInicial = [[dicionario objectForKey:@"valorInicial"]floatValue]/local.numeroAvaliacoes;
                                            local.valorFinal = [[dicionario objectForKey:@"valorFinal"] floatValue]/local.numeroAvaliacoes;
                                            local.latitude = [[dicionario objectForKey:@"latitude"] floatValue];
                                            local.longitude = [[dicionario objectForKey:@"longitude"] floatValue];
                                            local.nota = [[dicionario objectForKey:@"nota"] intValue]/local.numeroAvaliacoes;
                                            
                                            if (local.nota > 0 && local.nota < 1.5) {
                                                
                                                local.nota = 1;
                                                
                                            }else if(local.nota >= 1.5 && local.nota < 2.5) {
                                                
                                                local.nota = 2;
                                                
                                            }else if(local.nota >= 2.5 && local.nota < 3.5) {
                                                
                                                local.nota = 3;
                                                
                                            }else if(local.nota >= 2.5 && local.nota < 3.5) {
                                                
                                                local.nota = 3;
                                                
                                            }else if(local.nota >= 3.5 && local.nota < 4.5) {
                                                
                                                local.nota = 4;
                                                
                                            }else if(local.nota >= 4.5 && local.nota <= 5) {
                                                
                                                local.nota = 5;
                                                
                                            }
                                            
                                            [listaProdutos addObject:local];
                                            
                                            NSLog(@"Aparece filho duma puta filtro 7   %@    %@  ", local.tipo, Tipoescolhido);

                                            
                                            if ((local.valorInicial >= [ValorIni floatValue] && local.valorFinal <= [ValorFini floatValue]) && local.nota == [nota intValue]) {
                                                
                                                
                                                MKPointAnnotation *pinoMapa = [[MKPointAnnotation alloc] init];
                                                pinoMapa.coordinate = CLLocationCoordinate2DMake(local.latitude, local.longitude);
                                                pinoMapa.title = local.nome;
                                                pinoMapa.subtitle = local.tipo;
                                                
                                                
                                                [pinos addObject:pinoMapa];
                                                [self.mapa addAnnotation:pinoMapa];
                                                NSLog(@"E esses pinos aqui???   %@", pinos);
                                            }
                                            
                                            
                                        }
                                    }
                                    failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        
                                        UIAlertView *alertaSemConexao = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                                                                   message:@"Desculpe, mas não foi possível conexão com o servidor.\nTente mais tarde!"
                                                                                                  delegate:self
                                                                                         cancelButtonTitle:@"Ok"
                                                                                         otherButtonTitles:nil, nil];
                                        
                                        alertaSemConexao.tag = 1;
                                        
                                        [alertaSemConexao show];
                                        
                                    }];
        
        
        
    }
    else if (![ValorIni isEqualToString:@"0.00"] && ![ValorFini isEqualToString:@"0.00"]){
        
        [[AFHTTPSessionManager manager] GET:@"http://45.55.178.46:3000/produtos"
                                 parameters:nil
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        
                                        NSMutableArray *listaProdutos = [NSMutableArray new];
                                        
                                        for ( NSDictionary *dicionario in responseObject ) {
                                            telaMapa *local = [telaMapa new];
                                            
                                            local.numeroAvaliacoes = [[dicionario objectForKey:@"avaliacoes"] intValue];
                                            local.nome = [dicionario objectForKey:@"nome"];
                                            local.tipo = [dicionario objectForKey:@"tipo"];
                                            local.especialidade = [dicionario objectForKey:@"especialidade"];
                                            local.valorInicial = [[dicionario objectForKey:@"valorInicial"]floatValue]/local.numeroAvaliacoes;
                                            local.valorFinal = [[dicionario objectForKey:@"valorFinal"] floatValue]/local.numeroAvaliacoes;
                                            local.latitude = [[dicionario objectForKey:@"latitude"] floatValue];
                                            local.longitude = [[dicionario objectForKey:@"longitude"] floatValue];
                                            local.nota = [[dicionario objectForKey:@"nota"] intValue]/local.numeroAvaliacoes;
                                            
                                            if (local.nota > 0 && local.nota < 1.5) {
                                                
                                                local.nota = 1;
                                                
                                            }else if(local.nota >= 1.5 && local.nota < 2.5) {
                                                
                                                local.nota = 2;
                                                
                                            }else if(local.nota >= 2.5 && local.nota < 3.5) {
                                                
                                                local.nota = 3;
                                                
                                            }else if(local.nota >= 2.5 && local.nota < 3.5) {
                                                
                                                local.nota = 3;
                                                
                                            }else if(local.nota >= 3.5 && local.nota < 4.5) {
                                                
                                                local.nota = 4;
                                                
                                            }else if(local.nota >= 4.5 && local.nota <= 5) {
                                                
                                                local.nota = 5;
                                                
                                            }
                                            
                                            [listaProdutos addObject:local];
                                            
                                            NSLog(@"Aparece filho duma puta filtro 8   %@    %@  ", local.tipo, Tipoescolhido);
                                            
                                            if ((local.valorInicial >= [ValorIni floatValue] && local.valorFinal <= [ValorFini floatValue])) {
                                                
                                                
                                                MKPointAnnotation *pinoMapa = [[MKPointAnnotation alloc] init];
                                                pinoMapa.coordinate = CLLocationCoordinate2DMake(local.latitude, local.longitude);
                                                pinoMapa.title = local.nome;
                                                pinoMapa.subtitle = local.tipo;
                                                
                                                
                                                [pinos addObject:pinoMapa];
                                                [self.mapa addAnnotation:pinoMapa];
                                                NSLog(@"E esses pinos aqui???   %@", pinos);
                                            }
                                            
                                            
                                        }
                                    }
                                    failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        
                                        UIAlertView *alertaSemConexao = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                                                                   message:@"Desculpe, mas não foi possível conexão com o servidor.\nTente mais tarde!"
                                                                                                  delegate:self
                                                                                         cancelButtonTitle:@"Ok"
                                                                                         otherButtonTitles:nil, nil];
                                        
                                        alertaSemConexao.tag = 1;
                                        
                                        [alertaSemConexao show];
                                        
                                    }];
        
        
        
    }
    else if (![nota isEqualToString:@"0"]){
        
        [[AFHTTPSessionManager manager] GET:@"http://45.55.178.46:3000/produtos"
                                 parameters:nil
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        
                                        NSMutableArray *listaProdutos = [NSMutableArray new];
                                        
                                        for ( NSDictionary *dicionario in responseObject ) {
                                            telaMapa *local = [telaMapa new];
                                            
                                            local.numeroAvaliacoes = [[dicionario objectForKey:@"avaliacoes"] intValue];
                                            local.nome = [dicionario objectForKey:@"nome"];
                                            local.tipo = [dicionario objectForKey:@"tipo"];
                                            local.especialidade = [dicionario objectForKey:@"especialidade"];
                                            local.valorInicial = [[dicionario objectForKey:@"valorInicial"]floatValue]/local.numeroAvaliacoes;
                                            local.valorFinal = [[dicionario objectForKey:@"valorFinal"] floatValue]/local.numeroAvaliacoes;
                                            local.latitude = [[dicionario objectForKey:@"latitude"] floatValue];
                                            local.longitude = [[dicionario objectForKey:@"longitude"] floatValue];
                                            local.nota = [[dicionario objectForKey:@"nota"] intValue]/local.numeroAvaliacoes;
                                            
                                            if (local.nota > 0 && local.nota < 1.5) {
                                                
                                                local.nota = 1;
                                                
                                            }else if(local.nota >= 1.5 && local.nota < 2.5) {
                                                
                                                local.nota = 2;
                                                
                                            }else if(local.nota >= 2.5 && local.nota < 3.5) {
                                                
                                                local.nota = 3;
                                                
                                            }else if(local.nota >= 2.5 && local.nota < 3.5) {
                                                
                                                local.nota = 3;
                                                
                                            }else if(local.nota >= 3.5 && local.nota < 4.5) {
                                                
                                                local.nota = 4;
                                                
                                            }else if(local.nota >= 4.5 && local.nota <= 5) {
                                                
                                                local.nota = 5;
                                                
                                            }
                                            
                                            [listaProdutos addObject:local];
                                            
                                            NSLog(@"Aparece filho duma puta filtro 9   %@    %@  ", local.tipo, Tipoescolhido);

                                            
                                            if (local.nota == [nota intValue]) {
                                                
                                                
                                                MKPointAnnotation *pinoMapa = [[MKPointAnnotation alloc] init];
                                                pinoMapa.coordinate = CLLocationCoordinate2DMake(local.latitude, local.longitude);
                                                pinoMapa.title = local.nome;
                                                pinoMapa.subtitle = local.tipo;
                                                
                                                
                                                [pinos addObject:pinoMapa];
                                                [self.mapa addAnnotation:pinoMapa];
                                                NSLog(@"E esses pinos aqui???   %@", pinos);
                                            }
                                            
                                            
                                        }
                                    }
                                    failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        
                                        UIAlertView *alertaSemConexao = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                                                                   message:@"Desculpe, mas não foi possível conexão com o servidor.\nTente mais tarde!"
                                                                                                  delegate:self
                                                                                         cancelButtonTitle:@"Ok"
                                                                                         otherButtonTitles:nil, nil];
                                        
                                        alertaSemConexao.tag = 1;
                                        
                                        [alertaSemConexao show];
                                        
                                    }];
        
        
        
    }
    else if (![Tipoescolhido isEqualToString:@"Tipo do Rolê"]){
        
        [[AFHTTPSessionManager manager] GET:@"http://45.55.178.46:3000/produtos"
                                 parameters:nil
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        
                                        NSMutableArray *listaProdutos = [NSMutableArray new];
                                        
                                        for ( NSDictionary *dicionario in responseObject ) {
                                            telaMapa *local = [telaMapa new];
                                            
                                            local.numeroAvaliacoes = [[dicionario objectForKey:@"avaliacoes"] intValue];
                                            local.nome = [dicionario objectForKey:@"nome"];
                                            local.tipo = [dicionario objectForKey:@"tipo"];
                                            local.especialidade = [dicionario objectForKey:@"especialidade"];
                                            local.valorInicial = [[dicionario objectForKey:@"valorInicial"]floatValue]/local.numeroAvaliacoes;
                                            local.valorFinal = [[dicionario objectForKey:@"valorFinal"] floatValue]/local.numeroAvaliacoes;
                                            local.latitude = [[dicionario objectForKey:@"latitude"] floatValue];
                                            local.longitude = [[dicionario objectForKey:@"longitude"] floatValue];
                                            local.nota = [[dicionario objectForKey:@"nota"] intValue]/local.numeroAvaliacoes;
                                            
                                            if (local.nota > 0 && local.nota < 1.5) {
                                                
                                                local.nota = 1;
                                                
                                            }else if(local.nota >= 1.5 && local.nota < 2.5) {
                                                
                                                local.nota = 2;
                                                
                                            }else if(local.nota >= 2.5 && local.nota < 3.5) {
                                                
                                                local.nota = 3;
                                                
                                            }else if(local.nota >= 2.5 && local.nota < 3.5) {
                                                
                                                local.nota = 3;
                                                
                                            }else if(local.nota >= 3.5 && local.nota < 4.5) {
                                                
                                                local.nota = 4;
                                                
                                            }else if(local.nota >= 4.5 && local.nota <= 5) {
                                                
                                                local.nota = 5;
                                                
                                            }
                                            
                                            [listaProdutos addObject:local];
                                            
                                            NSLog(@"Aparece filho duma puta filtro 10   %@    %@  ", local.tipo, Tipoescolhido);
                                            
                                            if ([local.tipo isEqualToString:Tipoescolhido]) {
                                                
                                                
                                                MKPointAnnotation *pinoMapa = [[MKPointAnnotation alloc] init];
                                                pinoMapa.coordinate = CLLocationCoordinate2DMake(local.latitude, local.longitude);
                                                pinoMapa.title = local.nome;
                                                pinoMapa.subtitle = local.tipo;
                                                
                                                
                                                [pinos addObject:pinoMapa];
                                                [self.mapa addAnnotation:pinoMapa];
                                                NSLog(@"E esses pinos aqui???   %@", pinos);
                                            }
                                            
                                            
                                        }
                                    }
                                    failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        
                                        UIAlertView *alertaSemConexao = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                                                                   message:@"Desculpe, mas não foi possível conexão com o servidor.\nTente mais tarde!"
                                                                                                  delegate:self
                                                                                         cancelButtonTitle:@"Ok"
                                                                                         otherButtonTitles:nil, nil];
                                        
                                        alertaSemConexao.tag = 1;
                                        
                                        [alertaSemConexao show];
                                        
                                    }];
        
        
        
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    
//    
//    
//    
//    
//    [[AFHTTPSessionManager manager] GET:@"http://45.55.178.46:3000/produtos"
//                             parameters:nil
//                                success:^(NSURLSessionDataTask *task, id responseObject) {
//                                    
//                                    NSMutableArray *listaProdutos = [NSMutableArray new];
//                                    
//                                    for ( NSDictionary *dicionario in responseObject ) {
//                                        telaMapa *local = [telaMapa new];
//                                        
//                                        local.numeroAvaliacoes = [[dicionario objectForKey:@"avaliacoes"] intValue];
//                                        local.nome = [dicionario objectForKey:@"nome"];
//                                        local.tipo = [dicionario objectForKey:@"tipo"];
//                                        local.especialidade = [dicionario objectForKey:@"especialidade"];
//                                        local.valorInicial = [[dicionario objectForKey:@"valorInicial"]floatValue];
//                                        local.valorFinal = [[dicionario objectForKey:@"valorFinal"] floatValue];
//                                        local.latitude = [[dicionario objectForKey:@"latitude"] floatValue];
//                                        local.longitude = [[dicionario objectForKey:@"longitude"] floatValue];
//                                        local.nota = [[dicionario objectForKey:@"nota"] intValue]/local.numeroAvaliacoes;
//                                        
//                                        if (local.nota > 0 && local.nota < 1.5) {
//                                            
//                                            local.nota = 1;
//                                            
//                                        }else if(local.nota >= 1.5 && local.nota < 2.5) {
//                                            
//                                            local.nota = 2;
//                                            
//                                        }else if(local.nota >= 2.5 && local.nota < 3.5) {
//                                            
//                                            local.nota = 3;
//                                            
//                                        }else if(local.nota >= 2.5 && local.nota < 3.5) {
//                                            
//                                            local.nota = 3;
//                                            
//                                        }else if(local.nota >= 3.5 && local.nota < 4.5) {
//                                            
//                                            local.nota = 4;
//                                            
//                                        }else if(local.nota >= 4.5 && local.nota <= 5) {
//                                            
//                                            local.nota = 5;
//                                            
//                                        }
//
//
//                                        
//                                        
//
//                                        //NSLog(@"%@", subtitulo);
//                                        
//                                        [listaProdutos addObject:local];
//                                        
//                                        if ([Tipoescolhido isEqualToString:@"Todos"]) {
//                                            MKPointAnnotation *pinoMapa = [[MKPointAnnotation alloc] init];
//                                            pinoMapa.coordinate = CLLocationCoordinate2DMake(local.latitude, local.longitude);
//                                            pinoMapa.title = local.nome;
//                                            pinoMapa.subtitle = local.tipo;
//                                            
//                                            
//                                            [pinos addObject:pinoMapa];
//                                            [self.mapa addAnnotation:pinoMapa];
//                                            NSLog(@"E esses pinos aqui???   %@", pinos);
//                                        }
//                                        else if (([local.tipo isEqualToString:Tipoescolhido] && [local.especialidade isEqualToString:TipoescolhidoEspecialidade] &&  local.valorInicial >= [ValorIni floatValue] && local.valorFinal <= [ValorFini floatValue] && local.nota == [nota intValue])) {
//
//                                            
//                                        MKPointAnnotation *pinoMapa = [[MKPointAnnotation alloc] init];
//                                        pinoMapa.coordinate = CLLocationCoordinate2DMake(local.latitude, local.longitude);
//                                        pinoMapa.title = local.nome;
//                                        pinoMapa.subtitle = local.tipo;
//                                            
//                                        
//                                        [pinos addObject:pinoMapa];
//                                        [self.mapa addAnnotation:pinoMapa];
//                                        NSLog(@"E esses pinos aqui???   %@", pinos);
//                                        }
//                                        else if (([local.tipo isEqualToString:Tipoescolhido] && [local.especialidade isEqualToString:TipoescolhidoEspecialidade] &&  local.valorInicial >= [ValorIni floatValue] && local.valorFinal <= [ValorFini floatValue])) {
//                                            
//                                            
//                                            MKPointAnnotation *pinoMapa = [[MKPointAnnotation alloc] init];
//                                            pinoMapa.coordinate = CLLocationCoordinate2DMake(local.latitude, local.longitude);
//                                            pinoMapa.title = local.nome;
//                                            pinoMapa.subtitle = local.tipo;
//                                            
//                                            
//                                            [pinos addObject:pinoMapa];
//                                            [self.mapa addAnnotation:pinoMapa];
//                                            NSLog(@"E esses pinos aqui???   %@", pinos);
//                                        }
//                                        else if (([local.tipo isEqualToString:Tipoescolhido] && [local.especialidade isEqualToString:TipoescolhidoEspecialidade] && local.nota == [nota intValue])) {
//                                            
//                                            
//                                            MKPointAnnotation *pinoMapa = [[MKPointAnnotation alloc] init];
//                                            pinoMapa.coordinate = CLLocationCoordinate2DMake(local.latitude, local.longitude);
//                                            pinoMapa.title = local.nome;
//                                            pinoMapa.subtitle = local.tipo;
//                                            
//                                            
//                                            [pinos addObject:pinoMapa];
//                                            [self.mapa addAnnotation:pinoMapa];
//                                            NSLog(@"E esses pinos aqui???   %@", pinos);
//                                        }
//                                        
//                                        else if (([local.tipo isEqualToString:Tipoescolhido] && [local.especialidade isEqualToString:TipoescolhidoEspecialidade])) {
//                                            
//                                            
//                                            MKPointAnnotation *pinoMapa = [[MKPointAnnotation alloc] init];
//                                            pinoMapa.coordinate = CLLocationCoordinate2DMake(local.latitude, local.longitude);
//                                            pinoMapa.title = local.nome;
//                                            pinoMapa.subtitle = local.tipo;
//                                            
//                                            
//                                            [pinos addObject:pinoMapa];
//                                            [self.mapa addAnnotation:pinoMapa];
//                                            NSLog(@"E esses pinos aqui???   %@", pinos);
//                                        }
//                                        else if ([local.tipo isEqualToString:Tipoescolhido] && local.valorInicial >= [ValorIni floatValue] && local.valorFinal <= [ValorFini floatValue]) {
//                                            
//                                            
//                                            MKPointAnnotation *pinoMapa = [[MKPointAnnotation alloc] init];
//                                            pinoMapa.coordinate = CLLocationCoordinate2DMake(local.latitude, local.longitude);
//                                            pinoMapa.title = local.nome;
//                                            pinoMapa.subtitle = local.tipo;
//                                            
//                                            
//                                            [pinos addObject:pinoMapa];
//                                            [self.mapa addAnnotation:pinoMapa];
//                                            NSLog(@"E esses pinos aqui???   %@", pinos);
//                                        }
//                                        else if ((local.valorInicial >= [ValorIni floatValue] && local.valorFinal <= [ValorFini floatValue]) && local.nota == [nota intValue]) {
//                                            
//                                            
//                                            MKPointAnnotation *pinoMapa = [[MKPointAnnotation alloc] init];
//                                            pinoMapa.coordinate = CLLocationCoordinate2DMake(local.latitude, local.longitude);
//                                            pinoMapa.title = local.nome;
//                                            pinoMapa.subtitle = local.tipo;
//                                            
//                                            
//                                            [pinos addObject:pinoMapa];
//                                            [self.mapa addAnnotation:pinoMapa];
//                                            NSLog(@"E esses pinos aqui???   %@", pinos);
//                                        }
//                                        else if ((local.valorInicial >= [ValorIni floatValue] && local.valorFinal <= [ValorFini floatValue])) {
//                                            
//                                            
//                                            MKPointAnnotation *pinoMapa = [[MKPointAnnotation alloc] init];
//                                            pinoMapa.coordinate = CLLocationCoordinate2DMake(local.latitude, local.longitude);
//                                            pinoMapa.title = local.nome;
//                                            pinoMapa.subtitle = local.tipo;
//                                            
//                                            
//                                            [pinos addObject:pinoMapa];
//                                            [self.mapa addAnnotation:pinoMapa];
//                                            NSLog(@"E esses pinos aqui???   %@", pinos);
//                                        }
//                                        else if (local.nota == [nota intValue]) {
//                                            
//                                            
//                                            MKPointAnnotation *pinoMapa = [[MKPointAnnotation alloc] init];
//                                            pinoMapa.coordinate = CLLocationCoordinate2DMake(local.latitude, local.longitude);
//                                            pinoMapa.title = local.nome;
//                                            pinoMapa.subtitle = local.tipo;
//                                            
//                                            
//                                            [pinos addObject:pinoMapa];
//                                            [self.mapa addAnnotation:pinoMapa];
//                                            NSLog(@"E esses pinos aqui???   %@", pinos);
//                                        }else if ([local.tipo isEqualToString:Tipoescolhido]) {
//                                            
//                                            
//                                            MKPointAnnotation *pinoMapa = [[MKPointAnnotation alloc] init];
//                                            pinoMapa.coordinate = CLLocationCoordinate2DMake(local.latitude, local.longitude);
//                                            pinoMapa.title = local.nome;
//                                            pinoMapa.subtitle = local.tipo;
//                                            
//                                            
//                                            [pinos addObject:pinoMapa];
//                                            [self.mapa addAnnotation:pinoMapa];
//                                            NSLog(@"E esses pinos aqui???   %@", pinos);
//                                        }
//                                        
//                                        else{
//                                        
////                                            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Aviso"
////                                                                                             message:@"Não foram encontrados roles com o filtro selecionado, favor tentar novamente."
////                                                                                            delegate:self
////                                                                                   cancelButtonTitle:nil
////                                                                                   otherButtonTitles:@"Ok", nil];
////                                            alerta.tag = 1;
////                                            
////                                            [alerta show];
//                                            
//                                        }
//                                    }
//                                }
//                                failure:^(NSURLSessionDataTask *task, NSError *error) {
//                                    
//                                    UIAlertView *alertaSemConexao = [[UIAlertView alloc] initWithTitle:@"Aviso"
//                                                                                               message:@"Desculpe, mas não foi possível conexão com o servidor.\nTente mais tarde!"
//                                                                                              delegate:self
//                                                                                     cancelButtonTitle:@"Ok"
//                                                                                     otherButtonTitles:nil, nil];
//                                    
//                                    alertaSemConexao.tag = 1;
//                                    
//                                    [alertaSemConexao show];
//                                    
//                                }];
//    
    
    
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    if ([[annotation title] isEqualToString:@"Current Location"]) {
        return nil;
    }


    CLLocation *origem = self.mapa.userLocation.location;
    TelaDetalhesViewController *tela = [TelaDetalhesViewController new];
    tela.origem = origem;
    tela.destino = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
    
    
    
    //[leftCAV addSubview : button];
//    UILabel *l1=[[UILabel alloc] init];
//    l1.frame=CGRectMake(0, 15, 50, 50);
//    l1.text = annotation.title;
//    l1.font=[UIFont fontWithName:@"Arial Rounded MT Bold" size:(10.0)];
//    
//    UILabel *l2=[[UILabel alloc] init];
//    l2.frame=CGRectMake(0, 30, 50, 50);
//    l2.text=[NSString stringWithFormat:@"%@ - %.1f", annotation.subtitle, distancia];
//    l2.font=[UIFont fontWithName:@"Arial Rounded MT Bold" size:(10.0)];



//    UIView *leftCAV = [[UIView alloc] initWithFrame:CGRectMake(0,0,23,23)];
//    [leftCAV addSubview : l1];
//    [leftCAV addSubview : l2];
//    annotationView.rightCalloutAccessoryView = leftCAV;
//
    
    
    static NSString *AnnotationViewID = @"annotationViewID";
    
    MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    annotationView.canShowCallout = YES;

    
    
    NSLog(@"Titulo dessa porra: %@", annotation.title);
    
    if (annotationView == nil)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    
    
    if ([[annotation subtitle] isEqualToString:@"Balada"]) {
        annotationView.image = [UIImage imageNamed:@"iconeBalada"];//add any image which you want to show on map instead of red pins
        annotationView.annotation = annotation;

        UIImageView *imagemEsquerda = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"balada"]];
        annotationView.leftCalloutAccessoryView = imagemEsquerda;

    }
    else if([[annotation subtitle] isEqualToString:@"Barzinho"]){
        annotationView.image = [UIImage imageNamed:@"iconeBarzinho"];//add any image which you want to show on map instead of red pins
        annotationView.annotation = annotation;
        
        UIImageView *imagemEsquerda = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barzinho"]];
        annotationView.leftCalloutAccessoryView = imagemEsquerda;

        
    }
    else if([[annotation subtitle] isEqualToString:@"Casa de Shows"]){
        annotationView.image = [UIImage imageNamed:@"iconeCasaShows"];//add any image which you want to show on map instead of red pins
        annotationView.annotation = annotation;

        UIImageView *imagemEsquerda = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"casaShows"]];
        annotationView.leftCalloutAccessoryView = imagemEsquerda;
        
    }
    else if([[annotation subtitle] isEqualToString:@"Cinema"]){
        annotationView.image = [UIImage imageNamed:@"iconeCinema"];//add any image which you want to show on map instead of red pins
        annotationView.annotation = annotation;

        UIImageView *imagemEsquerda = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cinema"]];
        annotationView.leftCalloutAccessoryView = imagemEsquerda;
        
    }
    else if([[annotation subtitle] isEqualToString:@"Museu"]){
        annotationView.image = [UIImage imageNamed:@"iconeMuseu"];//add any image which you want to show on map instead of red pins
        annotationView.annotation = annotation;

        UIImageView *imagemEsquerda = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"museu"]];
        annotationView.leftCalloutAccessoryView = imagemEsquerda;
        
    }
    else if([[annotation subtitle] isEqualToString:@"Restaurante"]){
        annotationView.image = [UIImage imageNamed:@"iconeRestaurante"];//add any image which you want to show on map instead of red pins
        annotationView.annotation = annotation;
        
        UIImageView *imagemEsquerda = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"restaurante"]];
        annotationView.leftCalloutAccessoryView = imagemEsquerda;

        TelaDetalhesViewController *tela = [TelaDetalhesViewController new];
        tela.nome = annotation.title;
        
    }
    else if([[annotation subtitle] isEqualToString:@"Teatro"]){
        annotationView.image = [UIImage imageNamed:@"iconeTeatro"];//add any image which you want to show on map instead of red pins
        annotationView.annotation = annotation;
        
        UIImageView *imagemEsquerda = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"teatro"]];
        annotationView.leftCalloutAccessoryView = imagemEsquerda;

        
    }
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //[infoButton addTarget:self action:@selector(showDetailsView) forControlEvents:UIControlEventTouchUpInside];
    annotationView.rightCalloutAccessoryView = infoButton;
    annotationView.canShowCallout = YES;
    
    
    
    return annotationView;
}



-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    TelaDetalhesViewController *tela = [TelaDetalhesViewController new];
    tela.nome = view.annotation.title;
    
    NSDictionary *dicEscolhido =@{@"nome": view.annotation.title};
    [dicEscolhido writeToFile:PATH_NOME atomically:YES];
    
    
    NSLog(@"O que sera que vai aparecer: %@", tela.nome);
    
    NSLog(@"Tapou");
    
    
    
    [self performSegueWithIdentifier:@"telaDescricao" sender:view];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{

    if (alertView.tag == 1) {
        
        
        [self performSegueWithIdentifier:@"voltaProInicio" sender:self];
        
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btSatelite:(UIButton *)sender {
    
    self.btSatelite.backgroundColor = [[UIColor colorWithWhite:0.827 alpha:1.000] colorWithAlphaComponent:0.3f];
    self.btSatelite.opaque = YES;
    
    self.btHibrido.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
    self.btHibrido.opaque = YES;
    
    self.mapa.mapType = MKMapTypeStandard;
    
}

- (IBAction)btHibrido:(UIButton *)sender {
    
    self.btHibrido.backgroundColor = [[UIColor colorWithWhite:0.827 alpha:1.000] colorWithAlphaComponent:0.3f];
    self.btHibrido.opaque = YES;
    
    self.btSatelite.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
    self.btSatelite.opaque = YES;
    
    self.mapa.mapType = MKMapTypeHybrid;
    
}

- (IBAction)localizar:(UIButton *)sender {
    
    self.mapa.showsUserLocation = YES;
    self.mapa.userTrackingMode = YES;
    
}
@end





































