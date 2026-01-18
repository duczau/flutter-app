allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

plugins {
    id("com.android.application") version "8.9.1" apply false
    id("com.android.library") version "8.9.1" apply false
    id("org.jetbrains.kotlin.android") version "1.9.10" apply false
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    
    // Fix compileSdk for dependencies like path_provider_android
    pluginManager.withPlugin("com.android.library") {
        configure<com.android.build.gradle.LibraryExtension> {
            if (compileSdk == 0) {
                compileSdk = 34
            }
        }
    }
    
    pluginManager.withPlugin("com.android.application") {
        configure<com.android.build.gradle.AppExtension> {
            if (compileSdk == 0) {
                compileSdk = 34
            }
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
