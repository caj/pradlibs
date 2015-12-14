### Pull Request Annoyance Delivery Libraries

# Ever have trouble getting the other members of your team interested in your PRs?

![img1](http://i.imgur.com/KQL8wKb.jpg)

# Do you feel you need to entice them with the promise of short code review, just to get your changes merged?

![img2](http://i.imgur.com/pTR9wVM.jpg)
![img3](http://i.imgur.com/OHuBnD3.jpg)


## You're doing it wrong!

# Stop pleading and grab their attention with PradLibs!

# With PradLibs, you can turn this:
```
# in slack
/buzz https://github.com/caj/pradlibs/pull/1
```

```
/buzz https://github.com/caj/pradlibs/pull/5
``

### into this!

[img4](http://i.imgur.com/TjJE8K0.png)

#### Yes. I want this. I want it so bad.

1. Fork it and navigate there
2. `heroku create` -> copy dat URL, yo
3. Navigate [over here](https://slack.com/settings) -> Slash Commands -> Add
4. Paste that junk in the URL field, but throw `/command` on the end of it. Also do the rest of that page.
  - `https://blah-blah.herokuapp.com` -> `https://blah-blah.herokuapp.com/command`
  - actual slash command text (ex: `/buzz`) is up to you.
5. Make a [GitHub access token](https://github.com/settings/tokens) thing, copy him too.
6. `heroku config:add PRADLIBS_ACCESS_TOKEN=<PASTE HIM>`
7. `git push heroku master`
8. Fill your slack channels with `/<cmd> <link to PR>` and watch the code reviews you asked for pour in!
