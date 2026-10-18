import XCTest
@testable import YouTubePlayerKit

final class YouTubePlayerHTMLTests: XCTestCase {
    
    func testInit() throws {
        let input = UUID().uuidString
        let youTubePlayerOptions = YouTubePlayer.Options(json: input)
        let youTubePlayerHTML = try YouTubePlayer.HTML(options: youTubePlayerOptions)
        XCTAssert(youTubePlayerHTML.contents.contains(input))
    }
    
    func testHidesCaptions() throws {
        let hidingHTML = try YouTubePlayer.HTML(options: .init(json: "{}", hidesCaptions: true))
        XCTAssert(hidingHTML.contents.contains("var hidesCaptions = true;"))
        let showingHTML = try YouTubePlayer.HTML(options: .init(json: "{}"))
        XCTAssert(showingHTML.contents.contains("var hidesCaptions = false;"))
        XCTAssertFalse(showingHTML.contents.contains("{{hidesCaptions}}"))
    }

    func testHidesCaptionsFromConfiguration() throws {
        let options = try YouTubePlayer.Options(
            playerSource: .video(id: "abc"),
            playerConfiguration: .init(hidesCaptions: true),
            originURL: nil
        )
        XCTAssertTrue(options.hidesCaptions)
        // Not a YouTube player parameter
        XCTAssertFalse(options.json.contains("hidesCaptions"))
    }
    
    func testUnavailableResourceError() {
        XCTAssertThrowsError(
            try YouTubePlayer.HTML(
                options: .init(json: .init()),
                resource: .init(
                    fileName: "UnavailableResource",
                    fileExtension: "unavailable"
                )
            )
        )
    }
    
}
