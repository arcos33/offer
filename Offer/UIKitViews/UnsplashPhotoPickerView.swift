//
//  UnsplashPhotoPickerView.swift
//  Offer
//
//  Created by arkos33 on 12/21/24.
//

import SwiftUI
import UnsplashPhotoPicker

struct UnsplashPhotoPickerView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    var didSelectPhotos: ([UnsplashPhoto]) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UnsplashPhotoPicker {
        let configuration = RealEstateService.shared.unsplashConfiguration()
        let picker = UnsplashPhotoPicker(configuration: configuration)
        picker.photoPickerDelegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UnsplashPhotoPicker, context: Context) {
        if !isPresented {
            uiViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    class Coordinator: NSObject, UnsplashPhotoPickerDelegate {
        var parent: UnsplashPhotoPickerView
        
        init(_ parent: UnsplashPhotoPickerView) {
            self.parent = parent
        }
        
        func unsplashPhotoPicker(_ photoPicker: UnsplashPhotoPicker, didSelectPhotos photos: [UnsplashPhoto]) {
            parent.didSelectPhotos(photos)
            parent.isPresented = false
        }
        
        func unsplashPhotoPickerDidCancel(_ photoPicker: UnsplashPhotoPicker) {
            parent.isPresented = false
        }
    }
}
