# Outline:

- A clean, dark, minimal to-do list app that allows users to categorize tasks by colour-coded categories and a priority level. The app removes any distractions and only shows the users what is truly important. The app is built using Flutter and data is persisted using SQL (via sqflite).

##INSERT VIDEO LINK HERE

- A detailed description of the different features of the application - how they were implemented - as well as a full layout of the app and its routing can be found in the description section down below.

# Purpose:

- Making apps had always been a subject of intrigue for me; the challenge of crafting a beautiful user interface that is both inviting as well as captivating, alongside the challenge of devising a user experience devoid of errors where all user actions that could cause potential bugs are accounted for, plus ultimately linking this design to a well-conjured back-end system which ensures that the app can flow smoothly. I wanted in.
- I had encountered Flutter while scouring videos on YouTube where people where full of praises for its design, host of plugins and high speed native support across platforms using a single codebase and it seemed like a wonderful package. Learning dart was not too tough owing to some experience with Java and a background in OOP programming with Python. Ultimately, I wanted (and want to) build a simple password manager to solve some key needs in my life but to get there, I had to first learn the basics of Flutter, and build apps that can persist data.
- Enter this app, a perfect stepping stone in that it would force me to learn how to use the sqflite plugin to store data, challenge me to create an engaging, clean UI as well as solving a personal need in wanting a distraction-free to-do list app with certain capabilities.
- In no way is this a complete project, I hope to be able to add some push-notification feature in the coming future as well as refactor my spaghetti code, which has come about owing to lack of experience with Flutter and Dart, and once I get enough knowledge on ideas like state management and figure out how to leverage the OOP mechanisms of dart, I will be able to prune this temporarily messy code.
- A resource that I used immensely in order to learn how to work with the sqflite plugin was this [YouTube video](https://www.youtube.com/watch?v=1BwjNEKD8g8&ab_channel=Smartherd) by Smartherd.

# Description:

- The image below displays the different pages of the application and how the pages link to one another.

![alt-text](https://github.com/akashvshroff/To_Do_List_App/blob/master/runtime_images/app_routing.png)

- Please excuse my poor artistic abilities which can be clearly viewed in these messy MS Paint lines that have been drawn. I am using this map-style of diagram to elaborate the various features of this app as well as the connections between the pages.
- There are 3 pages:
  - The home screen, labelled "TASKS" where the user can observe all their pending tasks, colour coded by priority as well as category with a red checkbox indicating urgent. Each category has its specific colour which can be edited. Users can also filter their tasks by category and click on a task to edit it (and see the description) or simply choose to add a new task. Deleting a task is also possible here.
  - The editing screen, the label for which changes based on whether a user is adding ("ADD") a task or editing ("EDIT") a previously added task. Here users can set the task name, description, category as well as priority and then choose to save the task, i.e updating the previous task or saving a new one, or simply discard it. The users can access the category editing screen as well.
  - The categories screen, labelled "EDIT CATEGORIES", where users can change the colour for categories, delete ones they do not need and add categories as per their requirements. In case users delete a category which has been attributed to some tasks already, those tasks simply revert back to a default category. Clicking on a category allows the user to change its name and colour as well!
- To be more memory-efficient, the SQL database has been set up bearing in mind a relational table system where there are 2 tables, one for tasks and one for categories and they are connected by the taskCategory parameter that is a foreign key integer that points to some categoryId within the category table, thereby storing an int instead of a string and facilitating for easy storage of colours as well.
- In the colours.dart file, I maintain all the colours that have been used throughout the project and these colours, especially the surface colours have been chosen bearing in mind the [dark theme guidelines](https://material.io/design/color/dark-theme.html) by the Material scheme.
- The font used throughout the project is Roboto Mono and can be found on [Google fonts](https://fonts.google.com/specimen/Roboto+Mono?category=Monospace).
