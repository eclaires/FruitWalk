# ![Screenshot 2025-05-26 at 5 59 32 PM](https://github.com/user-attachments/assets/147de368-30e8-4cd4-817f-b847707a954b) FruitWalk
This repository contains mobile clients which display the data collected by the non profit organization [falling fruit](https://fallingfruit.org/about) 

[Falling fruit](https://fallingfruit.org/about) has amassed a huge global database of locations of public fruit. They have both a [web client](https://fallingfruit.org/) and mobile clients.

My motivation for building another mobile client (currently iOS is in development and Android is not started) is two-fold. 

**First** to build something I would use and am interested in. I take daily walks and often notice ripe fruit which could be respectfully picked (i.e. take one piece and leave more for others). I'd thought of building an app for myself to catalog my favorite neighborhood trees so I was inspired when I found [falling fruit](https://fallingfruit.org/) which had done all the back-end work.

**Second** I'm a client-side software developer loves who building apps and learning while thinking about usability and simplicity. I'm currently building the iOS app using Swift, SwiftUI and UIKit.

The iOS app has basic features but still needs polish and _sign-in/sign-up/forgot password_ functionality in order to _add, edit, rank and comment_ on fruit locations.

The basic features include:

### Initial Screen
The application launches to a map with the user location displayed if the user has given the app location permission.

![Map-User-Location](https://github.com/user-attachments/assets/c7d5ea3a-6bb6-4a99-86f1-a48ef9afda77)

### Selected fruit details
When a fruit location is selected a more detailed popup is displayed. If an image was uploaded when the location was entered, it is displayed, otherwise the default FruitWalk icon is shown. Ideally there would instead be a generic image of the fruit when the image is missing.

![selected](https://github.com/user-attachments/assets/8a9bc1f7-5b5e-40c7-85d2-804e2e959c4e)

The popup includes buttons common to the app:

![filtering](https://github.com/user-attachments/assets/f09cd3dd-7831-47f0-b48a-be3f8fadce1f) **filter** the map on that type of fruit

![Screenshot 2025-05-26 at 10 07 09 AM](https://github.com/user-attachments/assets/f4c821ee-a08d-44d1-befe-bc40b284e672) invoke a **look around** preview at that location

![Screenshot 2025-05-26 at 10 07 43 AM](https://github.com/user-attachments/assets/a89f9276-adf8-4e2d-9656-bb720f4b4cb2) add that specific fruit location to your **Favorites**.

![Screenshot 2025-05-26 at 10 11 14 AM](https://github.com/user-attachments/assets/aaf93fd4-2785-453d-9c05-e77290e25bc8) **directions** to the location, walking, biking, or driving, depending on the distance from the user's current location. The directions are opened in Apple Maps.

### Fruit locations list
The upper left hand corner list icon ![Screenshot 2025-05-26 at 9 37 45 AM](https://github.com/user-attachments/assets/7e68344a-7f1e-4881-b27b-47522e58f301) is used to display a list of fruit locations on the map. The list is grouped by fruit types. If a group has one item it is shown without a group header, as a single list item.

![selected-w-expand](https://github.com/user-attachments/assets/4016ab02-4ca8-438e-ad7d-ef43f8f6e61d)

Each list item has the addition button:

![select](https://github.com/user-attachments/assets/14022385-1bd6-4c04-bdb0-f9253aa34329) for showing and selecting the item on the map and dismissing the list.

### Map search
The hourglass in the upper right invokes a text entry field used to search for an address on the map. Selecting one of the search results will show that location on the map.

![Address-Lookup](https://github.com/user-attachments/assets/d2dabe9e-0411-4f85-b5f0-8663d7daf4d2)

### Map zooming
The map can be zoomed in and out. When zoomed out it shows clusters and not individual fruit locations.

![zoom-2](https://github.com/user-attachments/assets/987bed81-6890-47f4-ade7-85b6a0c3a394) ![zoom-1](https://github.com/user-attachments/assets/c20c9fbc-6fd2-496d-b1ba-608cd266a4d9) ![clusters](https://github.com/user-attachments/assets/b0aa0807-05c9-4ddd-aefc-b7b41c5e3302)

### Favorites
The Favorites button on the upper left of the map highlights Favorites on the Map. Below the heart is selected and four favorite locations are shown on the map.

![favorite-highlight](https://github.com/user-attachments/assets/62230dbe-a373-47fe-aa67-0921e8396ed1)

The Favorites tab item shows your list of Favorite fruit locations. These be sorted by distance from your current location or name using the sort button ![sort](https://github.com/user-attachments/assets/b2c262ad-aa67-4854-9d72-a4f8297aba00) in the upper left.

![Favorites-Distance](https://github.com/user-attachments/assets/9d59c27c-079d-4bb2-afd0-ac4dbcda260a) ![Favorites-Alphabetic](https://github.com/user-attachments/assets/364ec620-5676-4f79-ac59-579c12433e96)



