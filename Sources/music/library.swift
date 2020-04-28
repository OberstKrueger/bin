/*

 Data is returned to the main function in the form of a struct contained three dictionaries. These dictionaries are
 filled by the init process of the struct. This init process can throw, in case the Music.app library can not be read or
 is empty.

 Each dictionary is a [String: [Int]] dictionary. The key is the name of the playlist belonging to that specific task,
 and the Int array is made up of the playcounts for each song in that playlist. This will be used later to determine
 the average playcount for each playlist.

 All albums within the library are also returned, so that one may be listened to every day. A future point of expansion
 would be to include a filtering method for albums that work well in playlists but not listening all the way through.

 */

import iTunesLibrary

enum LibraryError: Error {
    case emptyLibrary
    case libraryNotLoaded
}

enum PlaylistType: String, CaseIterable {
    case exercise   = "Exercise"
    case meditation = "Meditation"
    case work       = "Work"
}

struct MusicLibrary {
    var exercise: [String: [Int]] = [:]
    var meditation: [String: [Int]] = [:]
    var work: [String: [Int]] = [:]

    init() throws {
        let ignored: [String] = [
            "Audiobooks",
            "Home Videos",
            "Library",
            "Movies",
            "Music Videos",
            "Music",
            "Podcasts",
            "Purchased",
            "TV & Movies",
            "TV Shows"
        ]
        let library: ITLibrary
        var folders: [PlaylistType: [ITLibMediaItem]] = [:]

        // Loads library
        if let checkLibrary = try? ITLibrary(apiVersion: "1.0", options: .lazyLoadData) {
            library = checkLibrary
        } else {
            throw LibraryError.libraryNotLoaded
        }

        // Makes sure library is not empty
        if library.allMediaItems.count == 0 { throw LibraryError.emptyLibrary }

        // Loads master playlist songs into temporary storage
        for playlist in library.allPlaylists.filter({ignored.contains($0.name) == false}) {
            switch PlaylistType(rawValue: playlist.name) {
            case .some(let type):
                folders[type] = playlist.items
            case .none:
                for item in playlist.items {
                    for type in PlaylistType.allCases {
                        if folders[type, default: []].contains(item) {
                            switch type {
                            case .exercise: exercise[playlist.name, default: []].append(item.playCount)
                            case .meditation: meditation[playlist.name, default: []].append(item.playCount)
                            case .work: work[playlist.name, default: []].append(item.playCount)
                            }
                        }
                    }
                }
            }
        }
    }
}
