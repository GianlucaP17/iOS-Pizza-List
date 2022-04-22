//
//  DataManager.swift
//  Pizza List
//
//  Created by Gianluca Posca
//  Copyright © Gianluca Posca. All rights reserved.
//

import SwiftUI
import Combine

class DataManager: ObservableObject {
        
    static let shared = DataManager()
        
    var storage: [PizzaModel] = [] {
        didSet {
            objectWillChange.send() // dice all'interfaccia di aggiornarsi
        }
    }
    
    /// questo trick serve per decodificare un array di PizzaModel
    typealias Storage = [PizzaModel]
    
    /// questa var serve per contenere il percorso al file di salvataggio delle pizze
    var filePath : String = ""
    
    // MARK: - Init
    /// creiamo una nostra implementazione del metodo init...
    /// in cui invochiamo il metodo caricaDati che da il via a tutto
    init() { caricaDati() }
    
    /// metodo necessario a caricare in memoria le pizze
    func caricaDati() {
        
        /// creiamo il percorso al file
        filePath = cartellaDocuments() + "/pizze.plist"
        
        /// usiamo NSFileManager per sapere se esiste un file a quel percorso
        if FileManager.default.fileExists(atPath: filePath) {
            
            /// se c'è de-archiviamo il file di testo nell'array
            /// serve il blocco do try catch                
            do {
                /// proviamo (try) a caricare il file dal percorso creato in precedenza
                let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
                /// creiamo il decoder
                let decoder = PropertyListDecoder()
                /// proviamo (try) a decodificare il file nell'array
                storage = try decoder.decode(Storage.self, from: data)
            } catch {
                /// se non ce la fa stampiamo l'errore in console
                debugPrint(error.localizedDescription)
            }
            
        } else {
            /// durante il primo lancio il file delle pizza non esiste
            /// quindi scatterà l'else, ovvero questo blocco di codice
                        
            /// creiamo 2 istanze di PizzaModel
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
            
            /// lanciamo il metodo salva()
            /// che archivierà le istanze di PizzaModel nel file di testo
            salva()
        }
    }
    
    // MARK: - Metodi Utili
    /// metodo per creare una nuova pizza
    func nuovaPizza(nome:String, ingredienti:String, calorie:String, immagine:UIImage?) {
        /// facciamo una nuova istanza
        let nuovaPizza = PizzaModel(nome: nome,
                                    ingredienti: ingredienti,
                                    calorie: calorie,
                                    immagine: immagine?.pngData())
        
        /// aggiungiamo la nuova istanza nell'Array
        storage.insert(nuovaPizza, at: 0)
        
        /// salviamo i dati
        salva()
    }
    
    func modificaPizza(pizzaID: UUID, nome:String, ingredienti:String, calorie:String, immagine:UIImage?) {
        
        /// troviamo la pizza da modificare
        if let pizza = (storage.filter { $0.id.uuidString == pizzaID.uuidString }).first {
            /// modifichiamo i dati
            pizza.nome = nome
            pizza.ingredienti = ingredienti
            pizza.calorie = calorie
            pizza.immagine = immagine?.pngData()
            pizza.aggiornaUI() /// dice all'interfaccia di aggiornarsi
            
            /// salviamo i dati
            salva()
        }
    }
    
    func cancellaPizza(index:Int) {
        storage.remove(at: index)
        salva()
    }
    
    /// questo metodo salva le istanze di PizzaModel che stanno nell'array
    func salva() {
        /// creiamo l'encoder necessario per salvare
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml // impostiamo l'output corretto
        /// serve il blocco do try catch
        do {
            /// proviamo a codificare l'array
            let data = try encoder.encode(storage)
            /// proviamo a salvare l'array codificato nel file
            try data.write(to: URL(fileURLWithPath: filePath))
        } catch {
            /// se non ce la fa scriviamo in console l'errore
            debugPrint(error.localizedDescription)
        }
    }

}
