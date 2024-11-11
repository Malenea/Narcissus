# Narcissus
Hyper take home test

Hyper take home test is a test that asks to create an app that captures photos and video using the iPhone front and rear camera. Those medias are then previewed and can be edited through adding filters,
stickers, text and can be shared through a share button.
The app allows to change the camera used, toggle the flash, add a timer and set the filter intensity.

The test was realised in roughly 3 days adding an extra for documentation and testing.
The test was made using SwiftUI, it would however not be an issue to do the same test with UIKit, but would probably take a bit longer given the more complex syntax, especially around animations and
constraints declaration. SwiftUI allowed me to work more efficiently on the UI and react part.

One third party framework used for testing purposes (https://github.com/pointfreeco/swift-snapshot-testing), this allowed me to implement the snapshot tests.

## Business logic decisions
I decided for the sake of the test to use as few third party libraries as possible, the idea was to showcase my codebase and my top process in the context of being assessed.
Outside of the scope of the test, I would probably have used some third party libraries to ease and accelerate my work, given they are viable and maintainable.

## Delivery and process
My process here was to work in small chuncks, feature based to be able to always deliver value. The idea is that no matter the stage, the app could stick as closely as possible to what we could
expect from an app production ready.

I was however not able, due to time restrictions, to deliver the video filtering, the stickers and the text.
Here are my feedback on those:

- Video editing's filter apply process made the app seemed slow on the processing, I found some alternatives to process the video filtering in a more efficient way but
wasn't able to test them on time. For that reason I decided to put on hold that feature to not lower the app experience.
- Text and stickers addition to the image can be done through adding them on a top layer view and then snapshoting both the view and the image to produce a result image, but the gesture handling
for positioning, rotating, scaling and the entities behaviours on bounds calculation couldn't be done in time, and again, instead of hindering the app experience by delivering an unfinished feature
I decided to put it on hold.
- The success small animation could have been rather easy to do by adding the lottie framework and adding a success animation in the form of a json and playing it upon share success. But the SwiftUI
sharelink doesn't include a callback upon completion and wrapping the original UIKit one produced a weird behaviour where most share options were missing. This is fixable but given it was a bonus,
I prefered prioritising polishing the app rather than wasting time on it. 

## Roadmap
The roadmap is as follow and was thought and applied through a value-based schedule:

- Implement a functional preview view that reflects what the back camera shows: ✅
- Implement the ability to capture the image: ✅
- Implement the ability to preview the captured image on a separate view using navigation stack to create an easy 2 step-flow: ✅
- Implement the ability to share the captured image through the native sharing sheet: ✅

-> This wrapped up the first value: deliver a functioning end to end flow to see, capture and share a photo: ✅

- Implement camera switching: ✅
- Implement flash toggle: ✅

-> This wrapped up the second value: deliver some options to customise the app experience upon using the camera: ✅

- Implement filters selection: ✅
- Implement filters intensity slider: ✅

-> This wrapped up the third value: deliver the filtering part for photos: ✅

- Implement the ability to switch between photo and video: ✅
- Implement the video recording capabilities by slightly modifying the camera manager: ✅
- Implement the ability to preview the captured video on a separate view modifying the navigation stack to be a 2 step-flow but with embranchment: ✅
- Implement the ability to share the captured video through the native sharing sheet: ✅

-> This wrapped up the fourth value: deliver a functioning end to end flow to see, capture and share a video: ✅

- Implement a timer based countdown for both photo and video: ✅
- Implement some safety features based on edge cases to avoid overlapping events (i.e: launch countdown, switch mode, take a picture, change countdown timer at the same time): ✅
- Implement some showcase tests, both unit and snapshot to showcase dependency injection and UI consistency through graphic comparison: ✅
- Polish animations and transitions as well as the UI elements: ✅

-> This wrapped up the final value: polish what was already done and showcase some testing (for the sake of the test, in real life, testing would have been done more thoroughly): ✅

- Implement the ability to add filters to video previews through video processing and create a shareable result: ❌
- Implement the ability to add stickers and text through an additional layer and share it through snapshoting the views into an image: ❌
- Implement the ability to showcase success animations through the usage of animated jsons using a third party framework such as Lottie: ❌
- Implement flow testing through UI testing: ❌

## My take on it
### Architecture and design
I went for a hybrid architecture that resemble MVVM-c but with nested structures and more state based behaviour.
Design was made to separate the app in several layers each with their own responsability and minimum dependency.

- **Domain layer** it contains the business entities (and would also if needed contain the fixtures used for mocking them)
- **Shared layer** contains the helpers and extensions that are used across the features and the app
- **Feature layer** contains the different feature modules and their business logic (at the moment the camera, filters, image preview and video preview)
- **Core layer** is the root of the app which combines them together

Each layer was created to respect the **SOLID** principle.

The root coordinator is used to handle the flow, presentation, pushes and dismisses of each view, as well as placeholders for view specific events (currently not used though).
The view design is so that the view itself serves as an event handler hub and embeds nested view model and view (named ContentView) to separate them from any business logic, making them testable from generic mocks (i.e: pure UI based ContentView are testable by providing nothing domain related, avoiding extra dependency injection to snapshot test them, showcased through the CameraFeedView.ContentView
in the test section).
ViewModel can be tested through dependency injection if needed (i.e: showcased through the CameraFeedView.ViewModel in the test section) and tests can be done meaningfully through event handling.

## Testing
Testing was done just to showcase how it would be done. They're lacking coverage and are just here to show what and how I would test things. This is done only in the context of this being an interview
test. Testing is important and I wouldn't deliver a feature without having all the needed tests in place.

- Snapshot testing is added through mocking UI views to insure UI consistency and unwanted changes
- Unit testing is added on view models to insure consistency of results and logic through dependency injection

## Improvements

- Refactoring: the code is not as clean as I would like it to be and some extractions could be done to make it more readable. More factories could be implemented to create more efficiently some
components
- Code commenting: the code definitely need some code commenting to automate documentation and give context to people who would stumble upon it
- Scaling:
	- Entities: If stickers and text was implemented, and upon improving filtering, I would have created a preview entity for both photo and video that would have embedded the image, an array of filters,
	an array of sticker and text objects with an id, size, scale, angle for rotation and value
	- Processing: For a better user experience, creating a processing step in the flow would be ideal. The idea is then to apply all modifications to the image before being able to share it, making it more
	obvious to the user that we are processing something and that the app is not stuck
	- Animations: some animations could be reworked especially if we implement Lottie, to make them more custom-home-made, and enhance the wow-effect, and some transitions might be missing, which should be
	adressed
- Separation of concerns: At the moment, the protocols and mocks lie in the same package and the same target as the other business related class. Those could be extracted in a different target in the same
package. Making it easier to not import them where they're not needed

## Conclusion

I've tried my best at providing an app that is scalable and innovative architecture and pattern wise while keeping good practices, though not being your full typical design.
I've decided to go with something as polished as I could and that had some value delivered at the expense of being fully complete. If it was to be a production delivery, I would rather deliver value to our
users and iterate over it rather than delivering an incomplete app or not deliver at all.

The app in general was made so you could assess better my coding skills and top processes regarding architecture and scalability capabilities.

Overall it was also an interesting experience for me as I had never worked on a full capture camera based app, and enjoyed learning more about it.

## Post-Scriptum

The app uses SPMs both local and for the snapshot package. It was tested 3 times on my side by re cloning each time from scratch and running the app, and worked as expected.