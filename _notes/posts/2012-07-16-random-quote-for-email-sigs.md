---
layout: note
title: Random Quote for Email Signatures
date: 2012-07-16T06:14:00.000-07:00
author: jethrojones
tags:
  - geeky
  - Keyboard maestro
  - making technology work for me
  - textexpander
modified_time: 2012-07-17T10:58:44.892-07:00
thumbnail: https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjLgpqHnpruf3UhounSE-KL-10Bp_f3sk5MaRNibbpR5GmwoglbBJrR-7oaJdqomhlPIoS3c4_p0tO6n3qWrV6a9RwC0cAJkXOBm0ldvArVv_1tNRxz6U-fUpxp_ou09xiL3iXFkJuNDpPh/s72-c/TextExpander-20120714-003638.png.png
blogger_id: tag:blogger.com,1999:blog-3944273018536227154.post-8236290096117201977
blogger_orig_url: https://mrjonesed.blogspot.com/2012/07/random-quote-for-email-sigs.html
content_type: post
original_post_path: _posts/2012-07-16-random-quote-for-email-sigs.html
permalink: /2012/07/16/random-quote-for-email-sigs/
last_modified_at: 2026-04-23 20:45:58
---
*Add a random quote to every email @macdrifter @smilesoftware
@keyboardmaestro* \#summerblog12  
  
I’ve been collecting quotes for a long time. I don’t know how many I
have, but there are a lot of them. If I were to print out the text
document that they are all saved in, it would be 34 pages.  
  
Here are a couple random quotes:  

> “Creativity is piercing the mundane to find the marvelous.” - Bill
> Moyers 

> “To live a creative life, we must lose our fear of being wrong.” -
> Joseph Chilton Pierce 

> “Creativity is discontent translated into arts.” - Eric Hoffer

> “Things are only impossible until they’re not.” - Jean-Luc Picard

