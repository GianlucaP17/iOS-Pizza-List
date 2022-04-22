//
//  Detail.swift
//  Pizza List
//
//  Created by Gianluca Posca
//  Copyright © Gianluca Posca. All rights reserved.
//

import SwiftUI

struct Detail: View {

    @ObservedObject var pizza: PizzaModel
    
    @State var isSharePresented = false
    @State var isAlertOut = false
    @State var isAddPresented = false
    
    var items : [Any] {
        return [pizza.realImg, pizza.nome]
    }
    
    var calorie : Double {
        return Double(pizza.calorie) ?? 0
    }
    
    var alert: Alert {
        Alert(title: Text(loc("HEALTHALRTTIT")),
              message: Text(loc("HEALTHALRMSG")),
              dismissButton: .default(Text("OK")))
    }
    
    var body: some View {
        VStack {
            VStack {
                /// # Calorie
                HStack {
                    Spacer()
                    Text(self.pizza.calorie)
                        .frame(width: 70, height: 70)
                        .background(self.pizza.coloreCalorie)
                        .font(.headline)
                        .foregroundColor(self.pizza.coloreTestoCalorie)
                        .cornerRadius(35)
                        .padding()
                        .overlay(Circle().stroke(Color.white, lineWidth: 4).padding())
                }
                Spacer()
                
                /// # ingredienti
                HStack {
                    Spacer()
                    Text(self.pizza.ingredienti)
                        .font(.body)
                        .fontWeight(.light)
                        .foregroundColor(Color.white)
                        .padding()
                        .lineLimit(nil)
                    Spacer()
                }.background( Color.red.opacity(0.8) )
            }
            .background(
                Image(uiImage: self.pizza.realImg)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            )
            
            /// # Toolbar
            HStack {
                eatButton.padding(.horizontal, 16).offset(x: 0, y: -5)
                Spacer()
                shareButton.padding(.horizontal, 16).offset(x: 0, y: -5)
                Spacer()
                editButton.padding(.horizontal, 16).offset(x: 0, y: -5)
            }
            .frame(height: 44)
                .background( /// per fissare un potenziale bug
                    Color("mywhite")
                        .padding(.top, -8)
                        .padding(.bottom, -34))
            
        }
        .navigationBarTitle(Text(self.pizza.nome))
        .contextMenu { eatButton }
        .edgesIgnoringSafeArea(.horizontal)
    }
    
    var eatButton : some View {
        Button(action: {
            HealthManager.shared.aggiungiCalorie(nome: self.pizza.nome, calorie: self.calorie * 1000) {
                self.isAlertOut = true
             }
        }) { Image(systemName: "smiley.fill").font(Font.system(size: 28)) }
            .alert(isPresented: $isAlertOut, content: { self.alert })
            .foregroundColor(.red)
    }
    
    var shareButton : some View {
        Button(action: { self.isSharePresented = true }) {
            Image(systemName: "arrow.up.circle.fill")
                .font(Font.system(size: 28))
        }
        .sheet(isPresented: $isSharePresented) {
            ActivityView(isPresented: self.$isSharePresented,
                        activityItems: self.items,
                        applicationActivities: nil)
        }
        .foregroundColor(.red)
    }
    
    var editButton : some View {
        Button(action: { self.isAddPresented = true }) {
            Image(systemName: "pencil.circle.fill")
                .font(Font.system(size: 28))
        }.sheet(isPresented: $isAddPresented) {
            Add(dismissFlag: self.$isAddPresented, pizza: self.pizza)
                .modifier(DisableModalDismiss(disabled: true))
        }
        .foregroundColor(.red)
    }
    
}

struct Detail_Previews: PreviewProvider {
    static var previews: some View {
        return NavigationView {
            Detail(pizza: PizzaModel(nome: "Margherita", ingredienti: "Pomodoro, Mozzarella, Prosciutto, Funghi, Cipolla, Carciofi, Patate Fritte, Coppa, Salame, Uova", calorie: "849", immagine: #imageLiteral(resourceName: "margherita").pngData()))
                }
    }
}
