---
layout: page
title: Online Observation Form
categories: []
tags: []
status: publish
type: page
published: true
meta: {}
last_modified_at: 2024-12-18 22:18:34
---

# Online Observation Tool!


Here’s the Form for you to copy and make your own. 
[Click Here](https://docs.google.com/forms/d/1y_6TYWK7aHv-Zxu6wxx7Eyh_wZsmkvj5hF967FaBaXE/edit?usp=sharing)!

Here’s the spreadsheet with all the data so you can see it. 
[Click Here](https://docs.google.com/spreadsheets/d/148r6S2g3jCgylT7CA_d603A7c2uclMewkaK-6hEmS-M/edit?usp=sharing)!

Here is the 
[teacher spreadsheet](https://docs.google.com/spreadsheets/d/1xYDJWSDcWbx2PI0U4tBcPGjPnPp8UU7yHs2-qQ_5lR0/copy), just make a copy of this for each teacher, and watch the video below to set it up.


























##How to make Individual Teacher Spreadsheets























Here's the code you'll need for each teacher spreadsheet, be sure to use your own form responses link!

=QUERY(IMPORTRANGE("INSERT YOUR GOOGLE SHEET FORM RESPONSE LINK HERE","Form Responses 1!a2:k200"), "Select * where Col2='TEACHER NAME'", -1)
