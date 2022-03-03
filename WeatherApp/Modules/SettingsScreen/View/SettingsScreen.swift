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
        self.viewModel = SettingsScreenViewModel(repository: Repository(), persistence: Database())
        UITableView.appearance().backgroundColor = .white.withAlphaComponent(0)
    }
    
    var body : some View {
        ZStack {
            Image(backgroundImage)
                .resizable()
                .ignoresSafeArea()
                .blur(radius: 20)
            VStack{
                HStack {
                    Text("History")
                        .font(.system(size: 40))
                        .padding()
                        .foregroundColor(.white)
                    Spacer()
                }
                List {
                    ForEach(viewModel.output.screenData.cities , id: \.self) { city in
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
                
                RadioButtonGroup(items: ["Imperial", "Metric"] , selectedId: viewModel.persistence.fetchMeasuringUnit()) { selected in
                    viewModel.selectMeasuringUnit(unit: selected)
                }
                .foregroundColor(.white)
                .padding()
                
                
                HStack{
                    Spacer()
                    VStack {
                        CheckView(isChecked: viewModel.output.features[0], title: "").onTapGesture {
                            viewModel.toggleFeature(index: 0)
                            print("click")
                        }
                        Image("humidity_icon")
                            .scaledToFit()
                            .padding()
                        Text("Humidity")
                            .foregroundColor(.white)
                    }
                    Spacer()
                    VStack {
                        CheckView(isChecked: viewModel.output.features[1], title: "").onTapGesture {
                            viewModel.toggleFeature(index: 1)
                        }
                        Image("pressure_icon")
                            .scaledToFit()
                            .padding()
                        Text("Pressure")
                            .foregroundColor(.white)
                    }
                    Spacer()
                    VStack {
                        CheckView(isChecked: viewModel.output.features[2], title: "").onTapGesture {
                            viewModel.toggleFeature(index: 2)
                        }
                        Image("wind_icon")
                            .padding(.top)
                            .scaledToFit()
                        Text("Wind")
                            .foregroundColor(.white)
                            .padding(.top)
                    }
                    Spacer()
                    
                }
                
            }
        }.onAppear(perform: {viewModel.startViewModel()})
    }
}
