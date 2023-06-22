//
//  View+Extension.swift
//  APOD
//
//  Created by Pachauri, Ankur on 14/06/23.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder
    func view(for phase: AsyncImagePhase, failStateImage: String = "placeholder", onSuccess: ((Image) -> Void)? = nil) -> some View {
        switch phase {
        case .empty:
            ProgressView()
                .foregroundColor(.gray)
                .opacity(0.7)
        case .success(let image):
            image
                .resizable()
                .onAppear(perform: {
                    onSuccess?(image)
                })
        case .failure(_):
            Image(failStateImage)
                .resizable()
        @unknown default:
            Image(failStateImage)
                .resizable()
        }
    }
}
