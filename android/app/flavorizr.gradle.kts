import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")

    productFlavors {
        create("dev") {
            dimension = "flavor-type"
            applicationId = "com.example.flutter_clean_architecture.dev"
            resValue(type = "string", name = "app_name", value = "Flutter Clean Architecture Dev")
        }
        create("staging") {
            dimension = "flavor-type"
            applicationId = "com.example.flutter_clean_architecture.staging"
            resValue(type = "string", name = "app_name", value = "Flutter Clean Architecture Staging")
        }
        create("prod") {
            dimension = "flavor-type"
            applicationId = "com.example.flutter_clean_architecture"
            resValue(type = "string", name = "app_name", value = "Flutter Clean Architecture Prod")
        }
    }
}