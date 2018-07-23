## android-builder

Build environment for Android applications. Assumes standard Android
Studio Gradle build structure.

Can be injected as build tool in CI / Jenkins or used locally from
command line.

To enable the Android Studio generated Gradle wrapper to install new
SDK packages as part of the Android project build, the Android SDK is
located in a volume where the build user has write permissions.

### Usage

#### Initialization

First step is to initialize the volume that will accomodate the
Android SDK. In this example the volume is named android-sdk, and the
ownership of its files is set to the docker host user:

    docker run -ti --rm --env "ANDROID_SDK_VOLUME_OWNERSHIP=$(id -u):$(id -g)" --mount source=android-sdk,destination=/home/android matslinden/android-builder --init

This will

* create a named volume to accomodate the Android SDK and, here named
  android-sdk
* set the correct file ownership
* download the Android tools and its sdkmanager to the volume
* let you to review and selectively accept the different Android SDK
  package licenses.

To check if the volume is initialized:

    docker run -t --rm -u "$(id -u):$(id -g)" --mount source=android-sdk,destination=/home/android matslinden/android-builder

The return code will indicate failure if the volume is not
initialized.

#### sdkmananger actions

To apply the Android sdkmanager actions to the android-sdk volume:

    docker run -ti --rm -u "$(id --user):$(id --group)" --mount source=android-sdk,destination=/home/android matslinden/android-builder <command>

Example of substitutions for `<command>` for some example use cases:

* Review and accept not yet accepted Android SDK package license on
  existing android-sdk volume: `sdkmanager --licenses`
* List installed packages on existing android-sdk volume: `sdkmanager
    --list`

#### Building an Android application

Run the Android Studio generated Gradle wrapper with its options and
targets as command to the container, for example:

    docker run -t --rm -u "$(id -u):$(id -g)" --mount source=android-sdk,destination=/home/android --mount type=bind,source="$PWD",destination=/myapp -w /myapp matslinden/android-builder /myapp/gradlew clean test

### Location caches

Java user.home provides a default for the following caches. This image
default is the android-sdk volume to make sure the build user has
write permissions.

* `ANDROID_SDK_HOME` Location of SDK related data/user files
  ([ref](https://developer.android.com/studio/command-line/variables)).
* `GRADLE_USER_HOME` Location of Gradle package downloads ([ref](
  https://docs.gradle.org/current/userguide/command_line_interface.html#_environment_options))
* Location of maven .m2 directory (needed example to use robolectric
  in the build,
  [ref](https://github.com/robolectric/robolectric/issues/3411))

There is also a project local build cache possible to control from
`gradlew --project-cache-dir` option. Default value is .gradle in the
project root directory,
([ref](https://docs.gradle.org/current/userguide/command_line_interface.html#_environment_options)).

### License

The files in the docker context (the github repo) are licensed
according to its LICENSE file.

As with all Docker images, these likely also contain other software
which may be under other licenses (such as Bash, etc from the base
distribution, along with any direct or indirect dependencies of the
primary software being contained).

The image entrypoint will download the Android SDK where you as a
minimum need to accept the "the Android Software Development Kit
License Agreement".

As for any pre-built image usage, it is the image user's
responsibility to ensure that any use of this image complies with any
relevant licenses for all software contained within.
