/*

 This function schedules the passed music text in Things3.app. It makes two assumptions about scheduling. The first is
 that it will be added for today, as this will be run every day on the day that the music is requested. The second is
 that it will be added to an Area in Things3.app called "Music". If this area does not exist, it will fail.

 This does not return an error on failure as it is assumed to not fail in a way where the error output of a failed
 AppleScript run will be sufficient for making it work.

 */

import Foundation
import SwiftyTerminalColors

func schedule(_ playlist: String) {
    let input = """
                 tell application "Things3"
                     set NewToDo to make new to do with properties {name:"\(playlist)"} at beginning of area "Music"
                     schedule NewToDo for (current date)
                 end tell
                 """
    let script = NSAppleScript(source: input)
    var errors: NSDictionary?

    script?.executeAndReturnError(&errors)

    if let errorDictionary = errors {
        print("\nThings3.app returned the following errors:".color(.red).style(.bold))
        for (key, value) in errorDictionary {
            print("\(key): \(value)".color(.red))
        }
    }
}
