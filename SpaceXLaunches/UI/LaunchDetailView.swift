//
//  LaunchDetailView.swift
//  SpaceXLaunches_Snapp
//
//  Created by Amin on 7/20/23.
//

import SwiftUI


struct LaunchDetailView: View {
    
    //MARK: - Properties
    @EnvironmentObject var favoritesService : FavoriteLaunhesService
    @StateObject var imageLoader = ImageLoaderManager()
    @State var item : LaunchModel
    
    
    //MARK: - Views
    var body: some View {
        Form {
            Section {
                patchImage
            }
            
            Section {
                Text(item.name)
                    .font(.headline)
                FormRow {
                    Text("Launch Status: ")
                } leading: {
                    Text(item.success ?? false ? "Succeeded" : "Failed")
                        .foregroundColor(item.success ?? false ? .green : .red)
                }
                
                FormRow {
                    Text("Flight Number")
                } leading: {
                    Text("\(item.flight_number)")
                }

                FormRow {
                    Text("Launch Date:")
                } leading: {
                    Text(item.getPrettyFormattedDate)
                }
            }
            
            Section("Details:") {
                Text(item.details ?? "")
                    .multilineTextAlignment(.leading)
            }
            if let wikipedia = item.links?.wikipedia,
               let wikiURL = URL(string: wikipedia) {
                Section("Other resources") {
                    Link(destination: wikiURL) {
                        HStack {
                            Text("Wikipedia")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    favoritesService.updateState(for: item.id)
                } label: {
                    Image(systemName: favoritesService.favoritedList.contains(item.id) ? "bookmark.fill" : "bookmark")
                }
            }
        }
        .navigationTitle(item.name)
        .task {
            if let largePatchURL = item.links?.largePatch {
                await imageLoader.setURL(url: largePatchURL)
            }
        }
    }
    
    @ViewBuilder private var patchImage : some View {
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
            Button {
                Task {
                    await imageLoader.retryLoading()
                }
            } label: {
                VStack(alignment: .center) {
                    Image(systemName: "arrow.counterclockwise.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.red, .secondary)
                        .frame(maxWidth: 50)
                    Text("Failed to load image: \(error)")
                }
                .foregroundColor(.secondary)
                
            }
        }
    }
    
    @ViewBuilder
    private func FormRow(@ViewBuilder trailing: () -> some View,
                         @ViewBuilder leading: () -> some View) -> some View {
        HStack {
            trailing()
                .foregroundColor(.secondary)
            Spacer()
            leading()
        }
    }
}

/*
struct LaunchDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LaunchDetailView(item: LaunchModel.preview[2])
        }
        .environmentObject(FavoriteLaunhesService())
    }
}
*/
