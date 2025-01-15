//
//  SettingsViewModel.swift
//  Offer
//
//  Created by arkos33 on 12/21/24.
//

import SwiftUI
import UnsplashPhotoPicker
import Alamofire

class SettingsViewModel: ObservableObject {
    enum RowType: Hashable {
        case acknowledgements
        case changeLanguage
        case backgroundImage
    }
    
    @Published var rows: [RowType] = [.acknowledgements, .changeLanguage, .backgroundImage]
    @Published var isShowingAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var isShowingPhotoPicker = false
    
    func showAcknowledgements() {
        // Handle showing acknowledgements
    }
    
    func showLanguageAlert() {
        // Handle showing language alert
        let alert = UIAlertController(title: "Choose Language", message: "Please select a language", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "English", style: .default, handler: { _ in
            self.changeLanguage(language: .english)
        }))
        alert.addAction(UIAlertAction(title: "Spanish", style: .default, handler: { _ in
            self.changeLanguage(language: .spanish)
        }))
        alert.addAction(UIAlertAction(title: "Portuguese", style: .default, handler: { _ in
            self.changeLanguage(language: .portuguese)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let rootVC = UIApplication.shared.windows.first?.rootViewController {
            rootVC.present(alert, animated: true, completion: nil)
        }
    }
    
    private func changeLanguage(language: Language) {
        UserDefaults.standard.set([language.stringDescription()], forKey: "AppleLanguages")
        showForceCloseAlert(language: language)
    }
    
    private func showForceCloseAlert(language: Language) {
        alertTitle = "Force Close App"
        alertMessage = "The app needs to be restarted to change the language to \(language.stringDescription())."
        isShowingAlert = true
    }
    
    func showUnsplashPhotoPicker() {
        isShowingPhotoPicker = true
    }
    
    func didSelectPhotos(_ photos: [UnsplashPhoto]) {
        guard let photo = photos.first else { return }
        
        if let imageURL = photo.urls[.regular] {
            downloadImage(with: imageURL) { tempURL, response, error in
                guard let tempURL = tempURL else { return }
                
                do {
                    let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                    guard let destinationURL = docsDir?.appendingPathComponent("background_image.png") else { return }
                    
                    if FileManager.default.fileExists(atPath: destinationURL.path) {
                        try FileManager.default.removeItem(at: destinationURL)
                    }
                    try FileManager.default.copyItem(at: tempURL, to: destinationURL)
                    NotificationCenter.default.post(Notification(name: .backgroundImageUpdated))
                    self.showSuccessAlert()
                } catch let fileError {
                    self.showFailureAlert()
                    print(fileError)
                }
            }
        }
    }
    
    private func downloadImage(with imageURL: URL, completion: @escaping (URL?, URLResponse?, Error?) -> Void) {
        AF.download(imageURL).response { response in
            completion(response.fileURL, response.response, response.error)
        }
    }
    
    private func showSuccessAlert() {
        alertTitle = "Success"
        alertMessage = "Image was saved to device"
        isShowingAlert = true
    }
    
    private func showFailureAlert() {
        alertTitle = "Problem saving image"
        alertMessage = "There was a problem saving the image"
        isShowingAlert = true
    }
}
