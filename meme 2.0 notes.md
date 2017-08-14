# Design Changes
- Two tabs: table view / collection view
- top-left Edit
- title = Sent Memes
- top-right = `+`    // connects to Meme Editor View


# Model
In AppDelegate.swift:

```swift
var memes = [Meme]()
```

In the view controller that edits the Meme:

```swift
func save() {
    // Create the meme
    let meme = Meme(top: topField.text!, bottom: bottomField.text!, image: imageView.image, memedImage: memedImage)

    // Add it to the memes array in the Application Delegate
    let object = UIApplication.shared.delegate
    let appDelegate = object as! AppDelegate
    appDelegate.memes.append(meme)
}
```
In the Sent Memes Table and Collection View Controllers:

```swift
let appDelegate = UIApplication.shared.delegate as! AppDelegate
memes = appDelegate.memes
```


# Tab View Controller

1. Drag in Tab Bar Controller
2. Delete two pre-built views
3. Connect TVC to a TableView by:
    - right-click TBC in project layout
    - drag from `view controllers` in `Triggered Segues` to the view in Interface Builder
4. Create a new Navigation Controller with a Collection View Controller embedded
5. Repeat (3)
6. Make sure TabViewController is set as initial view controller
7. Go back and change controllers title and images in the TVC



# Collection View

```swift
override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VillainCollectionViewCell", for: indexPath) as! VillainCollectionViewCell
    let villain = self.allVillains[(indexPath as NSIndexPath).row]

    // Set the name and image
    cell.nameLabel.text = villain.name
    cell.villainImageView?.image = UIImage(named: villain.imageName)

    return cell
}

override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {

    // Grab the DetailVC from Storyboard    
    let detailController = self.storyboard!.instantiateViewController(withIdentifier: "VillainDetailViewController") as! VillainDetailViewController

    //Populate view controller with data from the selected item
    detailController.villain = allVillains[(indexPath as NSIndexPath).row]

    // Present the view controller using navigation
    navigationController!.pushViewController(detailController, animated: true)

}
```




### Here’s a recap of the steps I went over in the previous video.

There are two ways to set up table view controllers and collection view controllers in Storyboard:

1. Start with a UIViewController and drag in a UITableView or UICollectionView.
2. Use a UITableViewControlller or UICollectionViewController.

In the table views lesson we used option 1. Now we’ll set up our collection view using option 2.

For practice, go ahead and open up the BondVillainsInTabs project from this directory: step6.3-bondVillains-noCollectionView

### Steps to add a UICollectionViewController alongside the UITableViewController
- Drag in a Navigation Controller.
- Delete the root view controller that comes with the Navigation Controller.
- Drag in a CollectionViewController.
- Set the root view controller of the Navigation Controller to be the Collection View Controller you just added.
- Add the Collection View Controller to the tab bar. To do this, control-click on the Tab Bar Controller. Under “Triggered Segues“ drag from viewControllers to the Navigation Controller you just added.
- Open the identity inspector and set the class of the CollectionViewController to “VillainCollectionViewController”. (For MemeMe, this will be the “SentMemesCollectionViewController”).
- Click on the Collection View Cell in your Collection View.
- Open the identity inspector and set the cell class and reuseIdentifier to be “VillainCollectionViewCell”. (For MemeMe, this will be the custom cell class you created earlier.)
- For practice, drag a UIImageView into the Collection View Cell.
- Connect the imageView outlet of the VillainCollectionViewCell to the UIImageView you just added.
- Run the project!

Now go repeat these steps in your version of MemeMe!
