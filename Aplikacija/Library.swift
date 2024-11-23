////
////  Library.swift
////  Aplikacija
////
////  Created on 16. 10. 24.
////
//
//import Foundation
//import MusicKit
//import MediaPlayer
//
//struct Album: Identifiable {
//	var id: MusicKit.MusicItemID
//	var title: String
//	var artworkUrl: URL?
//	var artist: String
//	var tracks: [MusicKit.Track]
//}
//
//class Library: ObservableObject {
//	
//	@Published var albums: [Album] = []
//	
//	@MainActor
//	func load () async {
//		
//		let newLibrary = await loadLibrary()
//		
//		self.albums = newLibrary
//		print("Loaded \(self.albums.count) albums")
//	}
//	
//	func play (album: Album) async {
//		
//		let player = MusicKit.ApplicationMusicPlayer.shared
//		
//		if album.tracks.count > 0 {
//			player.queue = [ album.tracks[0] ]
//		}
//		
//		do {
//			try await player.play()
//		} catch {
//			print("Error while playing album")
//		}
//		
//	}
//}
//
//func loadLibrary () async -> [Album] {
//	
//	var albums: [Album] = []
//	
//	do {
//		
//		guard await MusicAuthorization.request() == .authorized else { return [] }
//		
//		var req = MusicLibraryRequest<MusicKit.Album>()
//		req.limit = 50
//		
//		let res = try await req.response()
//		
//		for item in res.items {
//			
//			let detailedAlbum = try await item.with(.tracks)
//			
//			albums.append(Album(
//				id: item.id,
//				title: item.title,
//				artworkUrl: item.artwork?.url(width: 512, height: 512),
//				artist: item.artistName,
//				tracks: detailedAlbum.tracks != nil
//					? Array(detailedAlbum.tracks.unsafelyUnwrapped)
//					: []
//			))
//		}
//		
//	} catch {
//		print("Couldn't fetch albums")
//	}
//
//	return albums
//}
