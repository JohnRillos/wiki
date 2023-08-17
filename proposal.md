## Overview
`%wiki` will be an app for creating, reading, and (ultimately) collaborating on wikis. 

Any user should be able to create their own wiki, share it on the network, 
and make it available on the public internet ("clearweb") to be accessed like 
any site in the vein of Wikipedia.

Wikis should fit multiple typical use cases:
* Personal knowledge management, akin to Obsidian
* Public-facing documentation, such as the urbit.org developer guide

Future work (descoped from this proposal):
* Encyclopedia collaboratively maintained by many users, such as Wikipedia
* Private documentation within an organization, akin to Confluence


## Milestones

### Milestone 1 - Local wikis + Frontend
* Estimated completion: late September
* Compensation: 2 stars
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
* Compensation: 2 stars
* Deliverables:
  * Wikis can be kept private or made public
  * Public wikis can be read on the clearweb
    * Each page has its own URL, including old versions
  * Public wiki pages can be accessed via remote scry

### Milestone 3 - Obsidian file import/export
* Estimated completion: November
* Compensation: 1 star
* Deliverables:
  * Folders of `.md` files can be imported as wikis.
  * Wikis can be exported as folders of `.md` files.


## My Background

I'm a fulltime software engineer working in the online payments and govtech 
space. I've been active on Urbit since 2019.

As part of the UF Grants program, I proposed, developed, and maintain the 
contacts app, `%whom`. Like `%whom`, `%wiki` also also require privacy settings,
 shareable user-made content, and an intuitive UI.

Before that, I also participated in Hoon School in 2020, and collaborated with 
Tirrel on `%studio` as an apprentice.
