//
//  SearchView.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 02.03.2022..
//

import SwiftUI
import Combine

struct SearchView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: SearchScreenViewModel
    @State var text = ""
    
    let backgroundImage: String
    
    init(backgroundImage: String, viewModel: SearchScreenViewModel) {
        self.backgroundImage = backgroundImage
        self.viewModel = viewModel
        UITableView.appearance().backgroundColor = .white.withAlphaComponent(0)
    }
    
    var body: some View {
        renderContentView()
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar(
                content: {
                    ToolbarItem(placement: .navigationBarLeading)
                    {
                        Button(
                            action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        )
                        {
                            Image(systemName: "chevron.backward")
                                .foregroundColor(.black)
                        }
                    }
                }
            )
        
    }
    
    func renderContentView() -> some View {
        ZStack {
            renderBackgroundImage()
            VStack {
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
        let searchBar = SearchBar(text: $text)
        return searchBar
            .onChange(
                of: text,
                perform: { newCity in
                    viewModel.getLocation(cityName: newCity)
                }
            )
            .padding()
    }
    
    func renderList() -> some View {
        return List {
            ForEach(viewModel.cities , id: \.self) { city in
                Text(city.name)
                    .onTapGesture {
                        viewModel.didSelectCity(geoItem: city)
                        self.presentationMode.wrappedValue.dismiss()
                    }
            }
            .listRowBackground(Color.white.opacity(0.8))
        }
    }
}
