# Yet Another Agent Blog

A personal blog and project site built with [Jekyll](https://jekyllrb.com/) and hosted on [GitHub Pages](https://pages.github.com/).

## Local Development

```bash
bundle install
bundle exec jekyll serve
```

Then open [http://localhost:4000/Operator-Notes/](http://localhost:4000/Operator-Notes/).

## Writing

### Blog posts

Add a Markdown file to `_posts/` with the naming convention `YYYY-MM-DD-title.md`:

```markdown
---
title: "My Post Title"
date: 2026-03-19
tags: [topic1, topic2]
---

Post content here...
```

### Projects

Add a Markdown file to `_projects/`:

```markdown
---
title: "Project Name"
description: "Short description of the project."
link: "https://github.com/..."
---

Detailed write-up here...
```

## Deployment

Pushes to `main` automatically deploy via GitHub Actions. Make sure GitHub Pages is configured to use **GitHub Actions** as the source in your repo settings (Settings → Pages → Source → GitHub Actions).
