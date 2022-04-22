//
//  ListController.swift
//  Pizza List
//
//  Created by Gianluca Posca
//  Copyright (c) Gianluca Posca. All rights reserved.
//

import UIKit

/// questo file / classe pilota la tableView con le celle rosse
class ListController: UITableViewController {

    // MARK: - Metodi standard del controller
    
    /// metodo che scatta quando il controller ha caricato la sua view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// impostiamo lo stile della barra di navigazione come nero traslucente
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        /// impostiamo la traslucenza della barra
        navigationController?.navigationBar.isTranslucent = true
        
        /// impostiamo il colore dei pulsanti su bianco
        navigationController?.navigationBar.tintColor = UIColor.white
        
        /// mettiamo il logo dell'App al centro della barra di navigazione
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo"))
        
        /// coloriamo la table di rosso
        tableView.backgroundColor = #colorLiteral(red: 0.9685894847, green: 0.137067616, blue: 0.006864311639, alpha: 1)
    
        /// riempiamo la var listCont (contenuta in DataManager) con il puntatore di questo controller
        /// grazie a questo trucco potremo raggiugere questo controller da qualsiasi punto dell'App
        DataManager.shared.listCont = self

    }
    
    // MARK: - Table View

    /// metodo della table che chiede qante celle fare per ogni sezione
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /// gli diciamo di fare tante celle quante istanze di PizzaModel abbiamo nell'array
        /// la var count è il conteggio delle var nell'array
        return DataManager.shared.storage.count
    }

    /// metodo della table che crea le celle, chiamato tante volte quante indicate nel metodo precedente
    /// ad ogni chiama il valore della var indexPath cambia e rispecchia l'indice dell'array
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /// creiamo la cella e gli diciamo di fare una PizzaCell invece di quella standard
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PizzaCell

        /// in base al numero della cella estraiamo dall'array l'istanza di PizzaModel appropriata
        let pizza = DataManager.shared.storage[indexPath.row]
        
        /// ora che abbiamo recuperato l'istanza di PizzaModel leggiamo le var per mettere i dati a video
        cell.labelName.text = pizza.nome
        cell.labelIngredienti.text = pizza.ingredienti
        cell.immaginePizza.image = pizza.immaginePronta
        cell.viewColoreCalorie.backgroundColor = pizza.coloreCalorie
		
        /// restituiamo la cella così conciata
        return cell
    }

    /// metodo della table che chiede se vogliamo abilitare la modifica alle celle
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        /// diciamo di si per abilitare lo swipe che apre il cassetto con il button Cancella
        return true
    }

    /// metodo della table che scatta quando l'utente tocca il tasto cancella di una cella
    /// nella var indexPath sta l'indice della cella cancellata
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            /// eliminiamo l'istanza di PizzaModel dall'array in base all'indice della cella toccata
            DataManager.shared.storage.remove(at: indexPath.row)
            
            /// salviamo l'array
            DataManager.shared.salva()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    /// # MODIFICA TODAY
    /// Nello storyboard è stato tirato un filo dalla caramella di ListController al corpo di DetailController
    /// questo ha creato un segue manuale che ho chiamato dawidget"
    
    /// aggiungiamo questo metodo per aprire via codice il DetailController
    func mostraDettaglioConPizzaIndex(_ index:Int?) {
        /// invochiamo il segue manuale e gli passiamo index come sender (così lo possiamo leggere nel metodo prepareForSegue)
        performSegue(withIdentifier: "dawidget", sender: index)
    }

    // MARK: - Navigazione
    /// metodo che scatta quando l'utente tocca una cella della table e apre il dettaglio
    /// per creare la navigazione è stato tirato un filo dalla cella prototipo al corpo del DetailController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        /// controlliamo che il nome del segue corrisponda alla parola dettaglio
        if segue.identifier == "dettaglio" {
            
            /// controlliamo quale cella è stata toccata
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                /// estraiamo dal segue il DetailController
                let controller = segue.destination as! DetailController
                
                /// gli passiamo l'istanza della pizza presa dall'array in base all'indice della cella toccata
                /// in pratica se tocca la margherita passiamo al dettaglio la margherita
                controller.pizza = DataManager.shared.storage[indexPath.row]
                
            }
        }
        ///# MODIFICA TODAY
        else if segue.identifier == "dawidget" {
            /// estraiamo dal segue il DetailController
            let controller = segue.destination as! DetailController
            
            /// in questo caso è il widget che ha invocato l'App, quindi leggiamo l'Int passato come sender
            /// e lo usiamo per passare la pizza (istanza di PizzaModel con dentro i dati di una pizza) corretta
            /// il downcast as! Int è necessario perchè sender è un AnyObject (è scritto qui sopra, var di prepareForSegue)
            controller.pizza = DataManager.shared.storage[sender as! Int]
        }
    }

}

