/*

 This program scans the Music.app(rip iTunes) library and selects three playlists for three different tasks: exercise,
 meditation, and work. To do this, it looks at a specific folder and playlist layout within Music.app to select the
 proper playlists. Specifically, it looks for the folders Exercise, Meditation, and Work. Inside each of these are
 multiple playlists to choose from. It will go through each playlist and count up the average number of play counts in
 each playlist. It will then pick a random playlist from the four least played playlists. This allows for new music
 each day, while still letting me listen to all of the songs I want to listen to with equal measure. If there are not
 four playlists to choose from, it will return the least played playlist.

 The way I personally use this tool is to start with the selected Work playlist. This is a smart playlist that contains
 up to 128 songs(two times the current CPU bitrate of 64, but artibrarily chosen because I like my numbers to be a
 power of bits), with the least played songs on the list. When I am ready to do my daily exercise routine, I then take
 the selected Exercise playlist, run it through a Shortcuts.app script that selects 32 minutes worth of songs, and then
 those are added to Play Next. The selected Meditation playlist functions the same way, except it selects 16 minutes
 of music. Since these are added to Play Next, once the allotted music has been played, it will go back to playing the
 Work playlist.

 Two helper functions are needed. The first loads the Music library and sorts it into appropriate playlist dictionaries.
 The second parses through these dictionaries and provides the appropriate playlists.

 Apple's ArgumentParser is used to accept a debug flag. When this is triggered, all playlists will be printed out with
 their appropriate average playcount. This is useful as a sanity check to make sure there are no outliers as far as
 playcount is concerned. This feature could be improved in the future to output individual groups of playlists as the
 output could grow quite long.

 The final step of the program is to add all of the appropriate playlists to my Things.app schedule. I have an Area
 setup on Things just for my daily music listening, so all 3 are added to that.

 */

import ArgumentParser

struct Music: ParsableCommand {
    @Flag(name: .shortAndLong, help: "Prints debug information about the playlists.")
    var debug: Bool

    @Flag(name: .shortAndLong, help: "Sorts debug information by average playcount.")
    var sort: Bool

    func run() throws {
        let music: MusicLibrary

        do {
            music = try MusicLibrary()
        } catch let error as LibraryError {
            switch error {
            case.emptyLibrary: print("The Music.app library is empty.")
            case .libraryNotLoaded: print("Unable to load library.")
            }
            throw ExitCode.failure
        } catch {
            print(error)
            throw ExitCode.failure
        }

        if debug {
            parsePlaylistDebug(music.exercise, "Exercise", sort)
            parsePlaylistDebug(music.meditation, "Meditation", sort)
            parsePlaylistDebug(music.work, "Work", sort)
            parseAlbumDebug(music.albums)
        } else {
            let album: String = "Album: \(parseAlbum(music.albums))"
            let exercise: String = "Exercise: \(parsePlaylist(music.exercise))"
            let meditation: String = "Meditation: \(parsePlaylist(music.meditation))"
            let work: String = "Work: \(parsePlaylist(music.work))"

            print(album)
            print(exercise)
            print(meditation)
            print(work)

            schedule(album)
            schedule(exercise)
            schedule(meditation)
            schedule(work)
        }

    }
}

Music.main()
