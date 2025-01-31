//
//  SettingsView.swift
//  Offer
//
//  Created by arkos33 on 12/21/24.
//

import SwiftUI
import UnsplashPhotoPicker

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.rows, id: \.self) { row in
                    switch row {
                    case .acknowledgements:
                        NavigationLink("Acknowledgements", destination: AcknowledgementsView())
                    case .changeLanguage:
                        Button("Change Language") {
                            viewModel.showLanguageAlert()
                        }
                    case .backgroundImage:
                        Button("Change Background Image") {
                            viewModel.showUnsplashPhotoPicker()
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .alert(isPresented: $viewModel.isShowingAlert) {
                Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .sheet(isPresented: $viewModel.isShowingPhotoPicker) {
            UnsplashPhotoPickerView(isPresented: $viewModel.isShowingPhotoPicker, didSelectPhotos: viewModel.didSelectPhotos)
        }
        .draggableDebugViewName("SettingView")
    }
}

#Preview {
    SettingsView()
}
