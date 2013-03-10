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
Adding a tree object.

    $ git update-index --add --cacheinfo 100644 9daeafb9864cf43055ae93beb0afd6c7d144bfa4 test.txt
    $ git write-tree
    2b297e643c551e76cfa1f93810c50811382f9117
    $ git cat-file -t 2b297e643c551e76cfa1f93810c50811382f9117
    tree
    $ git cat-file -s 2b297e643c551e76cfa1f93810c50811382f9117
    36
    $ git cat-file -p 2b297e643c551e76cfa1f93810c50811382f9117
    100644 blob 9daeafb9864cf43055ae93beb0afd6c7d144bfa4    test.txt

Adding another tree with a subdirectory.

    $ echo test2 > test2.txt
    $ git update-index --add test2.txt 
    $ git read-tree --prefix=subdir 2b297e643c551e76cfa1f93810c50811382f9117
    $ git write-tree
    8221e7bfbd32af0bd106412eca8efff32a854197
    $ git cat-file -p 8221e7bfbd32af0bd106412eca8efff32a854197
    040000 tree 2b297e643c551e76cfa1f93810c50811382f9117    subdir
    100644 blob 9daeafb9864cf43055ae93beb0afd6c7d144bfa4    test.txt
    100644 blob 180cf8328022becee9aaa2577a8f84ea2b9f3827    test2.txt

Commit the tree.  A commit is tree, author, committer and a commit log.

    $ echo 'first commit' | git commit-tree 8221e7bfbd32af0bd106412eca8efff32a854197
    00461ebf46abfae23d1d3b1812c39d7a93f08eed
    $ git cat-file -p 00461ebf46abfae23d1d3b1812c39d7a93f08eed
    tree 8221e7bfbd32af0bd106412eca8efff32a854197
    author notes <notes@localhost.localdomain> 1362879499 +0900
    committer notes <notes@localhost.localdomain> 1362879499 +0900
    
    first commit

Adding the second commit as a successor to the first one.

    $ echo test2 version 2 > test2.txt 
    $ git update-index test2.txt 
    $ git write-tree
    84985fc1ea6f057dd8124b38116631935a402aba
    $ echo 'second commit' | git commit-tree 84985fc1ea6f057dd8124b38116631935a402aba -p 00461ebf46abfae23d1d3b1812c39d7a93f08eed
    257c91017fcaeb0bde73d3cc4e828f27c86a7de9
    $ git log 257c91017fcaeb0bde73d3cc4e828f27c86a7de9
    commit 257c91017fcaeb0bde73d3cc4e828f27c86a7de9
    Author: notes <notes@localhost.localdomain>
    Date:   Sun Mar 10 10:44:18 2013 +0900
    
        second commit
    
    commit 00461ebf46abfae23d1d3b1812c39d7a93f08eed
    Author: notes <notes@localhost.localdomain>
    Date:   Sun Mar 10 10:38:19 2013 +0900
    
        first commit


