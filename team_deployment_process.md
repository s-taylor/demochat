##Process Instructions

* Always work in a branch! Don't ever edit master directly. "git branch xyz" (to create the branch), "git checkout xyz" (to switch to the branch you have created)
* Once you're happy with what you've created in your branch...
* git add .
* git commit -m "your commit message"
* git checkout master (to switch back to the master branch)
* git pull origin master (download the lastest master branch from github)
* git diff master..xyz (to compare your branch code to master)

STOP AND CHECK THAT THERE ARE NO CONFLICTS WITH YOUR CODE VS MASTER

* git merge 
* git push origin master (send your merged code to github)

##Oops I changed master!

If you accidentally forget to create a branch and commit to master directly this is fixable..

* git branch xyz (to create a new branch)
* type "git log" and determine which commit was the last commit you pulled from github (you can log in to github and check if you're not sure!)
* take note of the commit id for this, it will be some long string of text e.g. 6784bc96e75d6b983c2ba1a40e102993c60b4089
* type "git reset --hard COMMITID" (where commit id is what you noted above). This will reset master back to the specified commit id but your branch will remain unchanged.

