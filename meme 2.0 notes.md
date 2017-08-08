# Design Changes
- Two tabs: table view / collection view
- top-left Edit
- title = Sent Memes
- top-right = `+`    // connects to Meme Editor View


# Model
In AppDelegate.swift:

var memes = [Meme]()
In the view controller that edits the Meme:

func save() {
    // Create the meme
    let meme = Meme(top: topField.text!, bottom: bottomField.text!, image: imageView.image, memedImage: memedImage)

    // Add it to the memes array in the Application Delegate
    let object = UIApplication.shared.delegate
    let appDelegate = object as! AppDelegate
    appDelegate.memes.append(meme)
}
In the Sent Memes Table and Collection View Controllers:

let appDelegate = UIApplication.shared.delegate as! AppDelegate
memes = appDelegate.memes



# Tab View Controller

1. Drag in TabViewController
2. Delete two pre-built views
3. Connect TVC to a TableView by:
    - right-click TBC in project layout
    - drag from `view controllers` in `Triggered Segues` to the view in Interface Builder
4. Create a new Navigation Controller with a Collection View Controller embedded
5. Repeat (3)
6. Make sure TabViewController is set as initial view controller
7. Go back and change controllers title and images in the TVC
