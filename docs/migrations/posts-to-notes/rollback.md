# Roll Back Posts To Notes Migration

The migration is intended to be committed as one isolated commit after verification.

To roll it back after that commit exists:

```bash
git revert <migration-commit>
bundle exec jekyll build --disable-disk-cache
bash script/check-redirects-for-renamed-urls.sh HEAD^
```

Replace `<migration-commit>` with the commit hash for the posts-to-notes migration commit.
