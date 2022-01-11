# Orion Post-Mortem

As stated in the ReadMe, It brings me no joy to write the following: This project is dead. As poetic as I can get about how "the words are sharp daggers in me" or how "these words bring more pain than the stress they relieve", I'll try my best not to do so.

Outlined below is a short "list" of issues I ran into and their affects on my overall stress as well as how I flipped the script and learned.

## My Personal ~~Hell~~ Experiences

### Learning AppKit

Yes, I have very little experience with AppKit. Might I add that many others seem to have more experience with UIKit or another iOS related framework provided by Apple or Apple affiliates. This really didn't help. The differences weren't as stark but I had to consequently relearn the layout system (as mentioned in a later segment) and the entire lifecycle.

One of the oddest things about AppKit compared to my prior experience is the fact that there is the need to manage windows as well as an application menu. These sorts of things may have contributed to my total confusion of why things weren't working how I expected. On top of that, the idea of a "window controller" was completely foreign to me. I've never heard or dreamt of such a thing. A large majority of AppKit's macOS specific stuff (including the annoying `NSToolbar`) had to be learned before continuing.

So, what did I learn? For starters, I learned that Xcode has built-in documentation which is awesome. I also learned way more about how to create applications with toolbars (since it became such a big thing). In general, I learned AppKit :p

### Dealing WebKit

When I originally outlined this document, I meant to talk about the toolbar after the "Learning AppKit" segement. But of course, I changed my mind the last minute. The reasoning? Well, it'd be great to have a quick break from something long into something that would be a bit shorter. If you've skimmed this document, you might even call it the "calm before the storm" as it were. This section focuses slightly on the short yet crippling panic attacks and mental breakdowns induced by the occasionally working `WKUserScript` and `WKUserContentController`, two classes that now induce a mild PTSD due to the rollercoaster of emotions I've gone through.

Ok, to begin, I should just say that my current method seems to be the best. It was the easiest as well as the safest I could think of. But, I ran into many issues where WebKit would occasionally neglect to inject my scripts into code (as well as the absence of the "Extra Scripts" menu from the inspector). I don't think I need to say how much of a pain this is considering the fact that this was the basis of Orion. Anyway, I said I would keep this short and I am true to my word.

### The Damn Toolbar

As much as I want to stay professional, I can't get over the fact that a simple f-cking toolbar got in the way of the progress of Orion. I poured hours into relearning the constraint system and the equations and solving the equations myself ON PAPER BY HAND before reimagining it as code. For as much as I hate everything about the toolbar, I've learned quite a bit about how it works. I've learned everything from the standard button sizings (including the sizes for images) to creating custom controls (though it isn't exemplified as well in Orion).

The biggest thing I noticed in Safari is the fact that the "tab collection" stretched as far as possible taking up as much space on the toolbar as needed. This was first theorised to be due to constaints leading up to where I'd implement a constaint such as `widthAnchor <= 10_000` and `widthAnchor >= 1` to stretch the toolbar as far as it could. This worked for the most part and saved me from dealing with manually calculating the size available (which I did end up doing in the end).

Moving into a more specific part of the toolbar was the tabs... The tab style was horrifyingly hard to implement from my standpoint. I was stuck wondering how to stretch the "tab collection" and how the tabs are proportionally calculated. I was very close at one point. Using constraints and animations to my advantage, I got exceptionally close to my goal:

> Note: This is a ***video***

[![Almost There...](https://i3.ytimg.com/vi/9RcvUaBPO5o/default.jpg)](https://www.youtube.com/watch?v=9RcvUaBPO5o)

After feeling the usual rush of energy from getting something to work, I started to wonder "how will I get this to look good" and "how can this look better" as any programmer would. Of course, I'm not as experienced in frontend development nevertheless macOS UI development so I had no idea how to fix the issue I had. So, I went onward with extensions.

### Extensions

I didn't have many issues with this section surprisingly and unsurprisingly. Most of it *is* file system management. That is, however, the most boring part of it. I can't express how much I dislike file I/O for how boring and uninteresting it is. Maybe its not how you feel but thats just me. Either way, I went through and finished the downloading and installing sections of extensions. I never made it to showing extension content since `NSPopover` didn't work for some odd reason. I created a small `NSAlert` and moved on to the more pressing topic, tabs. Later, I tried again and as you can see in the code it's unfinished. I've still got more to learn about the `NSPopover` but that seemed to be the only thing I didn't feel absolutely stressed about.

### Stress, Stress, Stress

I've always been known because of my ability to manage stress. I'm a person that can manage the workload of college level classes and the SATs and my hobbies and upcoming jobs while in the hardest year of high school: Junior year. Ok well... maybe not *that* good. But, I'm known for managing my stress, anger, sadness, and so much more. This project broke me. It's surprising to see something like this break me so easily. I can usually say that "I'm not good enough" despite me understanding the material and the assignment and I would be able to get out of doing a project without feeling bad. For this, I understood barely anything and the assignment was a bit harder than I had thought it would be. Underestimating was the worst mistake. I ended up getting stressed because I didn't know what I was doing wrong. If I could go back in time, I would warn my past self to *not* underestimate the requirements (I'm might even give past me some tips ;p). These stresses have done a number on my overrall mindset but I think it generated a net positive due to me being able to handle more stress easily with new relieving tactics. I can not express how much a short meditation session or even a nice nap can help.

### Closing Thoughts

I'm never good at these "closing thoughts" segments or such but I think this document deserved one. In general, I think it best to sum it up in a simple sentence:

I failed and failed but learned from my failures to make myself better than when I started.

... and thats it! It's not a long post-mortem and surely isn't a formal report but it serves as a way to remember what went wrong so I know what to avoid as well as a testament to future programmers of how - as cheesy as it is - "anything is possible if you give it all you've got"
