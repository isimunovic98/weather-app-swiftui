//
//  ViewProvider.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 03.03.2022..
//

import Foundation
import SwiftUI

class ViewProvider {
    
    func renderErrorView(error: Error) -> some View {
        return ZStack {
            Image("body_image-thunderstorm")
                .resizable()
                .ignoresSafeArea()
                .blur(radius: 3)
            Text("Error! + \(error.localizedDescription)")
                .font(.system(size: 20))
                .padding()
        }
    }
    
    func renderLoadingView(loadingIndicator: Bool) -> some View {
        return ZStack {
            Image("body_image-thunderstorm")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .blur(radius: 10)
            ProgressView().progressViewStyle(.circular)
        }
    }
    
}
