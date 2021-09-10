# dls-github-label-maker
apply a standardized set of labels to github repositories

# Run instructions
To see a list of label categories run

`$ ./bin/labeler categories`

These scripts expect you to have a Github personal access token exported in your shell, under the name `GITHUBTOKEN`. That token should have `repo` access. For more information about creating a Github token, check out [their docs](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/).

# Reference
https://www.rubydoc.info/gems/octokit/4.21.0/Octokit/Client/Labels
