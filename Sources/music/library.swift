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

struct MusicLibrary {
    var playlists: [String: [(title: String, counts: [Int])]] = [:]

    var sortedPlaylists: [(key: String, value: [(title: String, counts: [Int])])] {
        return playlists.sorted(by: {$0.key < $1.key})
    }

    init() throws {
        let library: ITLibrary

        // Loads library
        if let checkLibrary = try? ITLibrary(apiVersion: "1.0", options: .lazyLoadData) {
            library = checkLibrary
        } else {
            throw LibraryError.libraryNotLoaded
        }

        // Makes sure library is not empty
        if library.allMediaItems.count == 0 { throw LibraryError.emptyLibrary}

        // Loads master playlist songs into temporary storage
        for playlist in library.allPlaylists.filter({$0.name.contains(" - ")}) {
            let count = playlist.items.map({$0.playCount})
            let elements = playlist.name.components(separatedBy: " - ")

            playlists[elements[0], default: []].append((elements[1], count))
        }
    }
}
