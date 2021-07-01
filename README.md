# FOODIE

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
FOODIE - A food centered app to share, teach, and learn about cultures through food around the world.

### App Evaluation
- **Category:** Social, lifestyle
- **Mobile:** There are many user interaction in the app community: users will be able to take food pictures and share in a post on the platform. Users will also be able to view restraunts in selected region's map and mark them down. Users can also view, comment, and like others' posts.
- **Story:** The value of the app is clear - to share, teach, and learn about cultures through food around the world. As a foodie, I was always looking for a platform that's specific to food-sharing but there's almost none in the market. Many people also take a large amount of time to look for good restraunts because resources are not concentrated in one platform. The app story solves this problem and goes beyond to connect people through food.
- **Market:** We mainly focus on young people who are active on social media and looking to learn more about cultures, or simply want to find a nice restraunt to hang out with friends. The app can be helpful when other age groups are planning a trip locally or to other regions since food is always an important part when we visit new places.
- **Habit:** Average users will consume the content on the app and sometimes create their own post to showcase a restraunt they like or share a receipt. The platform is interactive and habit-forming because this app serves as a centralized platform for food info.
- **Scope:** The goal is clearly defined. It is doable to complete an MVP where users can post and interact with other posts + a map function to view local restraunt so users can bookmark them. An addtional feature can be the app will help users to set up a meal-together with strangers (if they would like to connect with new friends) or friends.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

Post:
* User can post a new post to their feed
* User can create a new account
* User can login
* User can search for other users
* User can like a post
* User can bookmark a post
* User can view a feed of photos

Map:
* User can see nearby restraurants in a map and mark down restaurants in one folder based on area or other self-defined category
* User can see posts nearby or choose a region


**Optional Nice-to-have Stories**

Post:
* User can add a comment to a photo
* User can tap a photo to view a more detailed photo screen with comments
* User can see trending posts
* User can search for posts by a hashtag or the name of the restraunt
* User can see notifications when their photo is liked or they are followed
* User can see their profile page with their posts
* User can follow/unfollow another user
    * User can see a list of their followers
    * User can see a list of their following
* User can view other user’s profiles and see their post feed

Map:
* User can initiate a meal-together with strangers/followers/friends. They can invite specific people or leave it as a post to have other people joining.

### 2. Screen Archetypes

* Login Screen
   * User can create a new account
   * User can sign in
* Stream 
    * User can scroll through posts 
        * Nearby (based on location)
        * Explore (a mix of posts that can be from other regions)
* Map View - visualizing location-based restraunt information
   * Users can see nearby restraunt based on selected regions
   * Users can mark down restraunts
   * Users can tap in the restraunt and see relevant posts 
* Detail
    * Users can see details of a post
* Creation 
    * User can create a new post (share a restraunt / receipt)
* Profile 
    * User can view their identity and stats

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Stream screen
* Creation screen
* Profile screen

**Flow Navigation** (Screen to Screen)

* Login screen
   * Stream feed
* Stream screen
   * Nearby posts
       * Detail screen once tab on a post
   * Explore posts
       * Detail screen once tab on a post
* Creation screen
    * Home screen (after creation)

## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="YOUR_WIREFRAME_IMAGE_URL" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
