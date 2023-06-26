//
//  VideoPlayerView.swift
//  APOD
//
//  Created by Pachauri, Ankur on 21/06/23.
//

import SwiftUI
import WebKit

struct VideoPlayerView: UIViewRepresentable {
    let videoUrl: String
    
    func makeUIView(context: Context) ->  WKWebView {
        return WKWebView()
    }
    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let videoURL = URL(string: videoUrl) else { return }
        webView.scrollView.isScrollEnabled = false
        webView.load(URLRequest(url: videoURL))
    }
}
