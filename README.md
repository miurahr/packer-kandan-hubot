packer-kandan-hubot
===================

It build docker image for utilizing Kandan and Hubot.

It is inspired from 
blog: http://hidemium.hatenablog.com/entry/2014/11/03/022453

Build
-----

```
$ packer build kandan-hubot.json
```

Docker Usage
------------

```
$ docker pull miurahr/kandan-hubot
$ docker run -d -p 22 -p 3000:3000 miurahr/kandan-hubot
```

Contents
----------

The image contains:

- Kandan miurahr/kandan/i18n branch
- hubot 2.6.0
- hubot-kandan adapter 1.1.0

References
----------

  * https://github.com/github/hubot
  * https://github.com/kandanapp/kandan
  * https://github.com/kandanapp/hubot-kandan
