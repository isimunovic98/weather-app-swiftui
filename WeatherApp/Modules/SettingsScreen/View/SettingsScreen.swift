//
//  SettingsScreen.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 03.03.2022..
//

import SwiftUI
import Combine

struct SettingsScreen: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel : SettingsScreenViewModel
    
    let backgroundImage : String
    
    init(backgroundImage: String) {
        self.backgroundImage = backgroundImage
        self.viewModel = SettingsScreenViewModel()
        UITableView.appearance().backgroundColor = .white.withAlphaComponent(0)
    }
    
    var body : some View {
        renderContentView()
            .onAppear(perform: {viewModel.onAppear()})
    }
    
    func renderContentView() -> some View {
        ZStack {
            renderBackgroundImage()
            VStack{
                renderLocationHistory()
                renderUnitSelection()
                HStack{
                    Spacer()
                    renderHumidity()
                    Spacer()
                    renderPressure()
                    Spacer()
                    renderWind()
                    Spacer()
                }
            }
        }
    }
    
    func renderBackgroundImage() -> some View {
        return Image(backgroundImage)
            .resizable()
            .ignoresSafeArea()
            .blur(radius: 20)
    }
    
    func renderLocationHistory() -> some View {
        return VStack{
            HStack {
                Text("History")
                    .font(.system(size: 40))
                    .padding()
                    .foregroundColor(.white)
                Spacer()
            }
            List {
                ForEach(viewModel.screenData.cities , id: \.self) { city in
                    HStack{
                        Text(city.name).onTapGesture {
                            viewModel.selectedCity(geoItem: city)
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        Spacer()
                        Image(systemName: "multiply.circle.fill")
                            .foregroundColor(.gray)
                            .onTapGesture {
                                viewModel.selectedDeleteCity(geoItem: city)
                            }
                    }
                }.listRowBackground(Color.white.opacity(0.8))
            }
        }
    }
    
    func renderUnitSelection() -> some View {
        return RadioButtonGroup(items: ["Imperial", "Metric"] , selectedId: viewModel.persistence.fetchMeasuringUnit()) { selected in
            viewModel.selectMeasuringUnit(unit: selected)
        }
        .foregroundColor(.white)
        .padding()
    }
    
    func renderHumidity() -> some View {
        return VStack {
            CheckView(
                isChecked: viewModel.screenData.humidity,
                title: "Humidity", action: {
                    viewModel.toggleFeature(feature: "humidity")
                }
            )
            Image("humidity_icon")
                .scaledToFit()
                .padding()
        }
    }
    
    func renderPressure() -> some View {
        return VStack {
            CheckView(
                isChecked: viewModel.screenData.pressure,
                title: "Pressure", action: {
                    viewModel.toggleFeature(feature: "pressure")
                }
            )
            Image("pressure_icon")
                .scaledToFit()
                .padding()
        }
    }
    
    func renderWind() -> some View {
        return VStack {
            CheckView(
                isChecked: viewModel.screenData.wind,
                title: "Wind speed", action: {
                    viewModel.toggleFeature(feature: "wind")
                }
            )
            Image("wind_icon")
                .padding(.vertical)
                .scaledToFit()
        }
    }
}
