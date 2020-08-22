## Uses the TravisCI CLI client (https://github.com/travis-ci/travis.rb#command-line-client) to open 
## builds and related GH PRs currently failing or erroring




## This requires an alias/link 'firefox' pointing the 'firefox' binary
## Forces the creation of a new window
firefox --new-window
# Past this point, any invocation to "open URL" or "travis open" should use 
# the new browser window



function openFailures {
    TRAVIS_DOMAIN=$1
    BUILDS_OUTPUT=$(travis whatsup --$TRAVIS_DOMAIN)

    ## Sorcery to split a string with '\n' into an array of strings
    ## https://stackoverflow.com/questions/11746071/how-to-split-a-multi-line-string-containing-the-characters-n-into-an-array-of
    IFS=$'\n' read -d '' -ra BUILDS_ARRAY <<< "$BUILDS_OUTPUT"

    for BUILD in "${BUILDS_ARRAY[@]}" ; do
        if [[ $BUILD == *"errored"* || $BUILD == *"failed"* ]] ; then
            #echo $BUILD " is errored or failed"
            REPO=$(echo $BUILD | cut -d ' ' -f1)
            BUILD_NUMBER=$(echo $BUILD | cut -d '#' -f2)

            travis open $BUILD_NUMBER --repo $REPO --$TRAVIS_DOMAIN & 
            #travis open $BUILD_NUMBER --repo $REPO --$TRAVIS_DOMAIN -g & 

        fi
    done
}


function openTravisDashboards {
    open https://travis-ci.com/github/$1
    open https://travis-ci.org/github/$1
}


openTravisDashboards akka & 
openTravisDashboards playframework & 
openTravisDashboards lagom & 

openFailures com
openFailures org