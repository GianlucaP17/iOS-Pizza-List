//
//  Add.swift
//  Pizza List
//
//  Created by Gianluca Posca
//  Copyright © Gianluca Posca. All rights reserved.
//

import SwiftUI

var isShoot = false
var isAnEdit = false

struct Add: View {
    
    var dataManager: DataManager = DataManager.shared
    @Binding var dismissFlag: Bool
    
    @State var nome: String = ""
    @State var ingredienti: String = ""
    @State var calorie: String = ""
    @State var image: UIImage?
    
    var pizza : PizzaModel?
    
    var imageToShow: Image? {
        if let imageOk = image {
            return Image(uiImage: imageOk)
        } else {
            return nil
        }
    }
    
    @State var isAlertOut = false
    @State var isSheetOut = false
    @State var isPhotopickOut = false    
    @State var isPort : Bool = true
    
    // MARK: - Interfaccia
    var body: some View {

        VStack {
            // Barra
            fakebar
            
            // campi + immagine
            List {
                TextField(loc("NAM"), text: $nome)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField(loc("ING"), text: $ingredienti)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField(loc("CAL"), text: $calorie)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                (imageToShow.map { $0 } ?? Image("pizza"))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .onTapGesture { self.isSheetOut = true }
            }
            .actionSheet(isPresented: $isSheetOut, content: {
                self.actionSheet
            })
            .sheet(isPresented: $isPhotopickOut) {
                self.libPick
            }
            
        }
        .onAppear {
            let didRotate: (Notification) -> Void = { notification in
              // the other orientations
              switch UIDevice.current.orientation {
                case .landscapeLeft, .landscapeRight: self.isPort = false
                case .portrait: self.isPort = true
                default: print("other")
              }
            }
            
            NotificationCenter.default.addObserver(
              forName: UIDevice.orientationDidChangeNotification,
              object: nil,
              queue: .main,
              using: didRotate
            )
            
            if isAnEdit { return }
            if let pizza = self.pizza {
                self.nome = pizza.nome
                self.ingredienti = pizza.ingredienti
                self.calorie = pizza.calorie
                self.image = pizza.realImg
                isAnEdit = true
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    // MARK: - Tricks
    var fakebar: some View {
        ZStack {
            /// titolo
            HStack {
                Spacer()
                Text(loc("Add_Pizza"))
                    .font(.headline)
                    .foregroundColor(Color.white)
                Spacer()
            }
            /// pulsanti
            HStack {
                Button(action: {
                    self.dismissFlag = false
                    self.resetUI()
                }) {
                    Text(loc("CAN"))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, isPort ? 20 : 60)
                }
                Spacer()
                Button(action: { self.salva() }) {
                    Text(loc("SAV"))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, isPort ? 20 : 60)
                }.alert(isPresented: $isAlertOut, content: { self.alert })
            }
        }
        .frame(height: 44)
        .background(Color("myred").padding(.top, -44))
        .edgesIgnoringSafeArea(.horizontal)
        .padding(.bottom, -8)
    }
    
    var actionSheet: ActionSheet {
        ActionSheet(title: Text(loc("ASPHTTIT")),
                    message: Text(loc("ASPHTMSG")),
                    buttons: [
                        .default(Text(loc("ASPHTLIB"))) {
                            isShoot = false
                            self.isPhotopickOut = true
                        },
                        .default(Text(loc("ASPHTSHO"))) {
                            isShoot = true
                            self.isPhotopickOut = true
                        },
                        .cancel { debugPrint("Toccato: Annulla") }
                    ])
    }

    var libPick: some View {
        ImagePicker(shootNew: isShoot, needEdit: false, image: $image, isPresented: $isPhotopickOut)
    }
 
    var alert: Alert {
        Alert(title: Text(loc("WARN")),
                message: Text(loc("ALFILREQ")),
                dismissButton: .default(Text("OK")))
    }
    
    // MARK: - Azioni
    func salva() {
        if !self.nome.isEmpty && !self.ingredienti.isEmpty && !self.calorie.isEmpty {
            
            if let pizza = self.pizza {
                self.dataManager.modificaPizza(pizzaID: pizza.id,
                                               nome: self.nome,
                                               ingredienti: self.ingredienti,
                                               calorie: self.calorie,
                                               immagine: self.image)
            } else {
                self.dataManager.nuovaPizza(nome: self.nome,
                                            ingredienti: self.ingredienti,
                                            calorie: self.calorie,
                                            immagine: self.image)
            }
            self.dismissFlag = false
            self.resetUI()
        } else {
            self.isAlertOut = true
        }
    }
    
    func resetUI() {
        delay(0.5) {
            self.nome = ""
            self.ingredienti = ""
            self.calorie = ""
            self.image = nil
            isAnEdit = false
        }
    }
}

struct Add_Previews: PreviewProvider {
    static var previews: some View {
        Add(dataManager: DataManager(), dismissFlag: .constant(true))
        //.environment(\.colorScheme, .dark)
    }
}
