//
//  PizzaModel.swift
//  Static TableView
//
//  Created by Gianluca Posca
//  Copyright © Gianluca Posca. All rights reserved.
//

import SwiftUI
import Combine

/// # LEGGI DA QUI
/// questo è il modello di dati intorno al quale ruota tutta l'App
/// le istanze di questa classe saranno riempite con i dati delle pizze e messe in un array dentro a DataManager
/// aggiungiamo il protocollo Codable in modo da poter salvare i dati in un file
/// aggiungiamo il protocollo Identifiable in modo da permettere a SwiftUI di trovare da solo le istanze nell'array
class PizzaModel: Codable, Identifiable, ObservableObject {

    /// creiamo le var che conterranno e rappresenteranno i dati delle pizze
    var id: UUID = UUID()
    var nome : String
    var ingredienti : String
	var calorie : String
    var immagine : Data?
    
    /// variabili a cui "tarocchiamo" il GET
    var realImg : UIImage {
        let realImg = UIImage(data: immagine ?? Data())
        return realImg ?? #imageLiteral(resourceName: "pizza")
    }

    /// ogni volta che leggiamo questa var viene calcolato al volo il colore corretto
    var coloreCalorie : Color {
        /// trasformiamo la var calorie (che è una String) in un Int
        /// facciamo l'if let per controllare se ce la fa
        /// se l'utente inserisce un carattere diverso da uno numerico la trasformazione fallisce
        if let calorieTest = Int(calorie) {
            /// ora vediamo il valore di calorie con l'elegantissimo switch di Swift
            switch calorieTest {
            case 0...400: return Color.white
            case 401...800: return Color.yellow
            case 801...1200: return Color.orange
            case 1201...1800: return Color.red
            case 1801...2000: return Color.purple
            /// se nessun caso si verifica vuol dire che l'utente ha inserito più di 2000 calorie
            /// allora scatta il default, e restituiamo il colore nero
            default: return Color.black
            }
        }
        return .blue
    }
    
    var coloreTestoCalorie : Color {
        switch coloreCalorie {
            case .white, .yellow: return Color.black
            default: return Color.white
        }
    }
    
    func aggiornaUI() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    /// il classico init che ci da una mano a caricare le istanze in memoria
    init(nome: String, ingredienti: String, calorie: String, immagine: Data?) {
        self.nome = nome
        self.ingredienti = ingredienti
        self.calorie = calorie
        self.immagine = immagine
    }
    
}
