//
//  SearchView.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 02.03.2022..
//

import SwiftUI
import Combine

struct SearchView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @ObservedObject var viewModel : SearchScreenViewModel
    @State var text = ""
    
    let backgroundImage : String
    
    init(backgroundImage: String) {
        self.backgroundImage = backgroundImage
        self.viewModel = SearchScreenViewModel(repository: LocationRepositoryImpl(), persistence: UserDefaultsManager())
        UITableView.appearance().backgroundColor = .white.withAlphaComponent(0)
    }
    
    var body : some View {
        ZStack {
            renderBackgroundImage()
            VStack{
                renderSearchBar()
                renderList()
                Spacer()
            }
        }
    }
    
    func renderBackgroundImage() -> some View {
        return Image(backgroundImage)
            .resizable()
            .ignoresSafeArea()
            .blur(radius: 20)
    }
    
    func renderSearchBar() -> some View {
        return SearchBar(text: $text)
            .onSubmit {
                viewModel.startViewmodel(cityName: text)
            }
    }
    
    func renderList() -> some View {
        return List {
            ForEach(viewModel.cities , id: \.self) { city in
                Text(city.name).onTapGesture {
                    viewModel.selectedCity(geoItem: city)
                    self.mode.wrappedValue.dismiss()
                }
                
            }.listRowBackground(Color.white.opacity(0.8))
        }
    }
}
