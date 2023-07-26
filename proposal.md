## Overview
`%wiki` will be an app for creating, reading, and collaborating on wikis. 

Any user should be able to create their own wiki, share it on the network, 
and make it available on the public internet ("clearweb") to be accessed like 
any site in the vein of Wikipedia.

Wikis should fit multiple typical use cases:
* Personal knowledge management, akin to Obsidian
* Public-facing documentation, such as the urbit.org developer guide
* Encyclopedia collaboratively maintained by many users, such as Wikipedia
* Private documentation within an organization, akin to Confluence


## Milestones

### Milestone 1 - Local wikis + Frontend
* Estimated completion: early September
* Compensation: 1 star
* Deliverables:
  * User can create/edit/delete local wikis
    * Only host can view or edit
  * User can create/edit/delete pages
  * Page content is markdown text
  * Frontend for reading and editing content
    * Each page has its own URL
    * Old versions of pages can be read
    * Pages support relative links to other pages in wiki

### Milestone 2 - Publicly readable wikis
* Estimated completion: late October (Assembly '23)
* Compensation: 1 star
* Deliverables:
  * Wikis can be kept private or made public
  * Public wikis can be read on the clearweb
    * Each page has its own URL, including old versions
  * Public wiki pages can be accessed via remote scry

### Milestone 3 - Publicly writeable wikis
* Estimated completion: December
* Compensation: 1 star
* Deliverables:
  * Wikis can be edited by remote users
  * Write access can be:
    * global (any user can edit unless banned)
    * restricted (only mods can edit)
  * Host can give mod powers to remote users
  * Host/mod can ban users from editing

### Milestone 4 - Discoverability
* Estimated completion: January 2024
* Compensation: 1 star
* Deliverables:
  * Public wikis will appear in search results
  * Searching for a page in the frontend will return relevant results in other 
  public wikis
  * Pages can have links to pages in remote public wikis

### Milestone 5 - Shared private wikis
* Estimated completion: March 2024
* Compensation: 1 star
* Deliverables:
  * User can grant access so only certain users can read


## My Background

I'm a fulltime software engineer working in the online payments and govtech 
space. I've been active on Urbit since 2019.

As part of the UF Grants program, I proposed, developed, and maintain the 
contacts app, `%whom`. Like `%whom`, `%wiki` also also require privacy settings,
 shareable user-made content, and an intuitive UI.

Before that, I also participated in Hoon School in 2020, and collaborated with 
Tirrel on `%studio` as an apprentice.
