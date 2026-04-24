---
layout: note
title: How to Merge PDFs on a Mac
date: 2010-04-29T10:53:00.000-07:00
author: jethrojones
tags:
  - combine PDFs
  - PDFs
  - automator
  - mac
modified_time: 2010-04-29T11:35:57.387-07:00
thumbnail: https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgEw78TXSnT8M3AAbGTDp2Xogmmi2MZzhfLuBUNL8ohtLWI6SSgPJxQoh3C4KhMH7yGbuCBxErG5Wv3srVXTV1f9kC4YR42b1tUR5E7LwRFQgrzwivzUIMOGyoAr7XdYmG6a80kHJ7d2gos/s72-c/Workflow.png
blogger_id: tag:blogger.com,1999:blog-3944273018536227154.post-3256341742862302569
blogger_orig_url: https://mrjonesed.blogspot.com/2010/04/how-to-merge-pdfs-on-mac.html
content_type: post
original_post_path: _posts/2010-04-29-how-to-merge-pdfs-on-mac.html
permalink: /2010/04/29/how-to-merge-pdfs-on-mac/
last_modified_at: 2026-04-23 20:45:57
---
<div style="text-align: left;">

**Twitter Version:** Create an automator workflow that gets files from
Finder and combines them to a single PDF.

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

  

</div>

<a
href="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjZG9ev0kOhB3BrZzkjtbOJLQ9PJiijoXnE44S7K_enDqq2LArDlNSBuHKsJmIKT-dNozPvykUTwZFlpyh8vyDbJd50ZBXARqqkaCL6WsqaYozbklYSPbFP6PZq9_tu_be8jzD3Z9_l-2kJ/s1600/workflow-1.png"
onblur="try {parent.deselectBloggerImageGracefully();} catch(e) {}"></a><span class="Apple-style-span"
style="font-size:small;">I got this hint from the comments on
</span>[<span class="Apple-style-span"
style="font-size:small;">MacOSxhints.com</span>](http://www.macosxhints.com/)<span class="Apple-style-span"
style="font-size:small;"> while trying to merge PDFs for a class I am
teaching. I scanned in a few pages from a book, and the scanner created
separate PDF files. For my students, I knew it would be easier if they
were one PDF, so I wanted to merge them. According to
</span>[<span class="Apple-style-span" style="font-size:small;">this
article</span>](http://www.macosxhints.com/article.php?story=20071114191806624)<span class="Apple-style-span"
style="font-size:small;">, you can do that in Preview, which is fine,
except that there is no way to save them as one file. So, I read this in
one of the comments: </span>

<div>

<span class="Apple-style-span" style="font-size:small;">  
</span>

</div>

<div>

<span class="Apple-style-span"
style="font-family:verdana, tahoma, helvetica, arial, sans-serif;"></span>

> <span class="Apple-style-span" style="font-size:small;">The simplest
> (and least expensive) way is to create a 2-step Automator application
> that containds the following automator steps:  
>   
> 1: Ask for Finder Items (allow multiple selection) - to select the
> images/pdf files  
> 2. New PDF From Images or  
> 2: Combine PDF Pages  
>   
> This will save a single file with all your desired scanned images into
> one file.  
>   
> ---  
> D. Brownstone</span>

</div>

<span class="Apple-style-span" style="font-size:small;">  
  
So, I did that, and it worked perfectly. Here is my revised workflow:  
</span><a
href="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgEw78TXSnT8M3AAbGTDp2Xogmmi2MZzhfLuBUNL8ohtLWI6SSgPJxQoh3C4KhMH7yGbuCBxErG5Wv3srVXTV1f9kC4YR42b1tUR5E7LwRFQgrzwivzUIMOGyoAr7XdYmG6a80kHJ7d2gos/s1600/Workflow.png"
onblur="try {parent.deselectBloggerImageGracefully();} catch(e) {}"><img
src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgEw78TXSnT8M3AAbGTDp2Xogmmi2MZzhfLuBUNL8ohtLWI6SSgPJxQoh3C4KhMH7yGbuCBxErG5Wv3srVXTV1f9kC4YR42b1tUR5E7LwRFQgrzwivzUIMOGyoAr7XdYmG6a80kHJ7d2gos/s400/Workflow.png"
id="BLOGGER_PHOTO_ID_5465621642094496162"
style="display:block; margin:0px auto 10px; text-align:center;cursor:pointer; cursor:hand;width: 400px; height: 311px;"
data-border="0" /></a><span class="Apple-style-span"
style="font-size:small;">  
  
You'll see that I added a couple steps:</span>

<div>

- <span class="Apple-style-span" style="font-size:small;">Name Single
  Item in Finder Item Names</span>
- <span class="Apple-style-span" style="font-size:small;">Add Date or
  Time to Finder Item Names</span>
- <span class="Apple-style-span" style="font-size:small;">Move Finder
  Items</span>

<div>

<span class="Apple-style-span" style="font-size:small;">These three
actions will rename the new combined file to a name I chose ("Combined
PDF" in this case), append a date and time to the beginning of the
filename, and move it to my desktop: "2010-o4-29 Combined
PDF.pdf"</span>

</div>

<div>

<span class="Apple-style-span" style="font-size:small;">  
</span>

</div>

<div>

<span class="Apple-style-span" style="font-size:small;">Alternatively,
if you don't want it to always be named "Combined PDF" you can check the
box "Show this action when the workflow runs" (in Options on the "Name
Single Item in Finder Item Names" action) and it will prompt you for a
new name every time you run this workflow. </span>

</div>

<div>

<span class="Apple-style-span" style="font-size:small;">  
</span>

</div>

<div>

  

</div>

<div>

<span class="Apple-style-span"
style="color: rgb(0, 0, 238); -webkit-text-decorations-in-effect: underline; "><img
src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjZG9ev0kOhB3BrZzkjtbOJLQ9PJiijoXnE44S7K_enDqq2LArDlNSBuHKsJmIKT-dNozPvykUTwZFlpyh8vyDbJd50ZBXARqqkaCL6WsqaYozbklYSPbFP6PZq9_tu_be8jzD3Z9_l-2kJ/s400/workflow-1.png"
id="BLOGGER_PHOTO_ID_5465624634704013522"
style="display: block; margin-top: 0px; margin-right: auto; margin-bottom: 10px; margin-left: auto; text-align: center; cursor: pointer; width: 400px; height: 175px; "
data-border="0" /></span>

</div>

<div>

<span class="Apple-style-span" style="font-size:small;">  
</span>

</div>

<div>

  

</div>

<div>

  

</div>

<div>

<span class="Apple-style-span" style="font-size:small;">If you have Snow
Leopard and you want to make this even cooler, you can create a new
Service in Automator instead of a workflow, and then at the top of the
service workflow, choose service receives selected "PDF files" in "any
application" and the rest will be the same. (Although, don't tell the
services workflow to show the action when the workflow runs because it
won't.) Now, you can just create a shortcut that combines selected PDFs.
</span>

</div>

  

</div>

<div>

Have a Good Life.

</div>
