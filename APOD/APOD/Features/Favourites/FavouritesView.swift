//
//  FavouritesView.swift
//  APOD
//
//  Created by Pachauri, Ankur on 20/06/23.
//

import SwiftUI

struct FavouritesView: View {
    @ObservedObject var viewModel: FavouritesViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack {
                if !viewModel.data.isEmpty {
                    List(viewModel.data, id: \.date) { item in
                        NavigationLink(destination: APODDetailsView(data: item, isSubview: false, isFavourite: .constant(true), callback: {
                            viewModel.deleteFavourite(item)
                        }), label: {
                            FavouritesListRowView(item: item) {
                                viewModel.deleteFavourite(item)
                                
                                if viewModel.data.isEmpty {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        })
                    }
                } else {
                    Text("No favourites found!")
                }
            }
            .navigationTitle("Favourites")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.getAllFavouritesData()
            }
        }
    }
}

struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesView(viewModel: .init())
    }
}

struct FavouritesListRowView: View {
    let item: AstronomyPicture
    let callback: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.subheadline)
                
                Text(item.date)
                    .font(.callout)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: callback, label: {
                Image("favorite_active")
                    .resizable()
                    .frame(width: 30, height: 30)
            })
            .buttonStyle(.plain)
        }
    }
}
