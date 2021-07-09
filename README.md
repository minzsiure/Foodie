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
* User can create a new account
* User can login/logout
* User can bookmark a restraunt
* User can view a feed of photos and restraunt cards
* User can see detial page of a restraunt
* User can see nearby restraurants in a map and mark down restaurants in one folder based on area (optional: or other self-defined category)


**Optional Nice-to-have Stories**
* User can search for other users
* User can tap a photo to view a more detailed photo screen
* User can see their profile page with their bookmarks
* User can view other user’s profiles and see their bookmarks
* User can see restraunts nearby or choose a region


### 2. Screen Archetypes

* Login Screen
   * User can create a new account
   * User can sign in
* Stream 
    * User can scroll through restraunt info 
        * Nearby (based on location)
        * Explore (a mix of cards that can be from other regions)
* Map View - visualizing location-based restraunt information
   * Users can see nearby restraunt based on selected regions
   * Users can mark down restraunts
   * Users can tap in the restraunt and see details
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
   * Nearby posts
       * Detail screen once tab on a card
   * Explore posts
       * Detail screen once tab on a card
* Profile screen
    * Bookmarks

## Wireframes
<img src="https://github.com/minzsiure/Foodie/blob/main/wireframe.png?raw=true" width=600>

## Schema 
### Models
**User**
| Property   | Type     | Description                                                |
| ---------- | -------- | ---------------------------------------------------------- |
| objectID   | String   | unique id for the user post (default field)                |
| createdAt  | dateTime | date when post is created (default field)                  |
| updatedAt  | dateTime | date when post is last updated (default field)             |
| username   | String   | unique username for the user (default field)               |
| email      | String   | unique email for the user registration (default, optional) |
| password   | String   | password for the user (default field)                      |
| Region     | String   | user current location (city, state)                        |
| profilePic | File     | user custom profile picture 
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
