//
//  Info.swift
//  Pizza List
//
//  Created by Gianluca Posca
//  Copyright © Gianluca Posca. All rights reserved.
//

import SwiftUI
import MobileCoreServices
import MessageUI

struct Info: View {
    
    @Binding var dismissFlag: Bool
    @State private var isPort : Bool = true
    
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView : Bool = false
    @State var isShowingAlertMail = false
    
    var body: some View {
        VStack {
            fakebar
            placca
            Divider()
            buttons.padding(.top, -10)
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
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    var fakebar: some View {
        ZStack {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minHeight: 0, maxHeight: 26)
            HStack {
                Spacer()
                Button(action: {
                    self.dismissFlag.toggle()
                }) {
                    Text(loc("DON"))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, isPort ? 20 : 60)
                        
                }
            }
        }
        .frame(height: 44)
        .background(Color("myred").padding(.top, -44))
        .edgesIgnoringSafeArea(.horizontal)
        .padding(.bottom, -8)
    }
    
    var placca: some View {
        List {
            company
            introText
        }
    }
    
    var introText: some View {
        Text(loc("INFOTXT"))
            .font(.system(size: 20))
            .foregroundColor(Color.black)
            .fontWeight(.thin)
            .lineLimit(nil)
            .padding(.horizontal)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(.yellow)
                    .shadow(radius: 2)
            )
    }
    
    var logo: some View {
        Image("swift_logo")
            .resizable()
            .frame(width: 88, height: 88)
            .padding(.leading, 1)
            .padding(.bottom, 6)
    }
    
    var dati = """
               Gianluca Posca
               https://gianlucap17.github.io/
               """
    
    var company: some View {
        HStack {
            logo.offset(x: 3, y: 3).shadow(radius: 2)
            VStack(alignment: .leading) {
                HStack {
                    Text("Gianluca Posca")
                        .font(.headline)
                        .padding(.leading, 2)
                        .padding(.top, -14)
                        .padding(.bottom, -2)
                        .foregroundColor(Color.white)
                    Spacer()
                }
                Text(dati)
                    .font(.subheadline)
                    .padding(.leading, 2)
                    .padding(.bottom, -9)
                    .foregroundColor(Color.white)
                    .lineSpacing(-6)
            }.offset(x: 2, y: 2)
        }.background(
            RoundedRectangle(cornerRadius: 22)
                .foregroundColor(.orange)
                .shadow(radius: 2)
        )
    }
        
    var buttons: some View {
        HStack(spacing:16) {
            
            /// # Button Mail
            Button(action: {
                if MFMessageComposeViewController.canSendText() {
                    self.isShowingMailView = true
                } else {
                    self.isShowingAlertMail = true
                }
            }) {
                Image(systemName: "envelope.circle.fill")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                    .shadow(radius: 1)
            }
            .background(Color.blue)
                .cornerRadius(10)
                .shadow(radius: 2)
            
            /// # Button Open Link
            Button(action: {
                if let url = URL(string: "https://www.swift.srl"), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }) {
                Image(systemName: "globe")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                    .shadow(radius: 1)
            }
            .background(Color.green)
                .cornerRadius(10)
                .shadow(radius: 2)
        }
        .padding()
        .sheet(isPresented: $isShowingMailView) {
            MailView(isShowing: self.$isShowingMailView, result: self.$result)
        }
        .alert(isPresented: $isShowingAlertMail) {
            Alert(title: Text(loc("WARN")),
                  message: Text(loc("NOMAWACO")),
                  dismissButton: Alert.Button.default(Text("OK")))
        }
    }
}

struct Info_Previews: PreviewProvider {
    static var previews: some View {
        Info(dismissFlag: .constant(true))
        //.environment(\.colorScheme, .dark)
    }
}
