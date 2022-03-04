//
//  ContentView.swift
//  Shared
//
//  Created by Domagoj Bunoza on 28.02.2022..
//

import SwiftUI

struct HomeScreen: View {
    @ObservedObject var viewModel : HomeScreenViewModel
    @State private var searchText = ""
    
    let viewProvider : ViewProvider
    
    init(viewmodel : HomeScreenViewModel, viewProvider : ViewProvider) {
        self.viewModel = viewmodel
        self.viewProvider = viewProvider
    }
    
    var body: some View {
        if viewModel.error != nil {
            viewProvider.renderErrorView(error: viewModel.error!)
        } else {
            if viewModel.isLoading {
                viewProvider.renderLoadingView(loadingIndicator: viewModel.isLoading)
            } else {
                renderContentView()
            }
        }
    }
    
    func renderContentView() -> some View {
        return NavigationView {
            ZStack{
                renderBackgroundImage()
                VStack {
                    Spacer()
                    renderCurrentWeatherInfo()
                    VStack {
                        renderCityName()
                        renderHighLowTemperature()
                        renderFeatures()
                        renderFooter()
                    }
                }
            }.navigationViewStyle(.stack)
        }
    }
    
    func renderBackgroundImage() -> some View {
        return Image(viewModel.screenData.backgroundImage)
            .resizable()
            .ignoresSafeArea()
    }
    
    func renderCurrentWeatherInfo() -> some View {
        return VStack {
            Text(String(viewModel.screenData.currentTemperature))
                .font(.system(size: 80))
                .foregroundColor(.white)
                .padding()
            Text(viewModel.screenData.weatherDescription)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .padding()
        }
    }
    
    func renderHighLowTemperature() -> some View {
        return HStack {
            VStack {
                Text(String(viewModel.screenData.lowTemperature))
                    .foregroundColor(.white)
                    .padding()
                Text("Low")
                    .foregroundColor(.white)
            }
            Divider().frame(maxHeight: 100);
            VStack {
                Text(String(viewModel.screenData.highTemperature))
                    .foregroundColor(.white)
                    .padding()
                Text("High")
                    .foregroundColor(.white)
            }
        }.padding()
    }
    
    func renderFeatures() -> some View {
        return HStack {
            Spacer()
            VStack {
                Image("humidity_icon")
                    .scaledToFit()
                    .padding()
                Text(String(viewModel.screenData.humidity))
                    .foregroundColor(.white)
            }
            Spacer()
            VStack {
                Image("pressure_icon")
                    .scaledToFit()
                    .padding()
                Text(String(viewModel.screenData.pressure))
                    .foregroundColor(.white)
            }
            Spacer()
            VStack {
                Image("wind_icon")
                    .padding(.top)
                    .scaledToFit()
                Text(String(viewModel.screenData.windSpeed))
                    .foregroundColor(.white)
                    .padding(.top)
            }
            Spacer()
        }
        .padding()
    }
    
    func renderFooter() -> some View {
        return HStack {
            NavigationLink(destination: SettingsScreen(backgroundImage: viewModel.screenData.backgroundImage)) {
                Image("settings_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.125)
            }
            NavigationLink(destination: SearchView(backgroundImage: viewModel.screenData.backgroundImage)) {
                SearchBarDummy()
            }
        }.padding()
    }
    
    func renderCityName() -> some View {
        return Text(viewModel.screenData.cityName)
            .foregroundColor(.white)
            .font(.system(size: 20))
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let weatherRepository = WeatherRepositoryImpl()
        let persistence = Database()
        let viewProvider = ViewProvider()
        let homeScreenViewModel = HomeScreenViewModel(repository: weatherRepository, persistence: persistence)

        HomeScreen(viewmodel: homeScreenViewModel, viewProvider: viewProvider)
    }
}
