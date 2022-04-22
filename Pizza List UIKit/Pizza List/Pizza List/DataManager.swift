//
//  DataManager.swift
//  Pizza List
//
//  Created by Gianluca Posca
//  Copyright (c) Gianluca Posca. All rights reserved.
//

import UIKit

class DataManager {
    
    // MARK: - Singleton
    ///***** CODICE SPECIALE CHE TRASFORMA QUESTA CLASSE IN UN SINGLETON (snippet sw_sgt)*****\\
    static let shared = DataManager()

    // MARK: - variabili globali
    
    /// creiamo un array che possa contenere delle istanze di PizzaModel
    var storage : [PizzaModel] = []
	
	/// creiamo un alias per poter caricare i salvataggi
	typealias Storage = [PizzaModel]
	
	///# MODIFICA TODAY
	/// non hanno più i nomi dei veri controller (ma dei padri)
	/// se no questo file non si compila con la today extension
	var listCont : UIViewController?
	var detailController : UIViewController?
    
    /// creiamo una variabile che contenga il percorso al file da leggere / salvare
    var filePath : String!
    
    // MARK: - Metodi
    func caricaDati() {
        
		///# MODIFICA TODAY
		/// va usata la sandbox condivisa per avere i dati nel today
		/// per attivare la sandbox condivisa va acceso lo switch AppGroup nel pannello Capabilities
		/// premere il + per aggiungere un gruppo e dargli un nome di fantasia tipo: group.tuonome.nomeappgroup
		guard let sharedSandbox = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.swiftsrl.pizzagroup")?.path else { return }
		
		/// creiamo il percorso al file
		filePath = sharedSandbox + "/pizze.plist"
        
        /// usiamo NSFileManager per sapere se esiste un file a quel percorso
        if FileManager.default.fileExists(atPath: filePath) {
            
			/// se c'è de-archiviamo il file di testo nell'array
			/// serve il blocco do try catch
			do {
				/// proviamo a caricare il file dal percorso creato in precedenza
				let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
				/// creiamo il decoder
				let decoder = PropertyListDecoder()
				/// proviamo a decodificare il file nell'array
				storage = try decoder.decode(Storage.self, from: data)
			} catch {
				/// se non ce la fa scriviamo in console l'errore
				debugPrint(error.localizedDescription)
			}
            
            /// adesso abbiamo i dati e possiamo far andare l'App
            
        } else {
            
            /// se il file non c'è allora creiamo 2 istanze di PizzaModel
            let margherita = PizzaModel(nome: "Margherita",
                                        ingredienti: loc("MARGHERITA_ING"),
                                        calorie: "813",
                                        immagine: #imageLiteral(resourceName: "margherita").pngData())
            
            let marinara = PizzaModel(nome: "Marinara",
                                      ingredienti: loc("MARINARA_ING"),
                                      calorie: "720",
                                      immagine: #imageLiteral(resourceName: "marinara").pngData())
            
            /// inseriamo le istanze nell'array
            storage = [margherita, marinara]
            
            /// lanciamo il metodo salva() che archivierà le istanze di PizzaModel nel file di testo
            salva()
        }
    }
	
	/// metodo per creare una nuova pizza
	func nuovaPizza(nome:String, ingredienti:String, calorie:String, immagine:UIImage) {
		
		let nuovaPizza = PizzaModel(nome: nome,
		                            ingredienti: ingredienti,
		                            calorie: calorie,
		                            immagine: immagine.pngData())
		
		/// aggiungiamo la nuova istanza nell'Array
		storage.append(nuovaPizza)
		
		/// salviamo i dati
		salva()
			
	}
    
    // questo merodo salva le istanze di PizzaModel che stanno nell'array
    func salva() {
		// creiamo l'encoder
		let encoder = PropertyListEncoder()
		encoder.outputFormat = .xml // impostiamo l'output corretto
		// serve il blocco do try catch
		do {
			// proviamo a codificare l'array
			let data = try encoder.encode(storage)
			// proviamo a salvare l'array codificato nel file
			try data.write(to: URL(fileURLWithPath: filePath))
		} catch {
			// se non ce la fa scriviamo in console l'errore
			debugPrint(error.localizedDescription)
		}
    }
    
    // metodo per calcolare la posizione della Cartella Documents nella sandbox della nostra App
    func cartellaDocuments() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        //print(paths[0])
        return paths[0]
    }
    
}
