#+TITLE: Emacs, Org-mode & Hugo
#+DATE: 2024-07-04
#+DRAFT: false
#+SUMMARY: Discovering Emacs, simplifying note taking using Org-mode, and publishing articles online with Hugo.

Choosing an editor can be a tough choice when starting to program. Many people will change their environment through the years, some will stick to their most beloved one. Notepad++, Atom, VS Code, Vim, Emacs: the choices are multiple, and everyone can find what suits their personal needs. Some even choose to use less popular options, like [[https://www.olowe.co/][Oliver Lowe]] and his [[http://acme.cat-v.org/][Acme]] editor.

16 years ago, after building my first simple website from scratch, I wanted to make it available online, and I purchased a Linux VPS. Things weren't as easy as they are today, and serverless options weren't a thing. I quickly got lost, and had no idea how to edit text files from the terminal. Nano helped me for a bit, then Vim for a much bigger time. [[https://www.barbarianmeetscoding.com/boost-your-coding-fu-with-vscode-and-vim/moving-blazingly-fast-with-the-core-vim-motions/][Vim motions]] quickly grew on me, and I loved the speed at which I would be able to initiate actions.

Vim is a fantastic text editor, and it will be for many years to come. I, personally, never really liked the whole plugin-oriented environment, and would never manage to enjoy any of the plugin manager solutions. Even if the motions made me edit at the speed of thought, managing all the plugins and finding the best ecosystem to edit particular files ([[https://svelte.dev/][Svelte]] comes to mind) would make it far less enjoyable. That's when I discovered Emacs.

I fully understand the fact that some people dislike Emacs' complexity, but I love the built-in capability the GUI version has to browse directories using [[https://www.gnu.org/software/emacs/manual/html_node/emacs/Dired.html][Dired]], launch a terminal using any of the available commands or access remote files using [[https://www.gnu.org/software/tramp/][Tramp]]. MELPA also fully extends the range of possibilities, and allows it in a simple manner. Emacs doesn't fully encompass the following Unix philosophy, but it seems to be the perfect tool of my trade as of now.

#+begin_quote
Make each program do one thing well.
#+end_quote

You might be wondering why all this talk about an editor is taking place.

While researching about programming, I ended up on videos about taking notes, and the importance it can have in the process of learning. At first, I attempted to implement the Zettelkasten method, which [[https://github.com/rwxrob][Rob Muhlestein]] made me discover. I then switched to a much simpler solution, relying on one major file holding most of the data. This poses an issue about structuring and sectioning, which [[https://orgmode.org/][Org-mode]] helps me achieve with an incredible simplicity.

Headlines and visibility cycling is fantastic. Emacs shortcuts, even if much harder to remember compared to Vim counterparts, turns the whole writing activity into a pleasure and my single Org note file grows slowly but surely, safely stored on a private [[https://github.com/vanitysys28/][Git]] repo. With all these ideas and notes gathered in one file, I wanted a solution to share all this online, and I needed a solution to build a blog.

After a bit of documenting, I hesitated between [[https://astro.build/][Astro]] and [[https://gohugo.io/][Hugo]]. Astro would have been an easy choice, because of it being a Javascript framework. But I heard many good things about Hugo, and I decided to choose it in order to play with the Go language that interests me. [[https://gohugo.io/getting-started/quick-start/][Hugo documentation]] was of great help, and the blog was online in no time after following the tutorial on [[https://gohugo.io/hosting-and-deployment/hosting-on-github/][GitHub Pages hosting]]. The ability to use [[https://gohugo.io/content-management/formats/][Emacs Org Mode format]] directly without having to convert the content to Markdown is a fantastic functionality, and makes everything a breeze with my current environment.

I feel like these last words are of a major importance: many solutions are available to us today, and everyone can find what they love the most to make them more productive. The most important is about finding what you enjoy, and optimize it to make it the best for your activity. On my side, I feel like I found what suits me perfectly, and anyone can use it as inspiration by checking my publicly available [[https://github.com/vanitysys28/dotfiles/][dotfiles]]. 