I’ve seen a lot of people put quotes at the bottom of their emails, and
if they are lucky, they remember to change them every six months or so.
I even get sick of my signature quotes, so I can’t imagine how those who
get my emails feel. And I know I get sick of seeing the same ones on
others’ emails. So, while trying to learn about something else, I
stumbled across the [SmileSoftware
blog](http://blog.smilesoftware.com/), and I found [this particularly
useful blog
post](http://blog.smilesoftware.com/2011/12/03/random-snippets/). Turns
out, this is really easy to implement. All you have to do is create a
group called “Random” and add your quotes to that group. You don’t even
have to create an abbreviation for the quotes.  
  

<div class="separator" style="clear: both; text-align: center;">

<a
href="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjLgpqHnpruf3UhounSE-KL-10Bp_f3sk5MaRNibbpR5GmwoglbBJrR-7oaJdqomhlPIoS3c4_p0tO6n3qWrV6a9RwC0cAJkXOBm0ldvArVv_1tNRxz6U-fUpxp_ou09xiL3iXFkJuNDpPh/s1600/TextExpander-20120714-003638.png.png"
data-imageanchor="1" style="margin-left: 1em; margin-right: 1em;"><img
src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjLgpqHnpruf3UhounSE-KL-10Bp_f3sk5MaRNibbpR5GmwoglbBJrR-7oaJdqomhlPIoS3c4_p0tO6n3qWrV6a9RwC0cAJkXOBm0ldvArVv_1tNRxz6U-fUpxp_ou09xiL3iXFkJuNDpPh/s1600/TextExpander-20120714-003638.png.png"
data-border="0" /></a>

</div>

  
Then, you create a snippet called “rrand”, or something like that. And
change the content to Applescript (This part is pretty important, so
don’t forget to do that.)  
  

<div class="separator" style="clear: both; text-align: center;">

<a
href="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiBVvem4vidO2Pm6Uvpc1BnVcXccKfkSq1KLdxgdv7horANWfnVvZLxssl0YYqHHOZ3O-EsrCHKCOLo6G6PcEtyllcFUEtlbXXsJVhzS6T9NstCNcY0GD8JBSQ6oROSwuMohMV5p41xUC3M/s1600/TextExpander-20120714-004217.png.png"
data-imageanchor="1" style="margin-left: 1em; margin-right: 1em;"><img
src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiBVvem4vidO2Pm6Uvpc1BnVcXccKfkSq1KLdxgdv7horANWfnVvZLxssl0YYqHHOZ3O-EsrCHKCOLo6G6PcEtyllcFUEtlbXXsJVhzS6T9NstCNcY0GD8JBSQ6oROSwuMohMV5p41xUC3M/s1600/TextExpander-20120714-004217.png.png"
data-border="0" /></a>

</div>

<span class="Apple-style-span" style="font-size: 13px;"></span>  
  
  
Then, you insert this code as the content, with “rrand” as the
abbreviation:  
  

    tell application "TextExpander"

        set groupCount to count (snippets of group "Random")

    set randomIndex to random number from 1 to groupCount

        return plain text expansion of ¬

            snippet randomIndex of group "Random"

    end tell

  
That is all on the [Smile
blog](http://blog.smilesoftware.com/2011/12/03/random-snippets/).  
  
The next part is what is really cool. I use [Keyboard
Maestro](http://www.keyboardmaestro.com/main/), which actually took me a
long time to get into it. I found a bunch of helpful hints and helps on
[Macdrifter](http://www.macdrifter.com/category/keyboard-maestro/). So,
I thought I would add to what I have learned from Gabe, and see if it
would work.  
  

<div class="separator" style="clear: both; text-align: center;">

<a
href="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjpgdvKv3q6nJ8qz5MOVrSMwTVd3uG5T0zACHmgIyP5ljdAAtthQPVIj87DSFb4TfwtMV1X6s3-cxM8weQ2OZJXZchzT8luMneMMO6vvj0DPbQG4ALQygc-lSJDhAlbruO19vd_Hdj6ucvP/s1600/Screen+Shot+2012-07-17+at+11.57.41+AM.png"
data-imageanchor="1" style="margin-left: 1em; margin-right: 1em;"><img
src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjpgdvKv3q6nJ8qz5MOVrSMwTVd3uG5T0zACHmgIyP5ljdAAtthQPVIj87DSFb4TfwtMV1X6s3-cxM8weQ2OZJXZchzT8luMneMMO6vvj0DPbQG4ALQygc-lSJDhAlbruO19vd_Hdj6ucvP/s1600/Screen+Shot+2012-07-17+at+11.57.41+AM.png"
data-border="0" /></a>

</div>

  
  
What this does is adds a random quote to the end of my email, and then
sends it when I press CMD+SHIFT+F. I chose that because I send emails in
Mail.app via the shortcut CMD+SHIFT+D, and F is really close to D, so I
still retain the option of not adding a quote if I don’t want to.
However, it is so easy to do, that I think I will add quotes to the
bottom of all my emails.  
  
A couple geeky notes about the Keyboard Maestro Macro.  
  
I had to choose “Type Keystroke” instead of “Insert Text” because
TextExpander wouldn’t expand “rrand” unless I did the keystrokes for
each letter. Also, using the “CMD+Down Arrow” keystroke forces the
cursor to go to the bottom of the email, regardless of what is there. If
I already have a signature, there are a few returns built into that so
there is always room for a quote.  
  
If I wanted to do this in Outlook, I would just change the last action
from “Type the CMD+SHIFT+D Keystroke” to “Type the CMD+Return
Keystroke”, and it would work the same way.  
  
This was a pretty fun thing to do. As I use some of these new-to-me
tools I realize how much fun it is to tweak with my computer and make it
work for me.  
  
Thanks to
<a href="http://macdrifter.com/" target="_blank">macdrifter</a>,
<a href="http://smilesoftware.com/" target="_blank">Smile Software</a>,
and <a href="http://keyboardmaestro.com/" target="_blank">Keyboard
Maestro</a> for helping me control my computer.  
  
Have a Good Life.  

<div class="separator" style="clear: both; text-align: center;">

</div>
