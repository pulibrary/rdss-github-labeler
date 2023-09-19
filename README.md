# dls-github-label-maker

Apply a standardized set of labels to github repositories

# Labels styleguide

All repositories are likely to have some assortment of unique labels. Many / Most of these should have color black (#000000), which is the color we use for feature areas.

Labels should be lower case.

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

To apply all the labels from labels.json to a repository, do, e.g.:

```
$ bin/labeler apply_labels pulibrary/figgy,pulibrary/dpul,pulibrary/pulmap,pulibrary/pulfalight,pulibrary/lae-blacklight
```

To delete a label from all of the DLS repositories, do:

```
$ bin/labeler delete_label pulibrary/figgy,pulibrary/dpul,pulibrary/pulmap,pulibrary/pulfalight,pulibrary/lae-blacklight [label]
```

# Reference
* Code uses the [Octokit Client](https://octokit.github.io/octokit.rb/Octokit/Client/Labels.html)
* Styleguide originated from the [Drupal labels style guide](https://github.com/pulibrary/pul_library_drupal/wiki/Issues-Label-Style-Guide)

