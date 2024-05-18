//
//  LaunchesListRowView.swift
//  SpaceXLaunches
//
//  Created by Amin on 7/20/23.
//

import SwiftUI

struct LaunchesListRowView: View {
    
    //MARK: - Properties
    @State var item : LaunchModel
    @StateObject var imageLoader = ImageLoaderManager()
    
    
    //MARK: - views
    var body: some View {
        VStack {
            HStack {
                rowIcon
                    .frame(maxWidth: 80)
                VStack(alignment: .leading) {
                    HStack {
                        Text(item.name)
                            .font(.headline)
                        Spacer()
                        Text(item.success ?? false ? "Succeeded" : "Failed")
                            .foregroundColor(item.success ?? false ? .green : .red)
                            .font(.caption)
                    }
                    Text("Flight No: \(item.flight_number)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(item.getPrettyFormattedDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            Text(item.details ?? "")
                .font(.caption)
                .multilineTextAlignment(.leading)
                .foregroundColor(.secondary)
                .lineLimit(4)
        }
    }
    
    @ViewBuilder private var rowIcon : some View {
        switch imageLoader.state {
        case .notInializedProperly, .initialized:
            Image(systemName: "photo.artframe", variableValue: 0.5)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.secondary.opacity(0.4), .primary.opacity(0.4))
                .padding()
            
        case .loading:
            ProgressView {
                Text("loading...")
                    .font(.caption)
            }
            
        case .successfullyLoaded(let image):
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(20)
            
        case .failed(let error):
            VStack {
                Image(systemName: "exclamationmark.octagon")
                Text("Failed to load image: \(error)")
                    .font(.caption2)
            }
            .foregroundColor(.red)
            .padding(2)
            .overlay {
                Rectangle()
                    .cornerRadius(10)
                    .foregroundColor(.secondary.opacity(0.1))
            }
            
        }
    }
}

/*
struct LaunchesListRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ForEach(LaunchModel.preview) { LaunchesListRowView(item: $0 )}
        }
    }
}


*/
