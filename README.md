Original App Design Project - README Template
===

# FoodieWIKI

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
FoodieWIKI - A food centered app to bookmark and learn about cultures through food around the world.

### App Evaluation
- **Category:** Lifestyle
- **Mobile:** Users will also be able to view restraunts in selected region's map and mark them down. User can filter restraunts based on their choices.
- **Story:** The value of the app is clear - to learn about cultures through food around the world. As a foodie, I was always looking for a platform that's specific to food-searching but there's almost none in the market. Many people also take a large amount of time to look for good restraunts because resources are not concentrated in one platform. The app story solves this problem.
- **Market:** We mainly focus on young people who are looking to learn more about cultures, or simply want to find a nice restraunt to hang out with friends. The app can be helpful when other age groups are planning a trip locally or to other regions since food is always an important part when we visit new places.
- **Habit:** Average users will consume the content on the app. The platform is habit-forming because this app serves as a centralized platform for food info.
- **Scope:** The goal is clearly defined. It is doable to complete an MVP where users can view local restraunt and bookmark them. 

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**
- [x] User can create a new account
- [x] User can login/logout
- [x] User can bookmark/unbookmark a restaurant
- [x] User can view a feed of restraunt cards
- [x] User can see detial page of a restaurant
- [x] User can see nearby restraurants in a map and mark down restaurants 


**Optional Nice-to-have Stories**
- [x] User can see other users who bookedmarked the restaurant on restaurant detail page
- [ ] User can tap a photo to view a more detailed photo screen
- [x] User can see their profile page with their bookmarks
- [x] User can view other user’s profiles and see their bookmarks
- [ ] User can see restraunts nearby or choose a region


### 2. Screen Archetypes

* Login Screen
   * User can create a new account
   * User can sign in
* Stream 
    * User can scroll through restraunt info 
        * Nearby (based on location)
        * Explore (a mix of cards that can be from other regions)
* Map View - visualizing location-based restraunt information
   * Users can see nearby restaurant based on selected regions
   * Users can mark down restaurants
   * Users can tap in the restaurant and see details
* Detail
    * Users can see details of a restraunt
* Profile 
    * User can view their identity and stats

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Stream screen
* Profile screen

**Flow Navigation** (Screen to Screen)

* Login screen
   * Stream feed
* Stream screen
   * posts (optional)
       * Detail screen once tab on a card
   * restaurant cards
       * Detail screen once tab on a card
   * google map view
       * Google map view of all cards in stream screen  
          * Detil screen once tab on a marker info page  
* Profile screen
    * Bookmarks

## Wireframes
<img src="https://github.com/minzsiure/Foodie/blob/main/Screen%20Shot%202021-07-12%20at%2011.35.53%20AM.png?raw=true" width=600>
<img src="https://github.com/minzsiure/Foodie/blob/main/foodieWIKI.gif?raw=true" width=400> 

## Schema 
### Models
**User**
| Property   | Type                       | Description                                                |
| ---------- | -------------------------- | ---------------------------------------------------------- |
| objectID   | String                     | unique id for the user (default field)                     |
| createdAt  | dateTime                   | date when user is created (default field)                  |
| updatedAt  | dateTime                   | date when user is last updated (default field)             |
| username   | String                     | unique username for the user (default field)               |
| email      | String                     | unique email for the user registration (default, optional) |
| password   | String                     | password for the user (default field)                      |
| Region     | String                     | user current location (city, state)                        |
| profilePic | File                       | user custom profile picture                                |
| restaurants | array of restaurants objectID| a list of restaurants being bookmarked                       |
| name | String | user's customized name|

**Bookmark**
| Property  | Type                       | Description                                |
| --------- | -------------------------- | ------------------------------------------ |
| objectID  | String                     | unique id for the bookmark (default field) |
| author    | pointer                    | user who authored this bookmark book       |
| restaurants | array of restraunt objectID | a list of restaurants being bookmarked       |
| updatedAt | dateTime                   | date when bookmark is created              |
| createdAt | dateTime                   | date when bookmark is updated              |

**Restraunt**

| Property     | Type                  | Description                                        |
| ------------ | --------------------- | -------------------------------------------------- |
| objectID     | string                | unique id for the restraunt (default field)        |
| name         | Text                  | Text                                               |
| posterPic    | file                  | the profile picture of the restraunt shown to user |
| otherPics    | array of files        | other pictures of the restraunt                    |
| rating       | Number                | restaurant rating                                   |
| website      | String                | restaurant website                                  |
| phone number | String                | restaurant phone number                             |
| likedBy      | array of user objectID | users who bookmarked the restraunt                 |
| address      | String                | restraunt address                                  |

### Networking
* Login screen
   * (Create/POST) Create a new user when Sign Up in Parse
   * (Read/GET) Query form Parse corresponding user object when Sign in
* Stream screen
   * (Read/GET) Query restaurant cards from Yelp based on given location
   * (Read/GET) Query User bookmarks
   * (Create/POST) Create a new restaurant object if it's the first time being bookmarked
   * (Create/POST) Append current userID to restaurant object UserArray meaning current user bookmarked this restaurant
* Google map view screen
   * (Read/GET) Query map by centering map on user current location
   * (Read/GET) Query cards on user object in Streem screen to display location markers
* Profile screen
    * (Read/GET) Query logged in user object (userID and profile image)
    * (Read/GET) Quert logged in user bookmarks
    * (Update/PUT) Update user profile image
* Detail screen
    * (Read/Get) Query restaurant detail from Yelp given restaurantID of tapped cell in stream page
    * (Read/Get) Query all users who bookmarked the restaurant given restaurantID from Parse 
 
#### Google Map SDK
- Base URL - https://developers.google.com/maps/documentation/ios-sdk/overview

#### Yelp Business Endpoints
- Base URL - https://www.yelp.com/developers/documentation/v3

| HTTP verb | Endpoint         | Description                                                                                                                                                                                           |
| --------- | ---------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| GET       | /businesses/{id} | This endpoint returns detailed business content. Normally, you would get the Business ID from /businesses/search, /businesses/search/phone, /transactions/{transaction_type}/search or /autocomplete. |
| GET          | /businesses/search                 |This endpoint returns up to 1000 businesses based on the provided search criteria. It has some basic information about the business. To get detailed information and reviews, please use the Business ID returned here and refer to /businesses/{id} and /businesses/{id}/reviews endpoints.                                                                                                                                    
