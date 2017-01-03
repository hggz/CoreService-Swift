#make sure the simulator is running otherwise it'll hang...gotta find a better way to launch the simulator
SIMULATOR_ID=$(xcrun instruments -s | grep -o "iPhone 5 (10.1) \[.*\]" | grep -o "\[.*\]" | sed "s/^\[\(.*\)\]$/\1/")
echo $SIMULATOR_ID
set -o pipefail
xcodebuild -project CoreService.xcodeproj -scheme CoreService -sdk iphonesimulator -destination "id=$SIMULATOR_ID" clean test | xcpretty -c
