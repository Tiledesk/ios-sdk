git add .
git tag $NEW_VER
git commit -m "podspec deploy v. $NEW_VER"
git push origin master --tags
echo Pushing to repo...
pod repo push --allow-warnings Tiledesk Tiledesk.podspec
