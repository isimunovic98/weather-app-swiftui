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
    
    let screenHeight = UIScreen.main.bounds.height
    
    let viewProvider : ViewProvider
    
    init(viewmodel : HomeScreenViewModel, viewProvider : ViewProvider) {
        self.viewModel = viewmodel
        self.viewProvider = viewProvider
    }
    
    var body: some View {
        NavigationView {
            if viewModel.error {
                viewProvider.renderErrorView()
            } else {
                if viewModel.isLoading {
                    viewProvider.renderLoadingView(loadingIndicator: viewModel.isLoading)
                } else {
                    renderContentView().onAppear(perform: { viewModel.onAppear() })
                }
            }
        }
    }
    
    func renderContentView() -> some View {
        return ZStack{
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
    
    func renderBackgroundImage() -> some View {
        return Image(viewModel.screenData.backgroundImage)
            .resizable()
            .ignoresSafeArea()
    }
    
    func renderCurrentWeatherInfo() -> some View {
        return VStack {
            Text(String(viewModel.screenData.currentTemperature))
                .font(.system(size: screenHeight/12))
                .foregroundColor(.white)
                .padding()
            Text(viewModel.screenData.weatherDescription)
                .font(.system(size: screenHeight/40))
                .foregroundColor(.white)
                .padding()
        }
    }
    
    func renderHighLowTemperature() -> some View {
        return HStack {
            VStack {
                Text(String(viewModel.screenData.lowTemperature))
                    .foregroundColor(.white)
                    .font(.system(size: screenHeight/40))
                    .padding()
                Text("Low")
                    .foregroundColor(.white)
            }
            VStack {
                Text(String(viewModel.screenData.highTemperature))
                    .foregroundColor(.white)
                    .font(.system(size: screenHeight/40))
                    .padding()
                Text("High")
                    .foregroundColor(.white)
            }
        }.padding(.bottom)
    }
    
    func renderFeatures() -> some View {
        return HStack {
            Spacer()
            renderHumidity()
            Spacer()
            renderPressure()
            Spacer()
            renderWind()
            Spacer()
        }
        .padding(.horizontal)
    }
    
    func renderHumidity() -> some View {
        return VStack {
            Image("humidity_icon")
                .scaledToFit()
                .padding()
            Text(String(viewModel.screenData.humidity))
                .font(.system(size: screenHeight/40))
                .foregroundColor(.white)
        }
    }
    
    func renderPressure() -> some View {
        return VStack {
            Image("pressure_icon")
                .scaledToFit()
                .padding()
            Text(String(viewModel.screenData.pressure))
                .font(.system(size: screenHeight/40))
                .foregroundColor(.white)
        }
    }
    
    func renderWind() -> some View {
        return VStack {
            Image("wind_icon")
                .padding(.top)
                .scaledToFit()
            Text(String(viewModel.screenData.windSpeed))
                .font(.system(size: screenHeight/40))
                .foregroundColor(.white)
                .padding(.top)
        }
    }
    
    func renderFooter() -> some View {
        return HStack {
            NavigationLink(destination: SettingsScreen(backgroundImage: viewModel.screenData.backgroundImage)) {
                Image(systemName: "slider.vertical.3")
                    .resizable()
                    .foregroundColor(.white)
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.1)
            }
            NavigationLink(destination: SearchView(backgroundImage: viewModel.screenData.backgroundImage)) {
                SearchBarDummy()
            }
        }.padding()
    }
    
    func renderCityName() -> some View {
        return Text(viewModel.screenData.cityName)
            .foregroundColor(.white)
            .font(.system(size: screenHeight/40))
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let weatherRepository = WeatherRepositoryImpl()
        let viewProvider = ViewProvider()
        let homeScreenViewModel = HomeScreenViewModel(repository: weatherRepository)
        
        HomeScreen(viewmodel: homeScreenViewModel, viewProvider: viewProvider)        
    }
}
