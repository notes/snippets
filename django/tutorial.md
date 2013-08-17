Django Tutorial
===============

Install:

    $ sudo pip install Django

Start a project and view initial pages:

    $ django-admin.py startproject myproj
    $ cd myproj
    $ vim myproj/settings.py
    ...edit DATABASES, TIME_ZONE, LANGUAGE_CODE and INSTALLED_APPS...
    $ vim myproj/urls.py
    $ python manage.py syncdb
    $ python manage.py runserver 8888
    $ firefox http://localhost:8888/

Create an extra app:

    $ python manage.py startapp polls
    
Create `models.py`:

    $ vim polls/models.py
    from django.db import models
       
    class Poll(models.Model):
        question = models.CharField(max_length=200)
        pub_date = models.DateTimeField("date published")
        def __unicode__(self):
            return self.question
    
    class Choice(models.Model):
        poll = models.ForeignKey(Poll)
        choice_text = models.CharField(max_length=200)
        votes = models.IntegerField(default=0)
        def __unicode__(self):
            return self.choice_text
    
Check generated SQLs:

    $ python manage.py sqlall polls
    BEGIN;
    CREATE TABLE "polls_poll" (
        "id" integer NOT NULL PRIMARY KEY,
        "question" varchar(200) NOT NULL,
        "pub_date" datetime NOT NULL
    )
    ;
    CREATE TABLE "polls_choice" (
        "id" integer NOT NULL PRIMARY KEY,
        "poll_id" integer NOT NULL REFERENCES "polls_poll" ("id"),
        "choice_text" varchar(200) NOT NULL,
        "votes" integer NOT NULL
    )
    ;
    CREATE INDEX "polls_choice_70f78e6b" ON "polls_choice" ("poll_id");
    
    COMMIT;

Create DB tables:

    $ python manage.py syncdb
    Creating tables ...
    Creating table polls_poll
    Creating table polls_choice
    Installing custom SQL ...
    Installing indexes ...
    Installed 0 object(s) from 0 fixture(s)

Create a function-based view:

    $ vim polls/views.py
    from django.http import HttpResponse
    
    def index(req):
        return HttpResponse("Hello, World!")

Wire the view into the local URL dispatcher:

    $ vim polls/urls.py
    from django.conf.urls import patterns, url
    from polls import views
    
    urlpatterns = patterns('',
        url(r'^$', views.index, name='index'),
    )

Connect the dispatcher to the top-level one.  Here `myproj/urls.py` itself is referenced by `ROOT_URLCONF` in `myproj/settings.py`, which is referenced by the environment variable `DJANGO_SETTINGS_MODULE`.

    $ vim myproj/urls.py
    from django.conf.urls import patterns, include, url
    
    urlpatterns = patterns('',
        url(r'^polls/', include('polls.urls')),
    )

Create a template HTML, where `url` refers a name in the URL dispatcher:

    $ mkdir -p polls/templates/polls
    $ vim polls/templates/polls/index.html
    {% if latest_polls %}
    <ul>
    {% for poll in latest_polls %}
        <li><a href="{% url 'detail' poll.id %}/">{{poll.question}}</a></li>
    {% endfor %}
    </ul>
    {% endif %}

Refer the template in the view.  Here the template loading logic comes from `TEMPLATE_LOADERS` in `myproj/settings.py`:

    $ vim polls/views.py
    from django.http import HttpResponse
    from django.template import RequestContext, loader
    from polls.models import Poll
    
    def index(req):
        latest_polls = Poll.objects.order_by('-pub_date')[:5]
        context = RequestContext(req, {'latest_polls': latest_polls})
        template = loader.get_template('polls/index.html')
        return HttpResponse(template.render(context))

A shortcut is available because this idiom is so common:

    $ vim polls/views.py
    from django.shortcuts import render    
    from polls.models import Poll
    
    def index(req):
        latest_polls = Poll.objects.order_by("-pub_date")[:5]
        return render(req, "polls/index.html", {"latest_polls": latest_polls})

