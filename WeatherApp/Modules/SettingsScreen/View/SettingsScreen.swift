//
//  SettingsScreen.swift
//  WeatherApp (iOS)
//
//  Created by Domagoj Bunoza on 03.03.2022..
//

import SwiftUI
import Combine

struct SettingsScreen: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @ObservedObject var viewModel : SettingsScreenViewModel
    
    let backgroundImage : String
    
    init(backgroundImage: String) {
        self.backgroundImage = backgroundImage
        self.viewModel = SettingsScreenViewModel(persistence: Database())
        UITableView.appearance().backgroundColor = .white.withAlphaComponent(0)
    }
    
    var body : some View {
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
        }.onAppear(perform: {viewModel.startViewModel()})
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
                ForEach(viewModel.cities , id: \.self) { city in
                    HStack{
                        Text(city.name).onTapGesture {
                            viewModel.selectedCity(geoItem: city)
                            self.mode.wrappedValue.dismiss()
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
            CheckView(isChecked: viewModel.humidity, title: "")
            Image("humidity_icon")
                .scaledToFit()
                .padding()
            Text("Humidity")
                .foregroundColor(.white)
        }.onTapGesture {
            viewModel.toggleFeature(feature: "humidity")
        }
    }
    
    func renderPressure() -> some View {
        return VStack {
            CheckView(isChecked: viewModel.pressure, title: "").onTapGesture {
                viewModel.toggleFeature(feature: "pressure")
            }
            Image("pressure_icon")
                .scaledToFit()
                .padding()
            Text("Pressure")
                .foregroundColor(.white)
        }.onTapGesture {
            viewModel.toggleFeature(feature: "pressure")
        }
    }
    
    func renderWind() -> some View {
        return VStack {
            CheckView(isChecked: viewModel.wind, title: "").onTapGesture {
                viewModel.toggleFeature(feature: "wind")
            }
            Image("wind_icon")
                .padding(.top)
                .scaledToFit()
            Text("Wind")
                .foregroundColor(.white)
                .padding(.top)
        }.onTapGesture {
            viewModel.toggleFeature(feature: "wind")
        }
    }
}
