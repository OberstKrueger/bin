/*

 This function takes the loaded playlist struct that was loaded earlier, and selects the appropriate playlist from each
 dictionary. This is done by reducing each playlists playcounts to a single floating-point average. This implementation
 uses Float80 for the added precision, although this might present issues on non-UNIX operating systems that do not
 support Float80.

 After the playcounts are reduced, the total number of playlists are checked. If the section has less than three
 playlists, it will return the playlist with the lowest average playcount. If there are four or more playlists, it will
 take the bottom four playlists and select randomly from them. This decreases the odds of getting the same playlist
 multiple days in a row, although does not guarantee it. Without a log to trace previously played playlists, randomness
 is the best way to do this.

 If there are no playlists in the provided folder, the function will return a message stating so. It does not return a
 Result or throw an error due to it being an unlikely non-catastrophic situation. If the folder exists but is not
 populated, then the user would not be able to play anything from it anyways...

 An alternative debug mode is provided that prints out the average play value for the provided playlist. This is called
 from elsewhere in the application.

 */

import SwiftyTerminalColors

func parseAlbum(_ albums: [String]) -> String {
    return albums.randomElement() ?? "No albums provided!"
}

func parsePlaylist(_ playlists: [String: [Int]]) -> String {
    var reducedPlaylists: [String: Float80] = [:]

    for (key, value) in playlists {
        reducedPlaylists[key] = value.reduce(0, {$0 + Float80($1)}) / Float80(value.count)
    }

    switch reducedPlaylists.count {
    case ...0: return "No playlists provided!"
    case ...3: return reducedPlaylists.sorted(by: {$0.value < $1.value})[0].key
    default:   return reducedPlaylists.sorted(by: {$0.value < $1.value})[...3].randomElement()!.key
    }
}

/*

 DEBUG FUNCTIONS

 */

func parseAlbumDebug(_ albums: [String]) {
    if let album = albums.randomElement() {
        print("Album".style(.bold))
        print(album)
    }
}

func parsePlaylistDebug(_ playlists: [String: [Int]], _ name: String, _ sortByPlays: Bool) {
    var reducedPlaylists: [String: Float80] = [:]

    for (key, value) in playlists {
        reducedPlaylists[key] = value.reduce(0, {$0 + Float80($1)}) / Float80(value.count)
    }

    print(name.style(.bold))
    for (key, value) in reducedPlaylists.sorted(by: sortByPlays ? {$0.value < $1.value} : {$0.key < $1.key}) {
        print("\(key) => \(value)")
    }
    print("\n", terminator: "")
}
