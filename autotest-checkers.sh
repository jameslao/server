#!/usr/bin/env bash
#
RESULT=0

bash ./build/autoloaderchecker.sh
RESULT=$(($RESULT+$?))
bash ./build/mergejschecker.sh
RESULT=$(($RESULT+$?))
php ./build/translation-checker.php
RESULT=$(($RESULT+$?))
php ./build/htaccess-checker.php
RESULT=$(($RESULT+$?))


for app in $(find "apps/" -mindepth 1 -maxdepth 1 -type d -printf '%f\n'); do
    if
        [ "$app" == "dav" ] || \
        [ "$app" == "encryption" ] || \
        [ "$app" == "federatedfilesharing" ] || \
        [ "$app" == "files" ] || \
        [ "$app" == "files_external" ] || \
        [ "$app" == "files_sharing" ] || \
        [ "$app" == "files_trashbin" ] || \
        [ "$app" == "files_versions" ] || \
        [ "$app" == "lookup_server_connector" ] || \
        [ "$app" == "provisioning_api" ] || \
        [ "$app" == "testing" ] || \
        [ "$app" == "twofactor_backupcodes" ] || \
        [ "$app" == "updatenotification" ] || \
        [ "$app" == "user_ldap" ]
    then
        ./occ app:check-code -c strong-comparison "$app"
    else
        ./occ app:check-code "$app"
    fi
    RESULT=$(($RESULT+$?))
done;

php ./build/signed-off-checker.php
RESULT=$(($RESULT+$?))

exit $RESULT
