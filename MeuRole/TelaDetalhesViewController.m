//
//  TelaDetalhesViewController.m
//  MeuRole
//
//  Created by Filipe de Souza on 15/12/14.
//  Copyright (c) 2014 Filipe de Souza. All rights reserved.
//

#import "TelaDetalhesViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "UIImageView+LBBlurredImage.h"
#import "DejalActivityView.h"


#define HOME NSHomeDirectory()
#define DOCUMENTS [HOME stringByAppendingPathComponent:@"Documents"]
#define PATH_NOME [DOCUMENTS stringByAppendingPathComponent:@"nome.plist"]


@interface TelaDetalhesViewController (){

CLLocationManager *locationManager;
}
@end

@implementation TelaDetalhesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.priceFormatter = [[HMFCurrencyFormatter alloc]init];
    self.campoTextoValorInicial.delegate = self.priceFormatter;
    self.campoTextoValorFinal.delegate = self.priceFormatter;
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    label.textAlignment = UITextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumFontSize = 10.0;
    [label setFont:[UIFont fontWithName:@"Prototype" size:25.0]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    [label setText:@"Detalhes do Rolê"];
    [self.navigationItem setTitleView:label];
    
    self.timerVaiLogo = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                         target:self
                                                       selector:@selector(abrir)
                                                       userInfo:nil
                                                        repeats:NO];
    
    [DejalBezelActivityView activityViewForView:self.view];
    
    
//    UILabel *minhaLabel = [[UILabel alloc] initWithFrame:CGRectMake(900.0
//                                                                    , 900.0
//                                                                    , 80.0
//                                                                    , 21.0)];
    self.scrollView.delegate = self;

    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(320, 1000)];
    //self.view = self.scrollView;
    
