//
//  TelaInicial.m
//  MeuRole
//
//  Created by Filipe de Souza on 08/04/15.
//  Copyright (c) 2015 Filipe de Souza. All rights reserved.
//

#import "TelaInicial.h"
#import "UIImageView+LBBlurredImage.h"


@interface TelaInicial ()

@end

@implementation TelaInicial

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSBundle *raiz = [NSBundle mainBundle];
    
    NSString *pathArquivo = [raiz pathForResource:@"roles" ofType:@"plist"];
    
    NSDictionary *dadosArquivo = [[NSDictionary alloc] initWithContentsOfFile:pathArquivo];

    
    NSArray *arrayLista = [[NSArray alloc] initWithArray:[dadosArquivo valueForKey:@"tipoDoRole"]];
    
    NSArray *arrayLista2 = [[NSArray alloc] initWithArray:[dadosArquivo valueForKey:@"tipoRestaurante"]];
    
    NSLog(@"Nome: %@\n%@", arrayLista, arrayLista2);
    
    
    // Do any additional setup after loading the view.

    //	 Do any additional setup after loading the view, typically from a nib.
    //
    //     Deixar a navigation bar transparente
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
//
//    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.320];
//    self.navigationController.navigationItem.backBarButtonItem = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    
    
    self.imgTelaInicial.image = [UIImage imageNamed:@"9"];
    
    self.labelMeuRole.text = [NSString stringWithFormat:@"Meu"];
    [self.labelMeuRole setFont:[UIFont fontWithName:@"Prototype" size:75.0]];
    
    self.labelRole.text = [NSString stringWithFormat:@"Rolê"];
    [self.labelRole setFont:[UIFont fontWithName:@"Prototype" size:75.0]];

    
//    do{
//        self.numeroRandom2 = arc4random() % 27;
//    }while (self.numeroRandom2 ==0);
//    
//    NSString *nomeImagem2 = [NSString stringWithFormat:@"%i", self.numeroRandom2];
    
    [self.imgTelaInicial setImageToBlur:[UIImage imageNamed:@"9"]
                                   blurRadius:kLBBlurredImageDefaultBlurRadius
                              completionBlock:^{
                                  NSLog(@"Funcionou");
                              }];
    
    self.timerVaiLogo = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                         target:self
                                                       selector:@selector(abrir)
                                                       userInfo:nil
                                                        repeats:NO];
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)abrir{
    
    [self performSegueWithIdentifier:@"vaiProComeco" sender:self];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
