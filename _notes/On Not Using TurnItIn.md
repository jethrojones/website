---
permalink: plagiarism
description: Explore the ethical and practical concerns surrounding the use of TurnItIn in academia. This note delves into the adversarial relationship it fosters between educators and students, the risk of false positives, and the implications of using student data to train proprietary models. Discover why some institutions, like Vanderbilt University, have chosen to disable TurnItIn's AI detection features and consider alternative solutions that prioritize academic integrity and data privacy.
title:
image:
published: "true"
sitemap: "true"
excerpt_separator: <!--more-->
category:
tags:
layout: note
date: 2025-10-23T16:19
last_modified_at: 2025-10-24 08:30:45
---


{% if page.image %} <img src="{{ page.image }}" alt=""> {% endif %}

For many years, I have despised the use of TurnItIn[^1]. There are three main issues that I have with this: 
1. Pitting teachers/professors against students
2. False Positives
3. Using my data to train the model
TurnItIn is the software that my university uses, but there are many others out there. 
## Adversarial relationship
The TurnItIn approach pits teachers against students from the very beginning. It essentially says, "I can't trust that you won't plagiarize so you have to run your paper through this computer tool to make sure."

Rather than teaching how to cite properly and put patterns in place to help students know beforehand, some teachers/professors have taken the approach that they must submit to TurnItIn before they even look at the paper.
## False Positives
Plagiarism detectors detect things incorrectly. It's not perfect, like most things aren't. But false positives is a big problem. And it makes me not want to use it at all. 

Vanderbilt University[^2] reached the same conclusion after months of testing Turnitin’s AI detector, noting both its unreliability and its risk of false positives. Vanderbilt reported that if applied to its 75,000 submissions in a single year, nearly 750 students could have been falsely accused of AI misuse. Vanderbilt therefore disabled Turnitin’s AI detection feature “in pursuit of the best interests of our students and faculty”. 

## Using my data to train the model
According to the [EULA](https://www.turnitin.com/terms-of-use-website/), by submitting my dissertation I grant Turnitin “a non-exclusive, royalty-free, perpetual, worldwide, irrevocable license to use such papers… for improving the quality of the Services generally" This license survives termination of the agreement, meaning my dissertation would remain indefinitely in Turnitin’s private database and potentially be used to evaluate other students’ work.

As I don't want my data used to further train the general LLM models for the companies I am using, I also don't want TurnItIn to use my data to further their business pursuits. 

Some would see using student data as a benefit that that student then won't be plagiarized. As I have talked with professors, they have indicated they would want to make sure they aren't accidentally plagiarizing something. 

I have academic integrity, and tools like TurnItIn start with the assumption that I don't. To me, using the tool is unethical for a professor to use. 

## An Alternative
I would like something where I can build my own checker, using my own files. I started doing that with [Nexa's Hyperlink](https://hyperlink.nexa.ai/), which is all local on your computer. 


[^1]: Turn it in is a tool that checks your work to make sure you're not plagiarizing. Learn more at [their web site](https://turnitin.com)

[^2]: Vanderbilt [turned off](https://www.vanderbilt.edu/brightspace/2023/08/16/guidance-on-ai-detection-and-why-were-disabling-turnitins-ai-detector/) the whole AI detector, as other schools have done, because of so many false positives. 
	