//    [self.scrollView addSubview:minhaLabel];

    
    NSDictionary *dicionario = [NSDictionary dictionaryWithContentsOfFile:PATH_NOME];
    
    NSString *tipoRoleEscolhido = [dicionario objectForKey:@"nome"];
    self.nome = tipoRoleEscolhido;
    
    [self.textoFixoTipo setFont:[UIFont fontWithName:@"Prototype" size:15.0]];
    [self.textoFixoEspecialidade setFont:[UIFont fontWithName:@"Prototype" size:15.0]];
    [self.textoFixoMediaGasta setFont:[UIFont fontWithName:@"Prototype" size:15.0]];
    [self.textoFixoDe setFont:[UIFont fontWithName:@"Prototype" size:15.0]];
    [self.textoFixoA setFont:[UIFont fontWithName:@"Prototype" size:15.0]];
    [self.textoFixoNota setFont:[UIFont fontWithName:@"Prototype" size:15.0]];
    [self.textoFixoEndereco setFont:[UIFont fontWithName:@"Prototype" size:15.0]];
    [self.textoFixoDistancia setFont:[UIFont fontWithName:@"Prototype" size:15.0]];
    
    [[self.btRotaWaze layer] setBorderWidth:2.0f];
    [[self.btRotaWaze layer] setCornerRadius:18.0f];
    [[self.btRotaWaze layer] setBorderColor:[UIColor whiteColor].CGColor];
    [self.labelWaze setFont:[UIFont fontWithName:@"Prototype" size:20.0]];

    self.labelEstacionamento.text = [NSString stringWithFormat:@"Possui valet ou\n estacionamento próximo?"];
    [self.labelEstacionamento setFont:[UIFont fontWithName:@"Prototype" size:15.0]];
    self.labelEstacionamento.numberOfLines = 2;

    
    [[AFHTTPSessionManager manager] GET:@"http://45.55.178.46:3000/produtos"
                             parameters:nil
                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                    
                                    for ( NSDictionary *dicionario in responseObject ) {
                                        
                                        self.nomeWebS = [dicionario objectForKey:@"nome"];
                                        
                                        NSLog(@"Nomes : %@       %@", self.nome, self.nomeWebS);
                                        
                                        if ([self.nomeWebS isEqualToString:self.nome]) {
                                            
                                            self.labelNomeLocal.text = self.nomeWebS;
                                            [self.labelNomeLocal setFont:[UIFont fontWithName:@"Prototype" size:45.0]];
                                            self.labelNomeLocal.numberOfLines = 2;
                                            self.labelNomeLocal.minimumFontSize = 8.0;
                                            self.labelNomeLocal.adjustsFontSizeToFitWidth = YES;
                                            
                                            self.estacionamento = [dicionario objectForKey:@"estacionamento"];
                                            
                                            // Pegar o nome do endereço pelas coordenadas
                                            TelaDetalhesViewController *local = [TelaDetalhesViewController new];
                                            local.latitude = [[dicionario objectForKey:@"latitude"] floatValue];
                                            local.longitude = [[dicionario objectForKey:@"longitude"] floatValue];
                                            CLGeocoder *ceo = [[CLGeocoder alloc] init];
                                            CLLocation *loc = [[CLLocation alloc] initWithLatitude:local.latitude longitude:local.longitude];
                                            [ceo reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
                                                
                                                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                                                NSLog(@"placemark %@",placemark);
                                                //String to hold address
                                                NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                                                NSLog(@"addressDictionary %@", placemark.addressDictionary);
                                                
                                                NSLog(@"placemark %@",placemark.region);
                                                NSLog(@"placemark %@",placemark.country);  // Give Country Name
                                                NSLog(@"placemark %@",placemark.locality); // Extract the city name
                                                NSLog(@"location %@",placemark.name);
                                                NSLog(@"location %@",placemark.ocean);
                                                NSLog(@"location %@",placemark.postalCode);
                                                NSLog(@"location %@",placemark.subLocality);
                                                
                                                self.endereco.text = [NSString stringWithFormat:@"%@", placemark.name];
                                                [self.endereco setFont:[UIFont fontWithName:@"Prototype" size:25.0]];
                                                self.endereco.numberOfLines = 2;
                                                self.endereco.minimumFontSize = 8.0;
                                                self.endereco.adjustsFontSizeToFitWidth = YES;

                                                
                                                NSLog(@"location %@",placemark.location);
                                                //Print the location to console
                                                NSLog(@"I am currently at %@",locatedAt);
                                            }];
                                            
                                            if ([self.estacionamento isEqualToString:@"0"]) {
                                                
                                                self.labelTemEstacionamentoOuNao.text = [NSString stringWithFormat:@"Não"];
                                                [self.labelTemEstacionamentoOuNao setFont:[UIFont fontWithName:@"Prototype" size:25.0]];

                                                
                                            }else if ([self.estacionamento isEqualToString:@"1"]){
                                                
                                                self.labelTemEstacionamentoOuNao.text = [NSString stringWithFormat:@"Sim"];
                                                [self.labelTemEstacionamentoOuNao setFont:[UIFont fontWithName:@"Prototype" size:25.0]];

                                                
                                            }
                                            
                                            
                                            // Calculo de distancia entre o local onde o usuario esta e o mkpointannotation selecionado
                                            locationManager = [[CLLocationManager alloc] init];
                                            locationManager.distanceFilter = kCLDistanceFilterNone;
                                            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
                                            [locationManager startUpdatingLocation];
                                            CLLocation *origem = [[CLLocation alloc] initWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude];
                                            CLLocation *destino = [[CLLocation alloc] initWithLatitude:local.latitude longitude:local.longitude];
                                            CLLocationDistance distancia = [origem distanceFromLocation:destino]/1000;
                                            NSLog(@"Funciona essa porra de distancia %.1f", distancia);
                                            
                                            self.numeroAvaliacoes = [[dicionario objectForKey:@"avaliacoes"] intValue];
                                            float valorInicial = [[dicionario objectForKey:@"valorInicial"] floatValue];
                                            float valorFinal = [[dicionario objectForKey:@"valorFinal"] floatValue];

                                            NSString *tipo = [dicionario objectForKey:@"tipo"];
                                            self.labelTipo.text = [NSString stringWithFormat:@"%@", tipo];
                                            [self.labelTipo setFont:[UIFont fontWithName:@"Prototype" size:25.0]];

                                            self.labelEspecialidade.text = [dicionario objectForKey:@"especialidade"];
                                            [self.labelEspecialidade setFont:[UIFont fontWithName:@"Prototype" size:25.0]];
                                            
                                            
                                            self.labelValorInicial.text = [NSString stringWithFormat:@"R$ %.2f", valorInicial/self.numeroAvaliacoes];
                                            [self.labelValorInicial setFont:[UIFont fontWithName:@"Prototype" size:25.0]];

                                            self.labelValorFinal.text = [NSString stringWithFormat:@"R$ %.2f", valorFinal/self.numeroAvaliacoes];
                                            [self.labelValorFinal setFont:[UIFont fontWithName:@"Prototype" size:25.0]];

                                            self.nota = [[dicionario objectForKey:@"nota"] intValue]/self.numeroAvaliacoes;
                                            self.labelDistancia.text = [NSString stringWithFormat:@"%.1f Km", distancia];
                                            [self.labelDistancia setFont:[UIFont fontWithName:@"Prototype" size:25.0]];

                                            
                                            if (self.nota > 0 && self.nota < 1.5) {
                                                self.img1.image = [UIImage imageNamed:@"Selecionada"];
                                            }
                                            else if (self.nota > 1.5 && self.nota < 2.5){
                                                
                                                self.img1.image =
                                                self.img2.image = [UIImage imageNamed:@"Selecionada"];
                                                
                                            }
                                            else if (self.nota > 2.5 && self.nota < 3.5){
                                                
                                                self.img1.image =
                                                self.img2.image =
                                                self.img3.image = [UIImage imageNamed:@"Selecionada"];
                                                
                                            }
                                            else if (self.nota > 3.5 && self.nota < 4.5){
                                                
                                                self.img1.image =
                                                self.img2.image =
                                                self.img3.image =
                                                self.img4.image = [UIImage imageNamed:@"Selecionada"];
                                                
                                            }
                                            else if (self.nota > 4.5){
                                                
                                                self.img1.image =
                                                self.img2.image =
                                                self.img3.image =
                                                self.img4.image =
                                                self.img5.image = [UIImage imageNamed:@"Selecionada"];
                                                
                                            }
                                            
                                            do{
                                                self.numeroRandom = arc4random() % 7;
                                            }while (self.numeroRandom ==0);
                                            
//                                            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
//                                            UIVisualEffectView *bluredEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//                                            [bluredEffectView setFrame:self.view.bounds];
//                                            [self.view addSubview:bluredEffectView];
                                            
                                            // Setar a imagem de fundo de acordo com o local
                                            if ([tipo isEqualToString:@"Balada"]) {
                                                
                                                NSString *nomeImagem = [NSString stringWithFormat:@"balada%i", self.numeroRandom];
//                                                self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:nomeImagem]];
                                                
                                                [self.imagemFundo setImageToBlur:[UIImage imageNamed:nomeImagem]
                                                                           blurRadius:kLBBlurredImageDefaultBlurRadius
                                                                      completionBlock:^{
                                                                          NSLog(@"Funcionou");
                                                                      }];
                                                
                                                
                                            }else if ([tipo isEqualToString:@"Barzinho"]){
                                                
                                                NSString *nomeImagem = [NSString stringWithFormat:@"bar%i", self.numeroRandom];
                                                
                                                [self.imagemFundo setImageToBlur:[UIImage imageNamed:nomeImagem]
                                                                      blurRadius:kLBBlurredImageDefaultBlurRadius
                                                                 completionBlock:^{
                                                                     NSLog(@"Funcionou");
                                                                 }];
                                                
                                                
                                            }else if ([tipo isEqualToString:@"Casa de Shows"]){
                                                
                                                NSString *nomeImagem = [NSString stringWithFormat:@"casaShow%i", self.numeroRandom];
                                                
                                                [self.imagemFundo setImageToBlur:[UIImage imageNamed:nomeImagem]
                                                                      blurRadius:kLBBlurredImageDefaultBlurRadius
                                                                 completionBlock:^{
                                                                     NSLog(@"Funcionou");
                                                                 }];
                                                
                                                
                                            }else if ([tipo isEqualToString:@"Cinema"]){
                                                
                                                NSString *nomeImagem = [NSString stringWithFormat:@"cine%i", self.numeroRandom];
                                                
                                                [self.imagemFundo setImageToBlur:[UIImage imageNamed:nomeImagem]
                                                                      blurRadius:kLBBlurredImageDefaultBlurRadius
                                                                 completionBlock:^{
                                                                     NSLog(@"Funcionou");
                                                                 }];
                                                
                                                
                                            }else if ([tipo isEqualToString:@"Museu"]){
                                                
                                                NSString *nomeImagem = [NSString stringWithFormat:@"museu%i", self.numeroRandom];
                                                
                                                [self.imagemFundo setImageToBlur:[UIImage imageNamed:nomeImagem]
                                                                      blurRadius:kLBBlurredImageDefaultBlurRadius
                                                                 completionBlock:^{
                                                                     NSLog(@"Funcionou");
                                                                 }];
                                                
                                                
                                            }else if ([tipo isEqualToString:@"Restaurante"]){
                                                
                                                NSString *nomeImagem = [NSString stringWithFormat:@"rest%i", self.numeroRandom];
                                                
                                                [self.imagemFundo setImageToBlur:[UIImage imageNamed:nomeImagem]
                                                                      blurRadius:kLBBlurredImageDefaultBlurRadius
                                                                 completionBlock:^{
                                                                     NSLog(@"Funcionou");
                                                                 }];
                                                
                                            }else if ([tipo isEqualToString:@"Teatro"]){
                                                
                                                NSString *nomeImagem = [NSString stringWithFormat:@"teatro%i", self.numeroRandom];
                                                
                                                [self.imagemFundo setImageToBlur:[UIImage imageNamed:nomeImagem]
                                                                      blurRadius:kLBBlurredImageDefaultBlurRadius
                                                                 completionBlock:^{
                                                                     NSLog(@"Funcionou");
                                                                 }];
                                                
                                            }
                                        
                                        }
                                       
                                        
                                    }
                                }
                                failure:^(NSURLSessionDataTask *task, NSError *error) {
                                    
                                    UIAlertView *alertaSemConexao = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                                                               message:@"Desculpe, mas não foi possível conexão com o servidor.\nTente mais tarde!"
                                                                                              delegate:self
                                                                                     cancelButtonTitle:@"Ok"
                                                                                     otherButtonTitles:nil, nil];
                                    
                                    [alertaSemConexao show];
                                    
                                    
                                }];
    
    
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)tracarRota:(UIButton *)sender {

    
    NSDictionary *dicionario = [NSDictionary dictionaryWithContentsOfFile:PATH_NOME];
    
    NSString *tipoRoleEscolhido = [dicionario objectForKey:@"nome"];
    self.nome = tipoRoleEscolhido;
    
    
    [[AFHTTPSessionManager manager] GET:@"http://45.55.178.46:3000/produtos"
                             parameters:nil
                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                    
                                    for ( NSDictionary *dicionario in responseObject ) {
                                        
                                        self.nomeWebS = [dicionario objectForKey:@"nome"];
                                        
                                        NSLog(@"Nomes : %@       %@", self.nome, self.nomeWebS);
                                        
                                        if ([self.nomeWebS isEqualToString:self.nome]) {
                                            
                                            self.labelNomeLocal.text = self.nomeWebS;
                                            
                                            // Pegar o nome do endereço pelas coordenadas
                                            TelaDetalhesViewController *local = [TelaDetalhesViewController new];
                                            local.latitude = [[dicionario objectForKey:@"latitude"] floatValue];
                                            local.longitude = [[dicionario objectForKey:@"longitude"] floatValue];

                                            
                                            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"waze://"]]) {
                                                
                                                NSString *urlStr = [NSString stringWithFormat:@"waze://?ll=%f,%f&navigate=yes", local.latitude, local.longitude];
                                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                                                
                                                
                                            }
                                            else{
                                                
                                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/id323229106"]];
                                                
                                            }
                                            
                                            
                                        }
                                        
                                    }
                                }

                                failure:^(NSURLSessionDataTask *task, NSError *error) {
                                    
                                    UIAlertView *alertaSemConexao = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                                                               message:@"Desculpe, mas não foi possível conexão com o servidor.\nTente mais tarde!"
                                                                                              delegate:self
                                                                                     cancelButtonTitle:@"Ok"
                                                                                     otherButtonTitles:nil, nil];
                                    
                                    [alertaSemConexao show];
                                    
                                }];
    
    

    
    
    
    
}

-(void)abrir{
    
    [DejalBezelActivityView removeView];
    
}

@end


























