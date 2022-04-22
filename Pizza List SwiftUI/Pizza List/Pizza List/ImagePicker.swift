//
//  ImagePicker.swift
//  Caricare Immagine
//
//  Created by Gianluca Posca
//  Copyright © Gianluca Posca. All rights reserved.
//

import SwiftUI
import MobileCoreServices

struct ImagePicker: UIViewControllerRepresentable {
    
    var shootNew: Bool
    var needEdit: Bool
    @Binding var image: UIImage?
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = shootNew ? .camera : .photoLibrary
        picker.allowsEditing = needEdit
        picker.mediaTypes = [kUTTypeImage] as [String]
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(shootNew: shootNew, needEdit: needEdit, image: $image, isPresented: $isPresented)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        var shootNew: Bool
        var needEdit: Bool
        @Binding var image: UIImage?
        @Binding var isPresented: Bool
        
        init(shootNew: Bool, needEdit: Bool, image: Binding<UIImage?>, isPresented:Binding<Bool>) {
            self.shootNew = shootNew
            self.needEdit = needEdit
            _image = image
            _isPresented = isPresented
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
            info: [UIImagePickerController.InfoKey : Any]) {
            
            var uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            if needEdit {
                uiImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
            }
            
            self.image = uiImage
            self.isPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.isPresented = false
        }
    }
}
