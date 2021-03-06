# Flicks

# Project 1 - *Flicks*

**Flicks** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **25** hours spent in total

## User Stories

The following **required** functionality is completed:

- [X] User can view a list of movies currently playing in theaters. Poster images load asynchronously.
- [X] User can view movie details by tapping on a cell.
- [X] User sees loading state while waiting for the API.
- [X] User sees an error message when there is a network error.
- [X] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [X] Add a tab bar for **Now Playing** and **Top Rated** movies.
- [X] Implement segmented control to switch between list view and grid view.
- [X] Add a search bar.
- [X] All images fade in.
- [X] For the large poster, load the low-res image first, switch to high-res when complete.
- [X] Customize the highlight and selection effect of the cell.
- [X] Customize the navigation bar.

The following **additional** features are implemented:

- [X] Autolayout to accomedate different screen size and landscape mode.
- [X] Autolayout for self sizing dynamic height in UITableView.
- [X] A singleton to host all networking code which shaved a lot of code from the ViewControllers.


## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='https://cloud.githubusercontent.com/assets/5937001/19427972/15f46d2e-93fc-11e6-98b3-30bb8d8ee4f8.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

Setting Autolayout becomes tiring even in storyboard, and this is the 1st time I'm using priority between contraints. 

UICollectionView remains a tone of trial and error in sizing cells and insets.

UICollectionView's self sizing cell is not as trvial as UITableView's and I was not able to get it to work and wasted few hours.

Parsing json in Swift remains a tone of boiler plate code.

As this is the 1st week of the CodePath bootcamp.  Managing time throughout the week was also a challenge.  Basically I had to abandon any efforts towards the design of the app to make it not just ok.

## License

    Copyright [2016] [Chi Hwa Ting]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

