# Posting Instructions
- create a new file in `_posts` with a name `yyyy-mm-dd-title`
- commit & push/merge to branch master

# Testing
- just once: `bundle install`
- `bundle update` to make sure the local Jekyll installation is in sync with GitHub Pages
- `bundle exec jekyll serve`, then open http://127.0.0.1:4000 in your browser
- run feed through [feed validator](http://www.feedvalidator.org/check.cgi?url=https%3A%2F%2Frknuus.github.io%2Ffeed.xml)
- to check links locally:
  - `npm install broken-link-checker -g`
  - `bundle exec jekyll serve`
  - `blc http://127.0.0.1:4000 -ro`

# How it works
- because GitHub Pages only support a limited set of Jekyll plugins (e.g. asciidoc, but not asciidoctor) we use a customized publishing workflow
- it used to be based on Travis CI, but was migrated to GitHub Actions recently
- the Jekyll GitHub Action from the marketplace doesn't work out of the box
  - this is why I forked it and adjusted it to my needs until I upstreamed the fixes and findings
- using URL-based [link check action](https://github.com/marketplace/actions/broken-link-check)

# How to set it up
- create a new project on GitHub
- in [Settings/Developer settings/Personal access tokens](https://github.com/settings/tokens) create a new token with access to all `repo` elements
- copy the token for later use
- in the project settings/Secrets press "Add a new secret", enter "JEKYLL_PAT" as name and the token as value
  - secrets are explained on [GitHub help](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/creating-and-using-encrypted-secrets)
- in the project settings/Options scroll down to section "GitHub Pages" and select "master branch" as Source
  - beware: in the current setup the site will be published twice, a custom one available under https://<account>.github.io and the standard one (with limited Jekyll plugin support) to https://<account>.github.io/<project>
- create a file `<project>/.github/workflows/main.yml` with content:
  ```
  name: CI

  on: [push]

  jobs:
    build:

      runs-on: ubuntu-latest

      steps:
        - name: Checkout repository
          uses: actions/checkout@v1
          with:
            ref: master
        - name: Jekyll Action
          uses: rknuus/jekyll-action@bugfix/bundler-error
          env:
            JEKYLL_PAT: ${{ secrets.JEKYLL_PAT }}
            PUBLISH_REPO: <account>/<account>.github.io
    ```
- after pushing to branch master go to tab "Actions" on your project site and click on the triggered CI build

# References
- [Blog Backlog](https://trello.com/b/BPfN97cY/agile-quality-blog)
- [GitHub Actions documentation](https://help.github.com/en/actions/automating-your-workflow-with-github-actions)
- [Jekyll action (forked)](https://github.com/rknuus/jekyll-action)
  - [original](https://github.com/marketplace/actions/jekyll-action)
- [Creating and using encrypted secrets (GitHub Actions)](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/creating-and-using-encrypted-secrets)
- [Mastering Markdown](https://guides.github.com/features/mastering-markdown/)
- [Jekyll plugins and versions supported by GitHub Pages](https://pages.github.com/versions/)
- [Jekyll Feed plugin](https://github.com/jekyll/jekyll-feed)
- [centering of image caption as described by Ted](https://discuss.asciidoctor.org/How-to-center-image-caption-when-the-image-is-centered-td901.html)

## Troubleshooting
- [About Jekyll build errors for GitHub Pages sites](https://help.github.com/en/github/working-with-github-pages/about-jekyll-build-errors-for-github-pages-sites)
- [Troubleshooting Jekyll build errors for GitHub Pages sites](https://help.github.com/en/github/working-with-github-pages/troubleshooting-jekyll-build-errors-for-github-pages-sites)
- [Testing your GitHub Pages site locally with Jekyll](https://help.github.com/en/github/working-with-github-pages/testing-your-github-pages-site-locally-with-jekyll)
