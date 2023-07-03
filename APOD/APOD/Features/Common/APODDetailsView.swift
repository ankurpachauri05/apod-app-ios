//
//  APODDetailsView.swift
//  APOD
//
//  Created by Pachauri, Ankur on 14/06/23.
//

import SwiftUI

struct APODDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let data: AstronomyPicture
    let isSubview: Bool
    
    @Binding var isFavourite: Bool
    
    let callback: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                    if data.mediaType == .video {
                        VideoPlayerView(videoUrl: data.url)
                            .frame(maxWidth: .infinity)
                            .frame(height: 250)
                    } else {
                        if let image: Image = try? CacheManager.shared.cachedImage(forKey: "\(data.date)_image") {
                            image
                                .resizable()
                                .frame(maxWidth: .infinity)
                                .scaledToFit()
                        } else {
                            if let url = URL(string: data.url) {
                                AsyncImage(url: url, content: { phase in
                                    view(for: phase, failStateImage: "placeholder", onSuccess: { image in
                                        try? CacheManager.shared.cacheImage(image, forKey: "\(data.date)_image")
                                    })
                                })
                                .frame(maxWidth: .infinity, minHeight: 250)
                                .scaledToFit()
                            } else {
                                // If invalid url...
                                Image("placeholder")
                                    .resizable()
                                    .frame(maxWidth: .infinity)
                                    .scaledToFit()
                            }
                        }
                    }
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(data.title)
                            .font(.title)
                        
                        Spacer()
                        
                        Button(action: {
                            callback()
                            
                            if !isSubview {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }) {
                            Image(isFavourite ? "favorite_active": "favorite")
                                .resizable()
                        }
                        .frame(width: 40, height: 40)
                    }
                    
                    Text(data.date)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text(data.explanation)
                        .font(.subheadline)
                        .padding(.vertical, 20)
                }
                .padding()
            }
        }
    }
}

struct APODDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        APODDetailsView(data: AstronomyPicture.placeholderData(), isSubview: false, isFavourite: .constant(false), callback: {  })
    }
}
