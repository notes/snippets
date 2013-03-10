Understanding Git
=================

Initialize a repository.

    $ mkdir t
    $ cd t
    $ git init
    $ find .git

Computing an object hash and writing it into the repository.

    $ echo test | git hash-object --stdin -w
    9daeafb9864cf43055ae93beb0afd6c7d144bfa4
    $ find .git/object -type f
    .git/objects/9d/aeafb9864cf43055ae93beb0afd6c7d144bfa4

Displaying the object content.

    $ git cat-file -t 9daeafb9864cf43055ae93beb0afd6c7d144bfa4
    blob
    $ git cat-file -s 9daeafb9864cf43055ae93beb0afd6c7d144bfa4
    5
    $ git cat-file blob 9daeafb9864cf43055ae93beb0afd6c7d144bfa4
    test

So it's a blob object.


