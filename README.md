# dls-github-label-maker
Apply a standardized set of labels to github repositories

All repositories are likely to have some assortment of unique labels. Many / Most of these will be #000000 for the relevant feature.

# Setup

```
$ brew install lastpass-cli
```

# Run instructions

To allow this tool to fetch the github token from lastpass, you have to log in
to lastpass each time you want to use it.

```
$ lpass login <email@email.com>
```

To apply all the labels from labels.json to a repository, do:

```
$ bin/labeler apply_labels [organization/repository]
```

# Reference
https://www.rubydoc.info/gems/octokit/4.21.0/Octokit/Client/Labels
