//
//  ImageLoaderManager.swift
//  SpaceXLaunches
//
//  Created by Amin on 7/20/23.
//
import UIKit.UIImage

class ImageLoaderManager: ObservableObject {
    //MARK: - Properties
    @Published var state: LoaderState = .notInializedProperly
    var name : String

    private var url: String
    private var task: URLSessionDataTask?

    //MARK: - Initialization
    init(url: String? = nil, name: String? = nil) {
        if let url {
            self.url = url
            self.name = name ?? url
            
            Task(priority: .userInitiated) {
                await MainActor.run {
                    state = .initialized
                }
    
                //Start loadingImage
                await loadImage()
            }
            
        } else {
            self.url = ""
            self.name = ""
        }
        
    }
    
    func setURL(url: String) async {
        self.url = url
        
        await MainActor.run {
            state = .initialized
        }
        //Start loadingImage
        await loadImage()
    }

    //MARK: - Load image method
    private func loadImage() async {
        await MainActor.run {
            //Change status to loading
            state = .loading
        }
        
        //Check if data is cahced,
        if let cachedImage = ImageCacheManager.shared.get(forKey: url) {
            await MainActor.run {
                //return cached data
                state = .successfullyLoaded(cachedImage)
            }
            return
        }
        
        //creating request for fetching imageData
        guard let imageURL = URL(string: url) else { return }
        
        //Creating Request with timeout interval: 10
        let request = URLRequest(url: imageURL, timeoutInterval: 10)
        Task {
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                
                //Check for receivedResponse
                guard let httpsResponse = response as? HTTPURLResponse,
                      httpsResponse.statusCode == 200 else {
                    throw URLError(URLError.Code(rawValue: (response as? HTTPURLResponse)?.statusCode ?? 0 ))
                }
                
                //try convert received data into UIImage
                guard let receivedImage = UIImage(data: data) else {
                    throw ImageLoaderError.imageDataIsNotValid
                }
                
                //Ceche fetched imageData
                ImageCacheManager.shared.set(receivedImage, forKey: url)
                
                await MainActor.run {
                    //Update state with new imageData
                    state = .successfullyLoaded(receivedImage)
                }
            }
            catch {
                await MainActor.run {
                    state = .failed(error.localizedDescription)
                }
            }
        }
    }
    
    func retryLoading() async {
        //Check if everything is ok, than retry loading image
        await loadImage()
    }
    
    //MARK: - Enums and error
    enum ImageLoaderError: Error, LocalizedError {
        case imageDataIsNotValid
        
        var localizedDescription : String {
            switch self {
            case .imageDataIsNotValid:
                return "Image data is not valid"
            }
        }
        
        var errorDescription: String? { return localizedDescription}
    }
    
    enum LoaderState {
        case notInializedProperly
        case initialized
        case loading
        case successfullyLoaded(_ image: UIImage)
        case failed(_ error: String)
    }
}


//MARK: - Image CacheManager
class ImageCacheManager {
    
    //Shared instance
    static let shared = ImageCacheManager()

    private let cache = NSCache<NSString, UIImage>()

    private init() {}

    func set(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }

    func get(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
}
