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
    @State var shouldAnimate: Bool = false
    
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width

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
            .position(x: screenWidth/2.15 , y: shouldAnimate ? 20 : screenHeight)
            .animation(.easeInOut(duration: 0.35), value: shouldAnimate)
            .onAppear(perform: {
                shouldAnimate.toggle()
            })
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
        .frame(height: screenHeight/1.3)
        .animation(.easeInOut(duration: 0.35), value: shouldAnimate)
    }
}
