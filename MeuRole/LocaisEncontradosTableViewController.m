//
//  LocaisEncontradosTableViewController.m
//  MeuRole
//
//  Created by Filipe de Souza on 26/02/15.
//  Copyright (c) 2015 Filipe de Souza. All rights reserved.
//

#import "LocaisEncontradosTableViewController.h"
#import "UIImageView+LBBlurredImage.h"
#import "AvaliacaoViewController.h"
#import "PostTableViewCell.h"
#import "Post.h"
#define HOME NSHomeDirectory()
#define DOCUMENTS [HOME stringByAppendingPathComponent:@"Documents"]
#define PATH_LUGARESENCONTRADOS [DOCUMENTS stringByAppendingPathComponent:@"lugaresEncontrados.plist"]


@interface LocaisEncontradosTableViewController ()

@end

@implementation LocaisEncontradosTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;

    
    do{
        self.numeroRandom = arc4random() % 15;
    }while (self.numeroRandom ==0);
    
    NSString *nomeImagem = [NSString stringWithFormat:@"%i", self.numeroRandom];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:nomeImagem]];
    [tempImageView setFrame:self.tableView.frame];
    
    [tempImageView setImageToBlur:[UIImage imageNamed:nomeImagem]
                                   blurRadius:kLBBlurredImageDefaultBlurRadius
                              completionBlock:^{
                                  NSLog(@"Funcionou");
                              }];
    
    self.tableView.backgroundView = tempImageView;
    //[tempImageView release];
    
//    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:nomeImagem]];
//    self.tableView.frame = CGRectMake(0,0,32,32);
    
    
    [self setNeedsStatusBarAppearanceUpdate];
    
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//    self.navigationController.navigationBar.translucent = YES;
//    self.navigationController.view.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.360];
//    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
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
    [label setText:@"Qual o seu Rolê atual"];
    [self.navigationItem setTitleView:label];
    
    [[self.btNaoTa layer] setBorderWidth:2.0f];
    [[self.btNaoTa layer] setCornerRadius:10.0f];
    [[self.btNaoTa layer] setBorderColor:[UIColor whiteColor].CGColor];
    //self.btNaoTa.backgroundColor = [UIColor colorWithWhite:0.500 alpha:0.500];
    [self.labelNaoTa setFont:[UIFont fontWithName:@"Prototype" size:25.0]];
    
    
    UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                     message:@"Foram encontrados lugares ja salvos com a sua localização atual, gostaria de ver se o local onde você está ja foi cadastrado e avaliá-lo?"
                                                    delegate:self
                                           cancelButtonTitle:@"Não"
                                           otherButtonTitles:@"Sim", nil];
    alerta.tag = 1;
    
    [alerta show];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorInset = UIEdgeInsetsMake(100, 100, 100, 100);
    self.tableView.separatorEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    
    [self atualizar];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)atualizar{
    
    [Post listarPostCompletion:^(NSArray *listaPosts) {
        
        [self.rodero endRefreshing];
        
        if (listaPosts) {
            
            self.listaPosts = listaPosts;
            
            
            
            // Atualizar a tableView
            [self.tableView reloadData];
            
        }
        
    }];
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    NSLog(@"E o array cadê: %@", self.listaPosts);
    
    return self.listaPosts.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Resgatar o post equivalente a linha atual
    Post *postAtual = [self.listaPosts objectAtIndex:indexPath.section];
    
    //cell.textLabel.text = self.locais[indexPath.row];
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.labelNome.text = [NSString stringWithFormat:@"   %@\n     %@", postAtual.nome, postAtual.tipo];
    [cell.labelNome setFont:[UIFont fontWithName:@"Prototype" size:25.0]];
    cell.labelNome.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5f];
    
//    [cell.labelNome setBackgroundColor:[UIColor clearColor]];
//    [cell.labelNome setTextColor:[UIColor whiteColor]];
//    [cell.labelNome setText:@"Qual o seu Rolê atual"];
    cell.textLabel.numberOfLines = 2;
    cell.detailTextLabel.text = postAtual.tipo;
    

    
    cell.font = [UIFont systemFontOfSize:12];
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @"";
    
}


-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    
    if (alertView.tag == 1) {
        
        if (buttonIndex == 0) {
            
            UIAlertView *alertaNao = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"Mesmo assim lhe agradecemos a tentativa. Continue registrando seus rolês!!!"
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil, nil];
            
            [alertaNao show];
            
            [self performSegueWithIdentifier:@"telaVolta" sender:self];
            
        }else if (buttonIndex == 1){
            
            //[self performSegueWithIdentifier:@"telaAvaliacao" sender:self];
            
            
        }
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"TelaAvaliacao" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    

    
    //cell.textLabel.text = self.locais[indexPath.row];
    
    
    if ([segue.identifier isEqualToString:@"TelaAvaliacao"]) {
        
        AvaliacaoViewController *proximaTela = segue.destinationViewController;
        
        NSIndexPath *indice = self.tableView.indexPathForSelectedRow;
        
        Post *postAtual = [self.listaPosts objectAtIndex:indice.section];
        
        //NSDictionary *selecionado = [self.listaPosts objectAtIndex:indice.row];
        
        proximaTela.textoRecebido = postAtual.nome;
        proximaTela.ident = postAtual.identificador;
        
        NSLog(@"Numero %@", proximaTela.textoRecebido);
        
    }
    
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
