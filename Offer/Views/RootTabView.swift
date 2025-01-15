//
//  RootTabView.swift
//  Offer
//
//  Created by arkos33 on 12/21/24.
//

import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    VStack {
                        Image(systemName: "house")
                        Text("Home")
                    }
                }
            
            PropertiesView()
                    .tabItem {
                        Label("Properties", systemImage: "building.2")
                    }
            
            AnalysisView()
                .tabItem {
                    VStack {
                        Image(systemName: "chart.bar.xaxis")
                        Text("Analysis")
                    }
                }
            
            SettingsView()
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                }
        }
    }
}

#Preview {
    RootTabView()
}
