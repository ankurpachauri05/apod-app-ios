//
//  HomeScreenView.swift
//  APOD
//
//  Created by Pachauri, Ankur on 13/06/23.
//

import SwiftUI

struct HomeScreenView: View {
    @ObservedObject var viewModel: HomeScreenViewModel
    @State private var date: Date = Date.now
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    DatePicker(selection: $date, in: ...Date.now, displayedComponents: .date) {
                        Text("home.picker.title".localized())
                            .font(.system(size: 12))
                    }
                    
                    Button(action: {
                        Task {
                            await viewModel.getAstronomyPictureOfDay(date.toDateString())
                        }
                    }, label: {
                        Text("home.button.search.title".localized())
                    })
                    .padding(.leading, 8)
                }
                .padding(.horizontal, 8)
                
                switch viewModel.requestState {
                case .loading(_):
                    APODDetailsView(data: AstronomyPicture.placeholderData(), isSubview: true, isFavourite: .constant(false), callback: { })
                        .redacted(reason: .placeholder)
                case .success(let data):
                    APODDetailsView(data: data, isSubview: true, isFavourite: $viewModel.isFavourite, callback: {
                        viewModel.addRemoveFavourite()
                    })
                case .failure(_):
                    ErrorView(callback: {
                        Task {
                            await viewModel.getAstronomyPictureOfDay(date.toDateString())
                        }
                    })
                    .frame(maxHeight: .infinity)
                default:
                    EmptyView()
                }
            }
            .navigationTitle("screen.home.title".localized())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink("home.button.favourites.title".localized(), destination: FavouritesView(viewModel: .init()))
                }
            })
            .task {
                await viewModel.getAstronomyPictureOfDay(date.toDateString())
            }
        }
    }
    
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView(viewModel: .init())
    }
}
